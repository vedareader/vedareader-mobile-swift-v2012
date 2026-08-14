//
//  BookReaderViewController.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 04/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "BookReaderViewController.h"

#import "BookContentsViewController.h"
#import "ReaderSearchViewController.h"
#import "ReaderSettingsViewController.h"
#import "ReaderAdditionalSettingsViewController.h"

#import "HolyContentManager.h"

#import "ChapterDescription.h"
#import "SearchResultItem.h"
#import "ReaderSettings.h"

#import "UIView+Autolayout.h"
#import "UIView+ActivityIndicator.h"

#import "BookInformation.h"
#import "Highlight.h"
#import "ReflowableViewController.h"
#import "SkyProvider.h"

#import "AppHelper.h"
#import "NSObject+NSNull.h"

#import "BookState.h"

#import "AppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>

#import "ShareData.h"
#import "ShareImageView.h"

#define kTopPanelPaddingTop 30.0
#define kTopPanelPaddingLeading 10.0
#define kTopPanelPaddingTrailing 10.0
#define kTopPanelGap 30.0

#define kBottomPanelBottom 12.0
#define kBottomPanelLeading 20.0
#define kBottomPanelTrailing 20.0

#define kBottomPanelPlayGap 17.0
#define kBottomPanelSliderBottom 51.0

static int const kFontSizes[] = { 10, 15, 17, 20, 24 };
#define kFontSizeCount (sizeof(kFontSizes) / sizeof(kFontSizes[0]))

#define kContentViewheight 115.0f
#define kContentViewPadding 25.0f
#define kTextLabelPadding 10.0f
#define kAnimationDuration 0.5f
#define kAnimationDelay 2.0f

@interface BookReaderViewController () <
	 UIPopoverPresentationControllerDelegate
	,ReflowableViewControllerDataSource
	,ReflowableViewControllerDelegate
	,SkyProviderDataSource
	,ReaderSettingsViewControllerDelegate
	,ReaderSearchViewControllerDelegate
	,BookContentsViewControllerDelegate
>
{
	BOOL _didLoad;

	NSMutableArray *_highlights;

	ReflowableViewController *_rv;
	
	NSArray *_controlViews;
	BOOL _controlViewsVisible;
	
	NSArray *_mediaViews;
	
	NSInteger _fontSizeIndex;
	
	BOOL _navigateToContents;
	BOOL _openSearchView;
	BOOL _isPaging;
	
	BOOL _showPause;
	BOOL _playbackFinished;
	BOOL _isPlaying;
	int _currentParallelPage;
	NSTimeInterval _currentIntervalEnd;
	
	CFTimeInterval _playbackStartTime;
}

@property (assign, nonatomic) IBOutlet UIView *vContent;

@property (assign, nonatomic) ReaderSearchViewController *searchVC;

@property (retain, nonatomic) NSMutableDictionary *pagingInfoByChapter;
@property (retain, nonatomic) NSMutableArray *chapters;

@property (assign, nonatomic) UIButton *btnSearch;
@property (retain, nonatomic) UIButton *btnSettings;

@property (assign, nonatomic) UIButton *btnPlay;
@property (assign, nonatomic) UISlider *playbackProgressSlider;

@property (assign, nonatomic) UILabel *lblChapterTitle;
@property (assign, nonatomic) UILabel *lblPageNumber;

@property (retain, nonatomic) NSTimer *playbackProgressTimer;

@property (retain, nonatomic) NSString *currentSelection;
@property (assign, nonatomic) CGRect selectionRect;

@property (retain, nonatomic) UIView *popoverScreen;

@property (retain, nonatomic) UINavigationController *navController;

@property (retain, nonatomic) ReaderSettings *readerSettings;


@end

@implementation BookReaderViewController

+ (instancetype)readerWithBookID:(NSInteger)bookID
{
	id result = [[[self alloc] initWithBookID:bookID] autorelease];
	
	return result;
}

- (instancetype)initWithBookID:(NSInteger)bookID
{
	self = [super init];
	if (self == nil)
	{
		return nil;
	}
	
	_bookID = bookID;
	
	[AppDelegate sharedInstance].readerController = self;

	self.readerSettings = [self loadReaderSettings];
	
	return self;
}

- (void)dealloc
{
	[AppDelegate sharedInstance].readerController = nil;
	
	int const pageIndexInChapter = [_rv pageIndexInChapter];
	double const pagePosition = [_rv getPagePositionInBook:pageIndexInChapter];
	BookState * const bookState = [BookState getByID:_bookID];
	bookState.pagePosition = pagePosition;
	
	NSString *fontName = _rv.book.fontName ?: @"";
	bookState.fontName = fontName;
	
	int const fontSize = kFontSizes[_fontSizeIndex];
	bookState.fontSize = fontSize;
	
	[bookState save];
	
	// WARNING: without all or some of the code below the reader might crash upon next launch.
	_rv.dataSource = nil;
	_rv.delegate = nil;
	_rv.customView = nil;
	[_rv removeFromParentViewController];
	[_rv.view removeFromSuperview];
	[_rv destroy];
	
	[_highlights release];
	[_controlViews release];
	[_mediaViews release];
	
	[_pagingInfoByChapter release];
	[_chapters release];
	
	[_playbackProgressTimer invalidate];
	[_playbackProgressTimer release];
	
	[_currentSelection release];
	
	[_btnSettings release];
	[_navController release];
	[_readerSettings release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	BookState * const bookState = [BookState getByID:_bookID];
	
	self.pagingInfoByChapter = [NSMutableDictionary dictionary];
	self.chapters = [NSMutableArray array];
	
	_highlights = [[NSMutableArray alloc] init];
	_fontSizeIndex = 1;
	
	ReflowableViewController *rv = [[[ReflowableViewController alloc] initWithStartPagePositionInBook:bookState.pagePosition] autorelease];
	_rv = [rv retain];
	
	[rv setLicenseKey:@"2ce5-7225-79e7-a8c1"];

	rv.dataSource = self;
	rv.delegate = self;
	
	rv.book.fileName = [NSString stringWithFormat:@"%ld.epub", (long)_bookID];
	rv.book.bookCode = 0;
	rv.baseDirectory = [HolyContentManager downloadsDirectory];
	
	rv.transitionType = [self.readerSettings getTransitionType];
	[rv setHorizontalGapRatio:0.25];
	[rv setVerticalGapRatio:0.25];
	
	SkyProvider *skyProvider = [[[SkyProvider alloc] init] autorelease];
	skyProvider.dataSource = self;
	skyProvider.book = rv.book;
	[rv setContentProvider:skyProvider];
	
	[rv showIndicatorWhilePaging:NO];
	[rv setGlobalPaging:YES];
	[rv setMenuControllerEnabled:YES];
	
	NSString * const fontName = bookState.fontName;
	if (fontName != nil)
	{
		int const fontSize = bookState.fontSize;
		_fontSizeIndex = kFontSizeCount;
		for (NSInteger i = 0; i < kFontSizeCount; ++i)
		{
			int const fontSize = kFontSizes[i];
			if (fontSize >= bookState.fontSize)
			{
				_fontSizeIndex = i;
				break;
			}
		}
		
		[_rv changeFontName:fontName fontSize:fontSize];
	}

	_currentParallelPage = -1;
	
	rv.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self.vContent addSubview:rv.view];
	[self addChildViewController:rv];
	
	[rv.view dockAll];
	
	// top panel
	UIButton *btnBack = [self addButtonWithImageNamed:@"arrow_back" forAction:@selector(btnBack_click:)];
	//20 - that is same digit used on BookDetailsViewController for back button on top pannel there.
	[btnBack alignTopWithPadding:UIApplication.sharedApplication.statusBarFrame.size.height/*kTopPanelPaddingTop - 5*/];
	[btnBack alignLeadingWithPadding:kTopPanelPaddingLeading];
	
	UIButton *btnSettings = [self addButtonWithImageNamed:@"icon_settings" forAction:@selector(btnSettings_click:)];
	UIButton *btnSearch = [self addButtonWithImageNamed:@"icon_search" forAction:@selector(btnSearch_click:)];
	self.btnSearch = btnSearch;
	self.btnSettings = btnSettings;
	
	UIButton *btnContents = [self addButtonWithImageNamed:@"icon_contents" forAction:@selector(btnChapters_click:)];
	
	[btnSettings alignAttribute:NSLayoutAttributeTop to:btnBack withPadding:0.0];
	
	[btnSearch alignAttribute:NSLayoutAttributeTop to:btnBack withPadding:0.0];
	[btnSearch pinLeadingTo:btnSettings withPadding:kTopPanelGap];
	
	[btnContents alignAttribute:NSLayoutAttributeTop to:btnBack withPadding:0.0];
	[btnContents alignTrailingWithPadding:kTopPanelPaddingTrailing];
	[btnContents pinLeadingTo:btnSearch withPadding:kTopPanelGap];
	
	if (IS_IPAD)
	{
		UILabel *lblChapterTitle = [[UILabel alloc] init];
		lblChapterTitle.translatesAutoresizingMaskIntoConstraints = NO;

		lblChapterTitle.numberOfLines = 0;
		lblChapterTitle.lineBreakMode = NSLineBreakByWordWrapping;
		lblChapterTitle.font = [UIFont fontWithName:kFontRegular size:17.0];
		lblChapterTitle.textAlignment = NSTextAlignmentCenter;

		[_rv.customView addSubview:lblChapterTitle];
		self.lblChapterTitle = lblChapterTitle;
		
		[lblChapterTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1 forAxis:UILayoutConstraintAxisHorizontal];
		
		[lblChapterTitle alignCenterXTo:_rv.customView];
		[lblChapterTitle alignCenterYTo:btnBack];
		
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:btnSettings
																	  attribute:NSLayoutAttributeLeading
																	  relatedBy:NSLayoutRelationGreaterThanOrEqual
																		 toItem:lblChapterTitle
																	  attribute:NSLayoutAttributeTrailing
																	 multiplier:1.0
																	   constant:10.0];
		constraint.active = YES;
	}
	
	// bottom panel
	UISlider *slider = [[UISlider alloc] init];
	self.playbackProgressSlider = slider;
	
	slider.translatesAutoresizingMaskIntoConstraints = NO;
	slider.userInteractionEnabled = NO;

	UIImage *sliderTrackImage = [UIImage imageNamed:@"slider_bg"];
	[slider setMinimumTrackImage:sliderTrackImage forState:UIControlStateNormal];
	[slider setMaximumTrackImage:sliderTrackImage forState:UIControlStateNormal];

	UIImage *thumbImage = [UIImage imageNamed:@"slider"];
	[slider setThumbImage:thumbImage forState:UIControlStateNormal];
	[rv.customView addSubview:slider];
	
	UIButton *btnPlay = [self createButtonWithImageNamed:@"play" forAction:@selector(btnPlay_click:)];
	self.btnPlay = btnPlay;
	[self.view addSubview:btnPlay];
	
	UILabel *lblPageNumber = [[UILabel alloc] init];
	lblPageNumber.translatesAutoresizingMaskIntoConstraints = NO;
	
	lblPageNumber.font = [UIFont fontWithName:kFontRegular size:10.0];
	lblPageNumber.textColor = [UIColor grayColor];
	lblPageNumber.textAlignment = NSTextAlignmentCenter;
	
	[self.view addSubview:lblPageNumber];
	self.lblPageNumber = lblPageNumber;
	
	[lblPageNumber alignBottomWithPadding:kBottomPanelBottom];

	if (IS_IPAD)
	{
		[lblPageNumber alignCenterXWithPadding:0.0];
	}
	else {
		[lblPageNumber alignTrailingWithPadding:15.0];
	}

	[btnPlay alignLeadingWithPadding:kBottomPanelLeading - 5.0];
	[btnPlay alignCenterYTo:slider];
	
	[slider alignBottomWithPadding:kBottomPanelSliderBottom];
	[slider pinLeadingTo:btnPlay withPadding:kBottomPanelPlayGap - 5.0];
	[slider alignTrailingWithPadding:kBottomPanelPlayGap];
	
	_controlViews = @[
					  // top panel
					  btnBack,
					  btnSettings,
					  btnSearch,
					  btnContents,
					  
					  // bottom panel
					  ];
	[_controlViews retain];
	
	_mediaViews = @[btnPlay, slider];
	[_mediaViews retain];

	_controlViewsVisible = YES;
	[self triggerPanelsVisibility];

	NSLog(@"font name: %@", rv.book.fontName);
	NSLog(@"font size: %d", rv.book.fontSize);
	
	NSLog(@"Base directory mine: %@", rv.baseDirectory);
	
	NSLog(@"media available: %d", rv.isMediaOverlayAvailable);
	
	__block typeof(self) _self = self;
	MPRemoteCommandCenter *const commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
	[commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
		[_self startPlayback];
		[_self updatePlaybackViews];
		
		return MPRemoteCommandHandlerStatusSuccess;
	}];
	
	[commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
		[_self pausePlayback];
		[_self updatePlaybackViews];
		
		return MPRemoteCommandHandlerStatusSuccess;
	}];
	
	[commandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
		[_self playPrev];
		
		return MPRemoteCommandHandlerStatusSuccess;
	}];
	
	[commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
		[_self playNext];
		
		return MPRemoteCommandHandlerStatusSuccess;
	}];
}

- (UIButton *)createButtonWithImageNamed:(NSString *)name forAction:(SEL)action
{
	UIButton *button = [[[UIButton alloc] init] autorelease];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *buttonImage = [UIImage imageNamed:name];
	[button setImage:buttonImage forState:UIControlStateNormal];
	
	button.contentMode = UIViewContentModeCenter;
	
	[button constraintWidth:42.0];
	[button constraintHeightRatio:1.0];
	
	return button;
}

- (UIButton *)addButtonWithImageNamed:(NSString *)name forAction:(SEL)action
{
	UIButton *button = [self createButtonWithImageNamed:name forAction:action];
	
	[_rv.customView addSubview:button];
	
	return button;
}

- (UIButton *)addButtonWithTitle:(NSString *)title forAction:(SEL)action
{
	UIButton *button = [[UIButton alloc] init];
	button.translatesAutoresizingMaskIntoConstraints = NO;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:kColorBlue forState:UIControlStateNormal];
	
	[_rv.customView addSubview:button];
	
	return button;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = YES;
	
	//GA
	[GAHelper logScreen:kScreenBookReader];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		if (!_isPaging)
		{
			PageInformation * const pageInformation = [[PageInformation alloc] init];
			pageInformation.pageIndexInBook = [_rv getPageIndexInBook];
			pageInformation.numberOfPagesInBook = [_rv getNumberOfPagesInBook];
			[self updatePageNumber:pageInformation];
		}
	}];
}

#pragma mark - Handlers
- (IBAction)topPanelDidTap:(id)sender
{
	NSLog(@"tap!");
	
	[self triggerPanelsVisibility];
}

- (IBAction)btnBack_click:(id)sender
{
	[self dismiss];
}

- (IBAction)btnSettings_click:(UIButton *)sender
{
	ReaderSettingsViewController *vc = [[[ReaderSettingsViewController alloc] initWithReaderSettings:self.readerSettings] autorelease];
	
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	[navController setNavigationBarHidden:YES];

	[self setupPreferredContentSizeForVC:navController controllerType:ReaderSettingTypeUnknown];
	
	vc.delegate = self;
	
	[self presentPopupViewController:navController forView:sender withCompletion:nil];
	
	self.navController = navController;
}

- (IBAction)btnSearch_click:(id)sender
{
	if (_isPaging)
	{
		_openSearchView = YES;
		[self.view showActivityIndicator];
		
		return;
	}
	
	[self openSearchView];
}

- (IBAction)btnChapters_click:(id)sender
{
	if (_isPaging)
	{
		_navigateToContents = YES;
		[self.view showActivityIndicator];
		
		return;
	}
	
	[self navigateToContents];
}

- (IBAction)btnPlay_click:(id)sender
{
	if ([_rv isPlayingPaused])
	{
		[self startPlayback];
	}
	else
	{
		[self pausePlayback];
	}
	
	[self updatePlaybackViews];
}

- (IBAction)btnPrev_click:(id)sender
{
	[self playPrev];
}

- (IBAction)btnNext_click:(id)sender
{
	[self playNext];
}

- (IBAction)btnClose_click:(id)sender
{
	[self dismiss];
}

#pragma mark - selection menu
- (void)showContextMenu
{
	UIMenuItem *itemShare = [[[UIMenuItem alloc] initWithTitle:Local(@"Share") action:@selector(share:)] autorelease];
	
	[[UIMenuController sharedMenuController] setMenuItems:@[ itemShare ]];
}


- (void)displaySelectionMenu:(Highlight *)highlight startRect:(CGRect)startRect endRect:(CGRect)endRect
{
	self.currentSelection = highlight.text;
	self.selectionRect = endRect;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	if (action == @selector(copy:))
	{
		return YES;
	}
	else if (action == @selector(share:))
	{
		return YES;
	}
	
	return NO;
}

- (void)copy:(id)sender
{
	[UIPasteboard generalPasteboard].string = self.currentSelection ?: @"";
}

- (void)share:(id)sender
{
	UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:Local(@"ShareDialog.Title") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	[alertVC addAction:[UIAlertAction actionWithTitle:Local(@"ShareDialog.Option.Text") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[self showActivityViewControllerWithString:self.currentSelection andImage:nil sharingText:YES];
	}]];
	
	[alertVC addAction:[UIAlertAction actionWithTitle:Local(@"ShareDialog.Option.Image") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		//NSString *chapterString = [NSString stringWithFormat:@"%@. %@", _rv.book.title, self.lblChapterTitle.text];
		ShareData *data = [[[ShareData alloc] initWithText:self.currentSelection authorName:_rv.book.creator chapter:_rv.book.title] autorelease];
		ShareImageView *shareImage = [[[ShareImageView alloc] initWithShareData:data] autorelease];
		
		UIView *view = [AppDelegate sharedInstance].window.rootViewController.view;
		[view insertSubview:shareImage belowSubview:self.view];
		[self showActivityViewControllerWithString:nil andImage:[shareImage renderedImage] sharingText:NO];
		
		// Save shareImage to disk for simplify debugging
		//[UIImagePNGRepresentation([shareImage renderedImage]) writeToFile:[[HolyContentManager downloadsDirectory] stringByAppendingPathComponent:@"ShareImage.png"] atomically:YES];
		
		[shareImage removeFromSuperview];
	}]];
	
	[alertVC addAction:[UIAlertAction actionWithTitle:Local(@"ShareDialog.Option.Cancel") style:UIAlertActionStyleCancel handler:nil]];
	
	if (IS_IPAD)
	{
		alertVC.popoverPresentationController.sourceRect = self.selectionRect;
		alertVC.popoverPresentationController.sourceView = self.view;
	}
	
	[self presentViewController:alertVC animated:YES completion:nil];
}

- (void)handleSharingWithString:(NSString *)str andImage:(UIImage *)img
{
	NSArray *items = nil;
	NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/vedareader/id1061609141?l=en&mt=8"];
	NSString *tag = @"#VedaReader";
	
	if (str != nil && str.length > 0)
		items = @[str, url, tag];
	else
		items = @[img]; // Only img because need instagram
	
	UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil] autorelease];
	activityVC.excludedActivityTypes = @[UIActivityTypePrint,
										 UIActivityTypePostToWeibo,
										 UIActivityTypeCopyToPasteboard,
										 UIActivityTypeAddToReadingList,
										 UIActivityTypePostToVimeo,
										 UIActivityTypeAirDrop,
										 UIActivityTypeMessage,
										 UIActivityTypeMail
										 ];
	
	if (IS_IPAD)
	{
		activityVC.popoverPresentationController.sourceRect = self.selectionRect;
		activityVC.popoverPresentationController.sourceView = self.view;
	}
	
	[self presentViewController:activityVC animated:YES completion:nil];
}

- (void)showActivityViewControllerWithString:(NSString *)str andImage:(UIImage *)img sharingText:(BOOL)isSharingText
{
	NSArray *items = nil;
	NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/ru/app/vedareader/id1061609141?l=en&mt=8"];
	NSString *tag = @"#VedaReader";
	
	if (str != nil && str.length > 0)
	{
		items = @[str, url, tag];
		
		UIPasteboard *pb = [UIPasteboard generalPasteboard];
		[pb setString:str];
	}
	else
		items = @[img]; // Only img because need instagram
	
	UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil] autorelease];
	activityVC.excludedActivityTypes = @[UIActivityTypePrint,
										 UIActivityTypePostToWeibo,
										 UIActivityTypeCopyToPasteboard,
										 UIActivityTypeAddToReadingList,
										 UIActivityTypePostToVimeo,
										 UIActivityTypeAirDrop,
										 UIActivityTypeMessage,
										 UIActivityTypeMail
										 ];
	
	if (IS_IPAD)
	{
		activityVC.popoverPresentationController.sourceRect = self.selectionRect;
		activityVC.popoverPresentationController.sourceView = self.view;
	}
	
	if (isSharingText)
	{
		self.navigationController.view.userInteractionEnabled = NO;
		UIView *backgroundView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
		[backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
		backgroundView.alpha = 0.0f;
		
		UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(kContentViewPadding, 0.0f, self.view.frame.size.width - 2 * kContentViewPadding, kContentViewheight)] autorelease];
		contentView.center = backgroundView.center;
		[contentView setBackgroundColor:RGB(78.0f, 84.0f, 98.0f)];
		contentView.alpha = 0.7f;
		contentView.layer.cornerRadius = 5.0f;
		
		UILabel *lblText = [[[UILabel alloc] initWithFrame:CGRectMake(kTextLabelPadding, 0, contentView.frame.size.width - 2 * kTextLabelPadding, contentView.frame.size.height)] autorelease];
		lblText.text = Local(@"BookReader.QuoteCopied");
		lblText.textColor = [UIColor whiteColor];
		lblText.font = [UIFont systemFontOfSize:17.0f];
		lblText.textAlignment = NSTextAlignmentCenter;
		lblText.numberOfLines = 0;
		
		[backgroundView addSubview:contentView];
		[contentView addSubview:lblText];
		
		[self.navigationController.view addSubview:backgroundView];
		
		[UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			backgroundView.alpha = 1.0f;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
				backgroundView.alpha = 0.0f;
			} completion:^(BOOL finished) {
				[backgroundView removeFromSuperview];
				//self.btnSave.enabled = YES;
				self.navigationController.view.userInteractionEnabled = YES;
				
				//[self handleSharingWithString:str andImage:img];
				[self presentViewController:activityVC animated:YES completion:nil];
			}];
		}];
		return;
	}
	else
	{
		[self presentViewController:activityVC animated:YES completion:nil];
		
		//[self handleSharingWithString:str andImage:img];
	}
}

- (void)showSuccessfullySavedView
{
	self.navigationController.view.userInteractionEnabled = NO;
	UIView *backgroundView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
	[backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
	backgroundView.alpha = 0.0f;
	
	UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(kContentViewPadding, 0.0f, self.view.frame.size.width - 2 * kContentViewPadding, kContentViewheight)] autorelease];
	contentView.center = backgroundView.center;
	[contentView setBackgroundColor:RGB(78.0f, 84.0f, 98.0f)];
	contentView.alpha = 0.7f;
	contentView.layer.cornerRadius = 5.0f;
	
	UILabel *lblText = [[[UILabel alloc] initWithFrame:CGRectMake(kTextLabelPadding, 0, contentView.frame.size.width - 2 * kTextLabelPadding, contentView.frame.size.height)] autorelease];
	lblText.text = Local(@"Цитата скопирована в буфер обмена.");
	lblText.textColor = [UIColor whiteColor];
	lblText.font = [UIFont systemFontOfSize:17.0f];
	lblText.textAlignment = NSTextAlignmentCenter;
	lblText.numberOfLines = 0;
	
	[backgroundView addSubview:contentView];
	[contentView addSubview:lblText];
	
	[self.navigationController.view addSubview:backgroundView];
	
	[UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
		backgroundView.alpha = 1.0f;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:kAnimationDuration delay:kAnimationDelay options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
			backgroundView.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[backgroundView removeFromSuperview];
			//self.btnSave.enabled = YES;
			self.navigationController.view.userInteractionEnabled = YES;
		}];
	}];
}

#pragma mark - BookContentsViewControllerDelegate
- (void)bookContentsViewController:(BookContentsViewController *)controller didSelectChapter:(NSInteger)chapterIndex
{
	NSInteger const bookPageIndex = [self bookPageForChapter:chapterIndex page:0];
	[self gotoPageInBook:bookPageIndex];
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
	return UIModalPresentationNone;
}

- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
{
	UIView *popoverScreen = [[[UIView alloc] init] autorelease];
	popoverScreen.translatesAutoresizingMaskIntoConstraints = NO;
	
	popoverScreen.backgroundColor = [UIColor blackColor];
	popoverScreen.alpha = 0.5;
	
	[self.view addSubview:popoverScreen];
	[popoverScreen dockAll];
	
	self.popoverScreen = popoverScreen;
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
	[self.popoverScreen removeFromSuperview];
	self.popoverScreen = nil;
	
	[self saveReaderSettings];
}

#pragma mark - ReaderSettingsViewControllerDelegate
- (void)readerSettingsViewControllerDidDecreaseFontSize:(ReaderSettingsViewController *)controller
{
	NSInteger newFontSize = _fontSizeIndex - 1;
	if (newFontSize < 0)
	{
		return;
	}
	
	_fontSizeIndex = newFontSize;
	
	[self updateFontSize];
}

- (void)readerSettingsViewControllerDidIncreaseFontSize:(ReaderSettingsViewController *)controller
{
	NSInteger newFontSize = _fontSizeIndex + 1;
	if (newFontSize >= kFontSizeCount)
	{
		return;
	}
	
	_fontSizeIndex = newFontSize;
	
	[self updateFontSize];
}

- (void)readerSettingsViewControllerDidPressedFontSelection:(ReaderSettingsViewController *)controller
{
	ReaderAdditionalSettingsViewController *vc = [[[ReaderAdditionalSettingsViewController alloc] initWithType:ReaderSettingTypeFont settings:self.readerSettings actionBlock:^(NSString *fontName) {
		[self updateFontWithFont:fontName];
	} backAction:^(ReaderSettings *settings) {
		[controller fillWithData:settings];
	}] autorelease];
	
	//[self setupPreferredContentSizeForVC:vc controllerType:ReaderSettingTypeFont];
	[vc setPreferredContentSize:self.preferredContentSize];
	
	[self.navController pushViewController:vc animated:YES];
	[self.navController setNavigationBarHidden:NO];
}

- (void)readerSettingsViewControllerDidPressedTransitionStyleSelection:(ReaderSettingsViewController *)controller
{
	ReaderAdditionalSettingsViewController *vc = [[[ReaderAdditionalSettingsViewController alloc] initWithType:ReaderSettingTypeTransition settings:self.readerSettings actionBlock:^(NSString *transitionName) {
		[self updateTransitionStyleWithTransitionName:transitionName];
	} backAction:^(ReaderSettings *settings) {
		[controller fillWithData:settings];
		[self setupPreferredContentSizeForVC:self.navController controllerType:ReaderSettingTypeUnknown];
	}] autorelease];
	
	[self setupPreferredContentSizeForVC:vc controllerType:ReaderSettingTypeTransition];
	
	[self.navController pushViewController:vc animated:YES];
	[self.navController setNavigationBarHidden:NO];
}

#pragma mark - ReaderSearchViewControllerDelegate
- (void)readerSearchViewController:(ReaderSearchViewController *)controller searchWithText:(NSString *)text
{
	[_rv stopSearch];
	[_rv searchKey:text];
}

- (void)readerSearchViewControllerCancelSearch:(ReaderSearchViewController *)controller
{
	[_rv stopSearch];
}

- (void)readerSearchViewController:(ReaderSearchViewController *)controller didSelectSearchResult:(SearchResultItem *)searchResult
{
	[_rv stopSearch];

	NSInteger const bookPageIndex = searchResult.pageIndex - 1;
	[self gotoPageInBook:bookPageIndex];
	
	// Because popoverPresentationControllerDidDismissPopover method is not called when the popover is dimissed programatically we need do it manualy.
	[self.popoverScreen removeFromSuperview];
	self.popoverScreen = nil;
}

#pragma mark - Reading Delegate
-(void)reflowableViewController:(ReflowableViewController*)rvc didSearchKey:(SearchResult*)searchResult
{
	NSString *chapterTitle = searchResult.chapterTitle ?: @"";
	
	NSInteger const chapterIndex = searchResult.chapterIndex;
	NSInteger const pageIndex = searchResult.pageIndex;
	NSInteger const bookPageIndex = [self bookPageForChapter:chapterIndex page:pageIndex];
	
	SearchResultItem *item = [[[SearchResultItem alloc] init] autorelease];
	item.chapterIndex = searchResult.chapterIndex + 1;
	item.chapterTitle = chapterTitle;
	item.pageIndex = bookPageIndex + 1;
	
	NSUInteger const maxIndex = MIN(searchResult.text.length, 50);
	item.text = [searchResult.text substringToIndex:maxIndex];
	
	[self.searchVC addSearchResult:item];
	
	NSLog(@"found key: %@", searchResult.text);
}

- (void)reflowableViewController:(ReflowableViewController *)rvc didFinishSearchForChapter:(SearchResult *)searchResult
{
	NSLog(@"finished search for chapter: %d", searchResult.chapterIndex);
	
	[_rv pauseSearch];
	[_rv searchMore];
}

- (void)reflowableViewController:(ReflowableViewController *)rvc didFinishSearchAll:(SearchResult *)searchResult
{
	NSLog(@"found: %@", searchResult.text);
	
	NSLog(@"debugDescription: %@", [_rv debugDescription]);
}

-(NSMutableArray*)reflowableViewController:(ReflowableViewController*)rv highlightsForChapter:(NSInteger)chapterIndex {
	NSMutableArray *highlights;
	highlights = [self fetchHighlights:0 chapterIndex:(int)chapterIndex];
	return highlights;
}

-(void)reflowableViewController:(ReflowableViewController*)rv
    insertHighlight:(Highlight*)highlight {
	NSLog(@"insertHighlight(%@) Detected at %d %d %d %d",highlight.text,highlight.startIndex,highlight.startOffset,highlight.endIndex,highlight.endOffset);
	[self insertHighlight:highlight];
}

-(void)reflowableViewController:(ReflowableViewController*)rv deleteHighlight:(Highlight*)highlight {
	NSLog(@"deleteHighlight(%@) Detected at %d %d %d %d",highlight.text,highlight.startIndex,highlight.startOffset,highlight.endIndex,highlight.endOffset);
	[self deleteHighlight:highlight];
}

-(NSInteger)reflowableViewController:(ReflowableViewController*)rvc numberOfPagesForPagingInformation:(PagingInformation*)pagingInformation
{
	if (pagingInformation == nil)
	{
		NSLog(@"nil paging information");
		
		return 0;
	}
	
	PagingInformation * const storedPagingInformation = [self.pagingInfoByChapter objectForKey:@(pagingInformation.chapterIndex)];
	
	return storedPagingInformation.numberOfPagesInChapter;
}

- (void)reflowableViewController:(ReflowableViewController *)rvc
				  didSelectRange:(Highlight *)highlight
					   startRect:(CGRect)startRect
						 endRect:(CGRect)endRect
{
	NSLog(@"Selection(%@) Detected at %d %d %d %d",highlight.text,highlight.startIndex,highlight.startOffset,highlight.endIndex,highlight.endOffset);
	
	[self displaySelectionMenu:highlight startRect:startRect endRect:endRect];
	
	[self showContextMenu];
}

-(void)reflowableViewController:(ReflowableViewController*)rv didDetectTapAtPosition:(CGPoint)position
{
	NSLog(@"tap Detected in BookView at (%f,%f)",position.x, position.y);
	
	[self triggerPanelsVisibility];
}

-(void)reflowableViewController:(ReflowableViewController*)rv didDetectDoubleTapAtPosition:(CGPoint)position{
	NSLog(@"double Tap Detected in BookView at (%f,%f)",position.x, position.y);
}

-(void)reflowableViewController:(ReflowableViewController*)rv didHitHighlight:(Highlight*)highlight atPosition:(CGPoint)position{
	NSLog(@"Highlight(%@ %d %d %d %d) Detected at (%f %f)",highlight.text,highlight.startIndex,highlight.startOffset,highlight.endIndex,highlight.endOffset,position.x,position.y);
}

-(void)reflowableViewController:(ReflowableViewController*)rv pageMoved:(PageInformation*)pageInformation{
	NSLog(@"pageMoved to %ld", (long)pageInformation.pageIndexInBook);

	[self updatePageNumber:pageInformation];
	
/*
	info = pageInformation;
	NSLog(@"CCI:%d CPI:%d NCB:%d NPC:%d PPB:%f PPC:%f SI:%d EI:%d",
			pageInformation.chapterIndex,
			pageInformation.pageIndex,
			pageInformation.numberOfChaptersInBook,
			pageInformation.numberOfPagesInChapter,
			pageInformation.pagePositionInBook,
			pageInformation.pagePositionInChapter,
			pageInformation.startIndex,
			pageInformation.endIndex);
	NSLog(@"pageIndex:%d pageCount:%d ",pageInformation.pageIndex,pageInformation.numberOfPagesInChapter);
*/
	for (int i=0; i<[pageInformation.highlightsInPage count]; i++) {
		Highlight* highlight = [pageInformation.highlightsInPage objectAtIndex:i];
		NSLog(@"%@ at (%d:%d) so:%d si:%d eo:%d ei:%d ",highlight.text,highlight.left,highlight.top,highlight.startIndex,highlight.startOffset,highlight.endIndex,highlight.endOffset);
	}
}

/** called when global pagination for all chapters is started */
-(void)reflowableViewController:(ReflowableViewController*)rvc didStartPaging:(int)bookCode
{
	_isPaging = YES;
	
	[self.pagingInfoByChapter removeAllObjects];
	[self.chapters removeAllObjects];
}

/** called when paginating one chapter is over. */
-(void)reflowableViewController:(ReflowableViewController*)rvc didPaging:(PagingInformation*)pagingInformation
{
	[self.pagingInfoByChapter setObject:pagingInformation forKey:@(pagingInformation.chapterIndex)];
}

/** called when global pagination for all chapters is finished */
-(void)reflowableViewController:(ReflowableViewController*)rvc didFinishPaging:(int)bookCode
{
	int const chapterCount = [_rv getNumberOfChaptersInBook];
	NSInteger pageIndex = 0;
	for (int i = 0; i < chapterCount; ++i)
	{
		PagingInformation * const pagingInformation = [self.pagingInfoByChapter objectForKey:@(i)];
		if (pagingInformation == nil)
		{
			continue;
		}
		
		ChapterDescription * const chapterDescription = [[[ChapterDescription alloc] init] autorelease];
		chapterDescription.title = [_rv.book getChapterTitle:i];
		chapterDescription.index = pagingInformation.chapterIndex;
		chapterDescription.pageIndex = pageIndex;
		
		pageIndex += pagingInformation.numberOfPagesInChapter;
		
		[self.chapters addObject:chapterDescription];
	}
	
	_isPaging = NO;
	
	[self updateChapterTitle:[_rv getPageInformation].chapterIndex];
	
	PageInformation * const pageInformation = [[PageInformation alloc] init];
	pageInformation.pageIndexInBook = [_rv getPageIndexInBook];
	pageInformation.numberOfPagesInBook = [_rv getNumberOfPagesInBook];
	[self updatePageNumber:pageInformation];
	
	if (_navigateToContents)
	{
		_navigateToContents = NO;
		[self.view hideActivityIndicator];
		[self navigateToContents];
	}
	
	if (_openSearchView)
	{
		_openSearchView = NO;
		[self.view hideActivityIndicator];
		[self openSearchView];
	}
}

- (void)reflowableViewController:(ReflowableViewController*)rvc didChapterLoad:(int)chapterIndex
{
	NSLog(@"reflowableViewController:didChapterLoad:%d", chapterIndex);
	
	[self updateChapterTitle:chapterIndex];
	
	[self updateMediaViewsVisibility];
	
	if ([_rv isMediaOverlayAvailable])
	{
		int count = [_rv parallelCountInChapter];
		NSLog(@"parallel count: %d", count);
	}
	
	BOOL playbackStarted = [_rv isPlayingStarted];
	BOOL paused = [_rv isPlayingPaused];
	
	NSLog(@"%@", @[@(playbackStarted), @(paused)]);
	
	self.playbackProgressSlider.value = self.playbackProgressSlider.minimumValue;
	if (_isPlaying)
	{
		if (![_rv isMediaOverlayAvailable])
		{
			[self pausePlayback];
			[self updatePlaybackViewsCore:YES];
			self.playbackProgressSlider.value = self.playbackProgressSlider.minimumValue;
			
			return;
		}
		
		[_rv playFirstParallelInPage];
		[self updatePlaybackViews];
	}
	
	if (_didLoad)
	{
		return;
	}
	
	_didLoad = YES;
	[self triggerPanelsVisibility];
}

- (void)pageTransitionStarted:(ReflowableViewController*)rvc
{
	NSLog(@"pageTransitionStarted");
}

- (void)pageTransitionEnded:(ReflowableViewController*)rvc
{
	[_rv.customView setNeedsLayout];

	NSLog(@"pageTransitionEnded");
}

- (void)reflowableViewController:(ReflowableViewController*)rvc parallelDidStart:(Parallel*)parallel
{
	int count = [_rv parallelCountInChapter];
	NSLog(@"parallel count: %d", count);
	
	_playbackFinished = NO;
	[self updatePlaybackViews];
	
	if (parallel.parallelIndex == 0 || parallel.pageIndex != _currentParallelPage)
	{
		_currentParallelPage = parallel.pageIndex;
		
		NSTimeInterval intervalBegin = parallel.audio.intervalBegin;
		NSTimeInterval intervalEnd = parallel.audio.intervalEnd;

		int const parallelCount = [_rv parallelCountInChapter];
		for (int i = parallel.parallelIndex; i < parallelCount; ++i)
		{
			Parallel * const parallel = [_rv getParallelByIndex:i];
			if (parallel.pageIndex != _currentParallelPage)
			{
				break;
			}
			
			Audio * const audio = parallel.audio;
			if (audio == nil)
			{
				continue;
			}
			
			intervalEnd = audio.intervalEnd;
		}
		
		self.playbackProgressSlider.minimumValue = intervalBegin;
		self.playbackProgressSlider.maximumValue = intervalEnd;
	}

	Audio * const audio = parallel.audio;
	self.playbackProgressSlider.value = audio.intervalBegin;
	_currentIntervalEnd = audio.intervalEnd;
	
	[self startPlaybackProgressTimer];
	
	NSLog(@"playing parallel %d for page %d", parallel.parallelIndex, parallel.pageIndex);
	NSLog(@"start time: %@, end time: %@", audio.clipBegin, audio.clipEnd);
	
	NSLog(@"slider enabled: %d", self.playbackProgressSlider.userInteractionEnabled);
	
	if ([_rv pageIndexInChapter] != parallel.pageIndex)
	{
		[_rv gotoPageInChapter:parallel.pageIndex];
	}
}

- (void)reflowableViewController:(ReflowableViewController*)rvc parallelDidEnd:(Parallel*)parallel
{
	if (_playbackFinished)
	{
		[_rv stopPlayingParallel];
	}
	
	_playbackFinished = YES;
	
	[self updatePlaybackViews];
	
	[self stopPlaybackProgressTimer];

	Audio * const audio = parallel.audio;
	self.playbackProgressSlider.value = audio.intervalEnd;
	
	NSLog(@"stopped playing parallel %d for page %d", parallel.parallelIndex, parallel.pageIndex);
}

-(void)parallesDidEnd:(ReflowableViewController *)rvc
{
	BOOL playbackStarted = [_rv isPlayingStarted];
	BOOL paused = [_rv isPlayingPaused];
	
	NSLog(@"%@", @[@(playbackStarted), @(paused)]);
	
	[_rv gotoNextChapter];
}

- (void)reflowableViewController:(ReflowableViewController *)rvc didHitLink:(NSString *)urlString
{
	if (![urlString hasPrefix:@"http"])
	{
		return;
	}
	
	[AppHelper openURL:urlString];
}

#pragma mark - private
- (BOOL)isSameHighlight:(Highlight*)first as:(Highlight*)second
{
	BOOL const result =
		first.bookCode == second.bookCode &&
		first.startIndex == second.startIndex &&
		first.endIndex == second.endIndex &&
		first.startOffset == second.startOffset &&
		first.endOffset == second.endOffset &&
		first.chapterIndex == second.chapterIndex;

	return result;
}

- (void)insertHighlight:(Highlight*)highlight
{
	[_highlights addObject:highlight];
}

- (void)deleteHighlight:(Highlight*)highlight
{
	NSInteger index = 0;
	for (Highlight *ht in _highlights)
	{
		if ([self isSameHighlight:highlight as:ht])
		{
			[_highlights removeObjectAtIndex:index];
			break;
		}
		
		++index;
	}
}

- (NSMutableArray *)fetchHighlights:(int)bookCode chapterIndex:(int)chapterIndex
{
	NSMutableArray *results = [NSMutableArray array];
	for (Highlight *ht in _highlights)
	{
		if (ht.bookCode == bookCode && ht.chapterIndex == chapterIndex)
		{
			[results addObject:ht];
		}
	}

	return results;
}

- (void)triggerPanelsVisibility
{
	_controlViewsVisible = !_controlViewsVisible;
	
	CGFloat newAlpha = _controlViewsVisible ? 1.0 : 0.0;
	__block typeof(self) _self = self;
	[UIView animateWithDuration:0.3 animations:^{
		for (UIView *view in _self->_controlViews)
		{
			view.alpha = newAlpha;
		}
	} completion:^(BOOL finished) {
		if (!finished)
		{
			return;
		}
		
		for (UIView *view in _self->_controlViews)
		{
			view.userInteractionEnabled = _self->_controlViewsVisible;
		}
	}];
	
	[self updateMediaViewsVisibility];
}

- (void)updateMediaViewsVisibility
{
	BOOL mediaViewsVisible = _controlViewsVisible;
	BOOL const isAudioContentAvailable = [_rv isMediaOverlayAvailable];
	if (!isAudioContentAvailable)
	{
		mediaViewsVisible = NO;
	}
	
	CGFloat const newAlpha = mediaViewsVisible ? 1.0 : 0.0;
	__block typeof(self) _self = self;
	[UIView animateWithDuration:0.3 animations:^{
		for (UIView *view in _self->_mediaViews)
		{
			view.alpha = newAlpha;
		}
	} completion:^(BOOL finished) {
		if (!finished)
		{
			return;
		}
		
		for (UIView *view in _self->_mediaViews)
		{
			view.userInteractionEnabled = _self->_controlViewsVisible;
		}
		
		_self.playbackProgressSlider.userInteractionEnabled = NO;
	}];
}

- (void)dismiss
{
	__block BOOL animatedDismission = YES;
	__block typeof(self) _self = self;
	void (^dismissAction)() = ^ {
		[_self stopPlaybackProgressTimer];
		[_self dismissViewControllerAnimated:animatedDismission completion:nil];
	};
	
	if (self.presentedViewController != nil)
	{
		animatedDismission = NO;
		
		[self.presentedViewController dismissViewControllerAnimated:NO completion:dismissAction];
		
		return;
	}
	
	dismissAction();
}

- (void)updateFontSize
{
	int const fontSize = kFontSizes[_fontSizeIndex];
	NSString *fontName = _rv.book.fontName ?: @"";
	
	[_rv changeFontName:fontName fontSize:fontSize];
}

- (void)updateFontWithFont:(NSString *)fontName
{
	_rv.book.fontName = fontName;
	self.readerSettings.fontName = fontName;
	
	[_rv changeFontName:fontName fontSize:_rv.book.fontSize];
}

- (void)updateTransitionStyleWithTransitionName:(NSString *)transitionName
{
	self.readerSettings.transitionName = transitionName;
	_rv.transitionType = [self.readerSettings getTransitionType];
}

- (void)presentPopupViewController:(UIViewController *)vc forView:(UIView *)sourceView withCompletion:(void (^)())completion
{
	vc.modalPresentationStyle = UIModalPresentationPopover;
	
	UIPopoverPresentationController *presentationController = [vc popoverPresentationController];
	presentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
	presentationController.delegate = self;
	presentationController.sourceView = sourceView;
	
	NSLog(@"sourceView.bounds: %@", NSStringFromCGRect(sourceView.bounds));
	CGRect const sourceBounds = CGRectChangeHeight(sourceView.bounds, -13.0);
	presentationController.sourceRect = sourceBounds;
	
	self.definesPresentationContext = true;
	[self presentViewController:vc animated:YES completion:completion];
}

- (NSInteger)bookPageForChapter:(NSInteger)chapterIndex page:(NSInteger)pageIndex
{
	if (chapterIndex < 0 || chapterIndex >= self.chapters.count)
	{
		return -1;
	}
	
	ChapterDescription * const chapterDescription = self.chapters[chapterIndex];
	NSInteger const bookPageIndex = chapterDescription.pageIndex + pageIndex;

	return bookPageIndex;
}

- (void)gotoPageInBook:(NSInteger)pageIndex
{
	if (pageIndex < 0)
	{
		return;
	}
	
	double const pagePosition = [_rv getPagePositionInBookByPageIndexInBook:(int)(pageIndex)];
	[_rv gotoPageByPagePositionInBook:pagePosition];
}

- (void)openSearchView
{
	ReaderSearchViewController *vc = [[[ReaderSearchViewController alloc] init] autorelease];
	
	if (IS_IPHONE)
	{
		CGSize const currentSize = self.view.frame.size;
		vc.preferredContentSize = CGSizeMake(currentSize.width - 12.0, 300.0);
	}
	
	vc.delegate = self;
	
	self.searchVC = vc;
	
	[self presentPopupViewController:vc forView:self.btnSearch withCompletion:nil];
}

- (void)navigateToContents
{
	BookContentsViewController *vc = [[[BookContentsViewController alloc] initWithBookViewController:_rv chapters:self.chapters] autorelease];
	vc.delegate = self;
	self.navigationController.navigationBarHidden = NO;
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)startPlaybackProgressTimer
{
	_playbackStartTime = CACurrentMediaTime();
	
	[self stopPlaybackProgressTimer];
	self.playbackProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																  target:self
																selector:@selector(playbackProgressTimerDidFire:)
																userInfo:nil
																 repeats:YES];
}

- (void)stopPlaybackProgressTimer
{
	[self.playbackProgressTimer invalidate];
}

- (void)playbackProgressTimerDidFire:(id)sender
{
	CFTimeInterval const currentTime = CACurrentMediaTime();
	CFTimeInterval const elapsedTime = currentTime - _playbackStartTime;
	_playbackStartTime = currentTime;
	
	CFTimeInterval newValue = self.playbackProgressSlider.value + elapsedTime;
	newValue = MIN(newValue, _currentIntervalEnd);
	
	self.playbackProgressSlider.value = newValue;
}

- (ReaderSettings *)loadReaderSettings
{
	NSData *encodedObjData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReaderSettings"];
	ReaderSettings *readerSettings = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObjData];
	
	return readerSettings ?: [ReaderSettings createDefaultSettings];
}

- (BOOL)saveReaderSettings
{
	if (!self.readerSettings)
	{
		NSLog(@"Try to save reader settings which not exists!");
		return NO;
	}
	
	NSData *encodedObjData = [NSKeyedArchiver archivedDataWithRootObject:self.readerSettings];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:encodedObjData forKey:@"ReaderSettings"];
	
	return [defaults synchronize];
}

- (void)setupPreferredContentSizeForVC:(UIViewController *)vc controllerType:(ReaderSettingType)type
{
	CGSize const currentSize = self.view.frame.size;
	if ([vc isKindOfClass:[UINavigationController class]])
	{
		if (IS_IPHONE)
			vc.preferredContentSize = CGSizeMake(currentSize.width - 12.0, 200.0);
		else
			vc.preferredContentSize = CGSizeMake(301.0, 200.0);
	}
	else
	{
		CGFloat height = 200.0;
		CGFloat width = 301.0;
		/*if (type == ReaderSettingTypeTransition)
		{
			height = 96.0 + 44.0;
			width = 401.0;
		}*/
		
		if (IS_IPHONE)
			//self.navController.preferredContentSize = CGSizeMake(currentSize.width - 12.0, height);
			vc.preferredContentSize = CGSizeMake(currentSize.width - 12.0, height);
		else
			//self.navController.preferredContentSize = CGSizeMake(width, height);
			vc.preferredContentSize = CGSizeMake(width, height);
	}
}

#pragma mark - playback controls
- (void)startPlayback
{
	_isPlaying = YES;
	
	if (![_rv isPlayingPaused])
	{
		return;
	}
	
	if ([_rv isPlayingStarted])
	{
		[_rv resumePlayingParallel];
		
		[self startPlaybackProgressTimer];
	}
	else
	{
		[_rv playFirstParallelInPage];
	}
}

- (void)pausePlayback
{
	_isPlaying = NO;
	
	if ([_rv isPlayingPaused])
	{
		return;
	}
	
	[_rv pausePlayingParallel];
	[self stopPlaybackProgressTimer];
}

- (void)playPrev
{
	[_rv playPrevParallel];
}

- (void)playNext
{
	[_rv playNextParallel];
}

- (void)updatePlaybackViews
{
	[self updatePlaybackViewsCore:[_rv isPlayingPaused]];
}

- (void)updatePlaybackViewsCore:(BOOL)playbackPaused
{
	UIImage *buttonImage = nil;
	
	if (playbackPaused)
	{
		if (!_showPause)
		{
			return;
		}
		
		_showPause = NO;
		
		buttonImage = [UIImage imageNamed:@"play"];
	}
	else
	{
		if (_showPause)
		{
			return;
		}
		
		_showPause = YES;
		
		buttonImage = [UIImage imageNamed:@"pause"];
	}
	
	[self.btnPlay setImage:buttonImage forState:UIControlStateNormal];
}

- (void)updatePageNumber:(PageInformation *)pageInformation
{
	NSInteger pageIndex = pageInformation.pageIndexInBook;
	NSInteger pageCount = pageInformation.numberOfPagesInBook;

	if (pageCount == 0)
	{
		self.lblPageNumber.text = @"";

		return;
	}

	if (_rv.isDoublePaged)
	{
		pageIndex = pageIndex * 2 + 1;
		pageCount = pageCount * 2;
	}
	else
	{
		pageIndex = pageIndex + 1;
		pageCount = pageCount;
	}
	
	self.lblPageNumber.text = [NSString stringWithFormat:Local(@"BookReader.PageNumberFormat"), (long)pageIndex, (long)pageCount];
}

- (void)updateChapterTitle:(NSInteger)chapterIndex
{
	if (!IS_IPAD)
	{
		return;
	}
	
	if (!_isPaging && chapterIndex < self.chapters.count)
	{
		ChapterDescription * const chapter = self.chapters[chapterIndex];
		self.lblChapterTitle.text = chapter.title;
	}
}

@end
