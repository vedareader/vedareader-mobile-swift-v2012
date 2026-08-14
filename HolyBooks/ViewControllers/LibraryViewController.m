//
//  LibraryViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "LibraryViewController.h"
#import "BookDetailsViewController.h"
#import "HolyClasses.h"
#import "Settings.h"

#import "UIViewController+CustomDraw.h"
#import "UIView+Autolayout.h"
#import "UIImage+Background.h"
#import "NSArray+LINQ.h"
#import "NSObject+NSNull.h"
#import "AppHelper.h"

#import "ShareData.h"
#import "ShareImageView.h"
#import "AppDelegate.h"

#define kBannersAndHorizontalListPadding 10

@interface LibraryViewController ()

@property (nonatomic, retain) SelectLanguageViewController *selectLanguageViewController;

//@property (nonatomic, retain) NSArray *filteredBooks; //original
@property (nonatomic, retain) NSMutableArray *filteredBooks; //test

@end

@implementation LibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (@available(iOS 11, *))
	{
	}
	else
		self.edgesForExtendedLayout = UIRectEdgeNone;

	//Navigation buttons
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"icon_menu" action:@selector(btnMenu_Click:)];
	self.title = Local(@"Library.Title");
	UIImage *icon = [UIImage imageNamed:@"icon_settings_main"];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(btnLanguage_Click:)]; //[[UIBarButtonItem alloc] initWithTitle:Local(@"Library.Language") style:UIBarButtonItemStylePlain target:self action:@selector(btnLanguage_Click:)];
	
	//Background
	_colBooks.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage backgroundImage]] autorelease];
	
	//Update content
	[[HolyContentManager sharedManager] loadFromCache];
	//[self filterBooks];
	[[HolyContentManager sharedManager] updateWithSuccess:^{
		[_bvBanners layoutSubviews];

		[self filterBooks];
		[_colBooks reloadData];
	} error:^{
		NSLog(@"Error updating content");
	}];
	
	[_colBooks registerNib:[UINib nibWithNibName:@"VerticalBookListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VerticalBookListCollectionViewCell"];
	[_colBooks registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
	self.colCollection = _colBooks;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Navigation
	self.navigationController.navigationBarHidden = NO;
	
	[self.delegate mainMenuResumeInteracting];
		
	//GA
	[GAHelper logScreen:kScreenLibrary];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	//NSLog(@"Library viewWillLayoutSubviews");

	NSLayoutConstraint *heightConstraint = [_hblRecommendations heightConstraint];
	if (heightConstraint != nil)
		heightConstraint.constant = kHorizontalBookListHeight;
	
	[_colBooks setNeedsLayout];
	
	_imgDivider.alpha = (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact);
	
//	NSLog(@"Library controller size class: %ld", (long)self.traitCollection.horizontalSizeClass);
//	NSLog(@"Library view size class: %ld", (long)self.view.traitCollection.horizontalSizeClass);
//	NSLog(@"Horizontal list size class: %ld", (long)_hblRecommendations.traitCollection.horizontalSizeClass);
	
	[_colBooks.collectionViewLayout invalidateLayout];
	
	//[self printAllRespondersForView:_imgDivider];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
	[super traitCollectionDidChange:previousTraitCollection];
	
	//NSLog(@"LibraryViewController traitCollectionDidChange");
	
	[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	[_colBooks reloadData];
	
	if (_selectLanguageViewController != nil)
	{
		_selectLanguageViewController.horizontalSizeClass = self.traitCollection.horizontalSizeClass;
		//[_selectLanguageViewController horizontalSizeClassDidSet];
	}
}

//- (void)printAllRespondersForView: (UIView *)view
//{
//	NSObject *responder = [view nextResponder];
//	while (responder != nil)
//	{
//		NSLog(@"Responder: %@", responder);
//		
//		if ([responder isKindOfClass:[UIView class]])
//			responder = [(UIView *)responder nextResponder];
//		else if ([responder isKindOfClass:[UIViewController class]])
//			responder = [(UIViewController *)responder nextResponder];
//		else
//			responder = nil;
//	}
//}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	//NSLog(@"Library viewDidLayoutSubviews");
}

- (void)dealloc
{
	[_bvBanners release];
	[_hblRecommendations release];
	[_imgDivider release];
    [_colBooks release];
	[super dealloc];
}

#pragma mark - Private
- (UIView *)headerView
{
	UIView *vHeader = [[[UIView alloc] init] autorelease];
	//vHeader.backgroundColor = [UIColor magentaColor];
	
	//Banners
	_bvBanners = [[BannerView alloc] init];
	[self fillBannerImages];
	_bvBanners.delegate = self;
	
	[vHeader addSubview:_bvBanners];
	_bvBanners.translatesAutoresizingMaskIntoConstraints = NO;
	[_bvBanners alignTopWithPadding:0];
	[_bvBanners alignLeadingWithPadding:0];
	[_bvBanners alignTrailingWithPadding:0];
	
	//Horizontal list
	self.hblRecommendations = [HorizontalBookList create];
	_hblRecommendations.delegate = self;
	[vHeader addSubview:_hblRecommendations];
	
	_hblRecommendations.translatesAutoresizingMaskIntoConstraints = NO;
	[_hblRecommendations alignLeadingWithPadding:0];
	[_hblRecommendations alignTrailingWithPadding:0];
	[_hblRecommendations pinTopTo:_bvBanners withPadding:kBannersAndHorizontalListPadding];
	[_hblRecommendations constraintHeight:kHorizontalBookListHeight];
	
	[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	//[_hblRecommendations alignBottomWithPadding:0];
	
	//Divider (for some reason for iPhone only)
	//if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
	{
		UIImage *dividerImage = [UIImage imageNamed:@"divider.png"];
		_imgDivider = [[UIImageView alloc] initWithImage:dividerImage];
		[vHeader addSubview:_imgDivider];
		_imgDivider.translatesAutoresizingMaskIntoConstraints = NO;
		[_imgDivider alignLeadingWithPadding:0];
		[_imgDivider alignTrailingWithPadding:0];
		[_imgDivider pinTopTo:_hblRecommendations withPadding:-2];
	}
	
	return vHeader;
}

- (void)filterBooks
{
	//Original version
	NSMutableArray <NSNumber *> *selectedLanguages = [NSMutableArray array];
	for (HolyLanguage *language in [HolyContentManager sharedManager].languages)
	{
		if ([[Settings sharedSettings] languageOnWithID:language.identity])
			[selectedLanguages addObject:@(language.identity)];
	}
	
	self.filteredBooks = [NSMutableArray arrayWithArray:[[HolyContentManager sharedManager].books where:@"languageID IN (%@)", selectedLanguages]];
}

- (void)fillBannerImages
{
	NSMutableArray *bannerImages = [NSMutableArray array];
	for (HolyBanner *banner in [HolyContentManager sharedManager].banners)
	{
		NSString *bannerImage = [Settings sharedSettings].localization == LocalizationRussian ? banner.imageRu : banner.imageEn;
		NSString *bannerPath = [HolyContentManager bannerPathWithURL:bannerImage];

		if ([[NSFileManager defaultManager] fileExistsAtPath:bannerPath])
			[bannerImages addObject:bannerPath];
	}
	
	if (bannerImages.count > 0)
		_bvBanners.images = bannerImages;
	else
	{
		NSString *placeholderBannerPath = [[NSBundle mainBundle] pathForResource:@"banner_gray" ofType:@"png"];
		_bvBanners.images = @[ placeholderBannerPath ];
	}
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.filteredBooks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentityShelf = @"VerticalBookListCollectionViewCell";
	VerticalBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentityShelf forIndexPath:indexPath];
	
	//Fill cell data
	HolyBook *book = (HolyBook *)self.filteredBooks[indexPath.row];
	//NSLog(@"Reloading cell with sizze class: %ld", (long)self.traitCollection.horizontalSizeClass);
	[cell fillDataWithBook:book horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	cell.delegate = self;
	
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
	{
		//NSLog(@"_colBooks Compact");
		CGSize size = kVerticalBookListCellCompactSize;
		size.width = self.view.frame.size.width;
		return size;
	}
	else
	{
		//NSLog(@"_colBooks Regular");
		CGSize size = kVerticalBookListCellRegularSize;
		NSInteger number = ((NSInteger)self.view.frame.size.width) / ((NSInteger)kVerticalBookListCellRegularSize.width);
		NSInteger rest = ((NSInteger)self.view.frame.size.width) % ((NSInteger)kVerticalBookListCellRegularSize.width);
		size.width += rest / number;
		return size;
	}
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	if (kind == UICollectionElementKindSectionHeader)
	{
		UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
		//[reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
		
		//Create only once
		if (reusableView.subviews.count == 0)
		{
			UIView *headerView = [self headerView];
			headerView.translatesAutoresizingMaskIntoConstraints = NO;
			[reusableView addSubview:headerView];
			[headerView alignTopWithPadding:0];
			[headerView alignLeadingWithPadding:0];
			[headerView alignTrailingWithPadding:0];
			
			CGFloat headerHeight = [BannerView heightForWidth:self.view.frame.size.width] + kBannersAndHorizontalListPadding + kHorizontalBookListHeight;
			[headerView constraintHeight:headerHeight];
		}
		else
		{
			//Update banners and horizontal
			[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
			[self fillBannerImages];
		}
		
		return reusableView;
	}
	
	return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	CGFloat headerHeight = [BannerView heightForWidth:self.view.frame.size.width] + kBannersAndHorizontalListPadding + kHorizontalBookListHeight;
	CGSize headerSize = CGSizeMake(collectionView.frame.size.width, headerHeight);
	return headerSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	HolyBook *book = (HolyBook *)self.filteredBooks[indexPath.row];
	NSLog(@"Book selected: %ld", (long)book.identity);
	
	[self openBookDetailsForBookID:book.identity];
	
	//GA
	[GAHelper logEventWithCategory:kCategoryLibrary action:kActionBookClick value:@(book.identity)];
}

#pragma mark - BannerViewDelegate
- (void)bannerDidSelected:(NSInteger)index
{
	NSLog(@"Banner selected: %ld", (long)index);
	
	HolyBanner *banner = [HolyContentManager sharedManager].banners[index];
	if (banner.bookID != 0)
		[self openBookDetailsForBookID:banner.bookID];
	else if (![NSObject isEmptyString:banner.siteURL])
		[AppHelper openURL:banner.siteURL];
	
	[GAHelper logEventWithCategory:kCategoryLibrary action:kActionBannerClick value:@(banner.identity)];
}

#pragma mark - MainMenuDelegate
- (void)selectLanguageCloseSelected
{
	//Start main menu
	[self.delegate mainMenuResumeInteracting];
	
	//Hide language controller
	[_selectLanguageViewController animateOut:^{
		[_selectLanguageViewController.view removeFromSuperview];
		self.selectLanguageViewController = nil;
		
		[self filterBooks];
		
		[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
		[_colBooks reloadData];
	}];
}

#pragma mark - Download updates
- (void)updateForDownloadCompletedWithBookID: (NSInteger)bookID
{
	for (VerticalBookListCollectionViewCell *cell in _colBooks.visibleCells)
		if (cell.book.identity == bookID)
			[_colBooks reloadItemsAtIndexPaths:@[ [_colBooks indexPathForCell:cell] ]];
}

- (void)updateForDownloadProgressWithBookID: (NSInteger)bookID
{
	for (VerticalBookListCollectionViewCell *cell in _colBooks.visibleCells)
		if (cell.book.identity == bookID)
			[cell updateDownloadState];
}

#pragma mark - Actions
- (void)btnMenu_Click: (id)sender
{
	[self.delegate mainMenuDidSelected];
}

- (void)btnLanguage_Click: (id)sender
{
	//Stop main menu
	[self.delegate mainMenuStopInteracting];
	
	//Show language controller
	if (_selectLanguageViewController == nil)
	{
		_selectLanguageViewController = [[SelectLanguageViewController alloc] initWithSizeClass:self.traitCollection.horizontalSizeClass parent: self.navigationController];
		_selectLanguageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
		_selectLanguageViewController.delegate = self;
	}
	else
		//Custom property to get height of navigation bar
		_selectLanguageViewController.parent = self.navigationController;
	
	[self.navigationController.view addSubview:_selectLanguageViewController.view];
	[_selectLanguageViewController.view dockAll];
	[_selectLanguageViewController animateIn];
}

@end
