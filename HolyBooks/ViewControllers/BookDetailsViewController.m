//
//  BookDetailsViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 11/20/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import "BookDetailsViewController.h"
#import "HolyBook.h"
#import "HolyAuthor.h"
#import "HolyContentManager.h"
#import "NSArray+LINQ.h"
#import "UIView+Autolayout.h"
#import "BookState.h"
#import "IWSProgressButton.h"
#import "ImageManager.h"

#define kOffsetLimit ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 100 : 200)
#define kTopViewHeight ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 232 : 350)
#define kBookCoverSize ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? CGSizeMake(104, 150) : CGSizeMake(160, 234))
#define kBookCoverTopOffset ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 28 : 40)
#define kBookNameFont ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 16 : 20)
#define kBookAuthorFont ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 12 : 14)
#define kHorizontalListOffset ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 15 : 20)

#define kMaxBlurRadius 20
#define kMaxScale 1.5
#define kBlurAlpha 0.9f

@interface BookDetailsViewController ()
{
	BOOL _initialized;
}

@property (nonatomic, retain) HolyBook *book;

@property (nonatomic, retain) UIImageView *imgBookCover;
@property (nonatomic, retain) UILabel *lblBookName;
@property (nonatomic, retain) UILabel *lblBookAuthor;
@property (nonatomic, retain) UIView *vBottomContainer;
@property (nonatomic, retain) UIVisualEffectView *vBottom;
@property (nonatomic, retain) IWSProgressButton *btnDownload;
@property (nonatomic, retain) UILabel *lblBookDescription;
@property (nonatomic, retain) UIImageView *imgDivider;
@property (nonatomic, retain) HorizontalBookList *hblByAuthor;

@property (nonatomic, assign) BOOL shouldOpenMenu;

@end

@implementation BookDetailsViewController

- (instancetype)initWithBookID:(NSInteger)bookID shouldOpenMenu:(BOOL)shouldOpenMenu
{
	if ((self = [super init]))
	{
		self.shouldOpenMenu = shouldOpenMenu;
		//Book can be either in Library or not there, but exists in downloaded
		NSArray *books = [[HolyContentManager sharedManager].books where:@"identity == %ld", (long)bookID];
		if (books.count == 0)
		{
			self.book = [HolyBook getByID:bookID];
		}
		else
		{
			self.book = books[0];
		}
	}
	
	return self;
}

- (instancetype)initWithBookID: (NSInteger)bookID
{
	return [self initWithBookID:bookID shouldOpenMenu:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Navigation
	self.navigationController.navigationBarHidden = YES;

	//Background
	//NSString *imagePath = [HolyContentManager bookImagePathWithURL:_book.image];
	
	/*NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", kContentHost, kBookImagesSubdirectory, _book.image]];
	[ImageManager getImageAsync:[imageURL absoluteString] completedBlock:^(UIImage *image) {
		_imgBkgr.image = image;
	}];*/
	NSString *imagePath = [HolyContentManager bookImagePathWithURL:_book.image];
	NSString *imageURL = [HolyContentManager bookImageURLWithImageName:_book.image];
	
	_imgBkgr.image = [UIImage imageNamed:@"book_default.png"];
	[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
		_imgBkgr.image = image;
	}];
	
	/*UIImage *originalImage = [UIImage imageWithContentsOfFile:imagePath];
	_imgBkgr.image = originalImage;*/
	
	UIVisualEffect *blurEffect;
	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	
	visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
	visualEffectView.alpha = kBlurAlpha;
	
	visualEffectView.frame = [UIScreen mainScreen].bounds;
	[_imgBkgr addSubview:visualEffectView];

	/*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		UIImage *blurredImage = [self blurredImageWithImage:originalImage];
		_imgBkgr.image = blurredImage;
	});*/
	
	//[_imgBackground setInputImage:[UIImage imageWithContentsOfFile:imagePath] skipBlur:YES];
	//_imgBackground.inputImage = [UIImage imageWithContentsOfFile:imagePath];
	//_imgBackground.blurRadius = kMaxBlurRadius;
	//_imgBackground.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
	
	//NSLogRecursive(self.view);
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
	
	//  Create our blurred image
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
	
	//  Setting up Gaussian Blur
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setValue:inputImage forKey:kCIInputImageKey];
	[filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	
	/*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
	 *  up exactly to the bounds of our original image */
	CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
	
	UIImage *retVal = [UIImage imageWithCGImage:cgImage];
	return retVal;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookDetails];
}

- (void)viewWillLayoutSubviews
{
	//Correctly size background image
	/*if (_imgBackground.inputImage != nil)
	{
		CGSize imageSize = _imgBackground.inputImage.size;
		CGSize screenSize = self.view.frame.size;
		
		CGFloat heightRatio = imageSize.height / screenSize.height;
		CGFloat widthRatio = imageSize.width / screenSize.width;
		CGFloat minRatio = MAX(heightRatio, widthRatio);	//MIN to fill, MAX to fit
		
		CGSize imageViewSize = CGSizeMake(imageSize.width / minRatio, imageSize.height / minRatio);
		
		_imgBackground.heightConstraint.constant = imageViewSize.height;
		_imgBackground.widthConstraint.constant = imageViewSize.width;
	}*/
	
	if (_imgBkgr.image != nil)
	{
		//CGSize imageSize = _imgBkgr.image.size;
		
		float mainCoef = [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height;
		float imgWidth = [UIScreen mainScreen].bounds.size.height * mainCoef;
		_cnstBckgrHeight.constant = [UIScreen mainScreen].bounds.size.height;
		_cnstBckgrWidth.constant = imgWidth;
		
		/*CGSize screenSize = self.view.frame.size;
		
		CGFloat heightRatio = imageSize.height / screenSize.height;
		CGFloat widthRatio = imageSize.width / screenSize.width;
		CGFloat minRatio = MAX(heightRatio, widthRatio);	//MIN to fill, MAX to fit*/
		
		//CGSize imageViewSize = CGSizeMake(imageSize.width / minRatio, imageSize.height / minRatio);
		//_cnstBckgrWidth.constant = imageViewSize.width;
		//_cnstBckgrHeight.constant = imageViewSize.height;
	}
	
	visualEffectView.frame = [UIScreen mainScreen].bounds;
	
	NSLog(@"Rotating?");
	
	//Initialize front layer controls
	if (!_initialized)
	{
		//Top view
		UIView *topView = [[UIView alloc] init];
		topView.translatesAutoresizingMaskIntoConstraints = NO;
		[_svScroll addSubview:topView];
		[topView dockTop];
		//[topView constraintHeight:kTopViewHeight];
		[topView alignWidthWithMultiplier:1];
		[topView release];
		
		//Bottom view
		_vBottomContainer = [[UIView alloc] init];
		_vBottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
		_vBottom = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
		_vBottom.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
		_vBottom.translatesAutoresizingMaskIntoConstraints = NO;

		[_vBottomContainer addSubview:_vBottom];
		[_svScroll addSubview:_vBottomContainer];
		[_vBottom dockTop];
		[_vBottom constraintHeight:1600];
		[_vBottomContainer dockBottom];
		[_vBottomContainer alignWidthWithMultiplier:1];
		[_vBottomContainer pinTopTo:topView withPadding:0];
		
		//Back button
		UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
		btnBack.translatesAutoresizingMaskIntoConstraints = NO;
		[btnBack addTarget:self action:@selector(btnBack_Click:) forControlEvents:UIControlEventTouchUpInside];
		[btnBack setImage:[UIImage imageNamed:@"arrow_back.png"] forState:UIControlStateNormal];	//arrow_back_white.png
		[_svScroll addSubview:btnBack];
		[btnBack alignLeadingWithPadding:10];
		[btnBack alignTopWithPadding:20];
		[btnBack constraintWidth:40];
		[btnBack constraintHeight:40];
		
		//Content
		//Book cover
		//NSString *imagePath = [HolyContentManager bookImagePathWithURL:_book.image];
		_imgBookCover = [[UIImageView alloc] init];
		_imgBookCover.translatesAutoresizingMaskIntoConstraints = NO;
		
		NSString *imagePath = [HolyContentManager bookImagePathWithURL:_book.image];
		NSString *imageURL = [HolyContentManager bookImageURLWithImageName:_book.image];
		
		_imgBookCover.image = [UIImage imageNamed:@"book_default.png"];
		[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
			_imgBookCover.image = image;
		}];
		/*NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", kContentHost, kBookImagesSubdirectory, _book.image]];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
		{
			[ImageManager getImageAsync:[imageURL absoluteString] completedBlock:^(UIImage *image) {
				
				_imgBookCover.image = image;
			}];
		}
		else
		{
			[ImageManager getImageForPathAsync:imagePath completedBlock:^(UIImage *image) {
				_imgBookCover.image = [UIImage imageWithContentsOfFile:imagePath];
			}];
		}*/
		//_imgBookCover.image = [UIImage imageWithContentsOfFile:imagePath];
		[topView addSubview:_imgBookCover];
		[_imgBookCover constraintWidth:kBookCoverSize.width];
		[_imgBookCover constraintHeight:kBookCoverSize.height];
		[_imgBookCover alignTopWithPadding:kBookCoverTopOffset];
		
		//Book name
		_lblBookName = [[UILabel alloc] init];
		_lblBookName.translatesAutoresizingMaskIntoConstraints = NO;
		_lblBookName.text = _book.name;
		_lblBookName.textColor = [UIColor whiteColor];
		_lblBookName.font = [UIFont systemFontOfSize:kBookNameFont];
		_lblBookName.lineBreakMode = NSLineBreakByWordWrapping;
		_lblBookName.numberOfLines = 0;
		_lblBookName.textAlignment = NSTextAlignmentCenter;
		[topView addSubview:_lblBookName];
		[_lblBookName alignLeadingWithPadding:10];
		[_lblBookName alignTrailingWithPadding:10];
		[_lblBookName pinTopTo:_imgBookCover withPadding:4];
		
		//Book author
		HolyAuthor *author = [[HolyContentManager sharedManager].authors where:@"identity == %ld", (long)_book.authorID][0];
		_lblBookAuthor = [[UILabel alloc] init];
		_lblBookAuthor.translatesAutoresizingMaskIntoConstraints = NO;
		_lblBookAuthor.text = author.name;
		_lblBookAuthor.textColor = [UIColor whiteColor];
		_lblBookAuthor.font = [UIFont systemFontOfSize:kBookAuthorFont];
		[topView addSubview:_lblBookAuthor];
		[_lblBookAuthor pinTopTo:_lblBookName withPadding:3];
		[_lblBookAuthor alignBottomWithPadding:10];
		
		[topView centerXSubviews];
		
		//Download button
		self.btnDownload = [IWSProgressButton buttonWithType:UIButtonTypeCustom];
		_btnDownload.translatesAutoresizingMaskIntoConstraints = NO;
		_btnDownload.layer.borderWidth = 1;
		_btnDownload.layer.cornerRadius = 2;
		_btnDownload.titleLabel.font = [UIFont systemFontOfSize:13];
		_btnDownload.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
		[_btnDownload addTarget:self action:@selector(btnDownload_Click:) forControlEvents:UIControlEventTouchUpInside];
		
		BookState *bookState = [BookState getByID:_book.identity];
		[_btnDownload configureForState:bookState];
		
		if ([_vBottom respondsToSelector:@selector(contentView)])
			[[_vBottom contentView] addSubview:_btnDownload];
		else
			[_vBottom addSubview:_btnDownload];

		[_btnDownload alignCenterXWithPadding:0];
		[_btnDownload alignTopWithPadding:20];
		[_btnDownload constraintHeight:23];

		//Description
		_lblBookDescription = [[UILabel alloc] init];
		_lblBookDescription.translatesAutoresizingMaskIntoConstraints = NO;
		_lblBookDescription.font = [UIFont systemFontOfSize:16];
		_lblBookDescription.numberOfLines = 0;
		
		if ([_vBottom respondsToSelector:@selector(contentView)])
			[[_vBottom contentView] addSubview:_lblBookDescription];
		else
			[_vBottom addSubview:_lblBookDescription];

		[_lblBookDescription pinTopTo:_btnDownload withPadding:20];
		[_lblBookDescription alignLeadingWithPadding:15];
		[_lblBookDescription alignTrailingWithPadding:15];
		
		NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:_book.desc];
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.lineSpacing = 4;
		[desc addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desc.length)];
		_lblBookDescription.attributedText = desc;
		
		//Divider
		UIImage *dividerImage = [UIImage imageNamed:@"divider.png"];
		_imgDivider = [[UIImageView alloc] initWithImage:dividerImage];
		_imgDivider.translatesAutoresizingMaskIntoConstraints = NO;
		
		if ([_vBottom respondsToSelector:@selector(contentView)])
			[[_vBottom contentView] addSubview:_imgDivider];
		else
			[_vBottom addSubview:_imgDivider];

		[_imgDivider alignLeadingWithPadding:15];
		[_imgDivider alignTrailingWithPadding:15];
		[_imgDivider pinTopTo:_lblBookDescription withPadding:kHorizontalListOffset];
		
		//Horizontal list
		self.hblByAuthor = [HorizontalBookList create];
		_hblByAuthor.translatesAutoresizingMaskIntoConstraints = NO;
		_hblByAuthor.delegate = self;
		
		if ([_vBottom respondsToSelector:@selector(contentView)])
			[[_vBottom contentView] addSubview:_hblByAuthor];
		else
			[_vBottom addSubview:_hblByAuthor];

		[_hblByAuthor constraintHeight:kHorizontalBookListHeight];
		[_hblByAuthor alignLeadingWithPadding:0];
		[_hblByAuthor alignTrailingWithPadding:0];
		[_hblByAuthor pinTopTo:_lblBookDescription withPadding:kHorizontalListOffset];
		
		_hblByAuthor.authorID = _book.authorID;
		_hblByAuthor.excludeBookID = _book.identity;
		[_hblByAuthor fillWithType:HorizontalBookListTypeAuthor horizontalSizeClass:self.traitCollection.horizontalSizeClass];
		
		//Bottom container view height depends on content height
		NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:_hblByAuthor attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																		 toItem:_vBottomContainer attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
		[_vBottomContainer addConstraint:constraint];
		
		_initialized = YES;
	}
}

/*- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_imgBackground setSkipBlue:NO];
}*/

- (void)dealloc
{
	[_book release];
	
	[_imgBookCover release];
	[_lblBookName release];
	[_lblBookAuthor release];
	[_btnDownload release];
	[_lblBookDescription release];
	[_imgDivider release];
	[_hblByAuthor release];
	[_vBottom release];
	[_vBottomContainer release];
	
	//[_imgBackground release];
	[_svScroll release];
	//[_imgBluredBackground release];
	[_imgBkgr release];
	[_cnstBckgrWidth release];
	[_cnstBckgrHeight release];
	[super dealloc];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//NSLog(@"Offset: %f, %f", scrollView.contentOffset.x, scrollView.contentOffset.y);
	//NSLog(@"scrollViewDidScroll triggered");
	
	if (scrollView.contentOffset.y > 0)
		return;
	
	//Transform
	CGFloat currentScale = (kOffsetLimit * kMaxScale + scrollView.contentOffset.y / 2) / kOffsetLimit;
	//NSLog(@"Current scale: %f", currentScale);
	currentScale = MAX(currentScale, 1.0);
	//_imgBackground.transform = CGAffineTransformMakeScale(currentScale, currentScale);
	
	//Blur
	//_imgBackground.blurRadius = (1 + scrollView.contentOffset.y / kOffsetLimit) * kMaxBlurRadius;
	float radius = (1 + scrollView.contentOffset.y / kOffsetLimit) * kMaxBlurRadius;
	//NSLog(@"blur radius: %f", radius);
	
	//Assuming 20 = 100% = 0.85f for alpha for blurview
	float alphaValue = (radius * kBlurAlpha) / 20;
	
	if (alphaValue < 0)
		alphaValue = 0;
	
	visualEffectView.alpha = alphaValue;
	
	//Alfa
	if (scrollView.contentOffset.y < - kOffsetLimit / 2)
	{
		_svScroll.alpha = (kOffsetLimit * 1.5 + scrollView.contentOffset.y) / kOffsetLimit;
		//NSLog(@"Alfa: %f", _svScroll.alpha);
	}
	else
		_svScroll.alpha = 1;
}

#pragma mark - Download updates
- (void)updateForDownloadCompletedWithBookID: (NSInteger)bookID
{
	if (_book.identity == bookID)
	{
		BookState *bookState = [BookState getByID:_book.identity];
		[_btnDownload configureForState:bookState];
	}
}

- (void)updateForDownloadProgressWithBookID: (NSInteger)bookID
{
	if (_book.identity == bookID)
	{
		BookState *bookState = [BookState getByID:_book.identity];
		[_btnDownload configureForState:bookState];
	}
}

#pragma mark - Actions
- (void)btnBack_Click: (id)sender
{
	if (!self.shouldOpenMenu)
		[self.navigationController popViewControllerAnimated:YES];
	else
		[self.delegate mainMenuOpenSearchResults];
	//NSLogRecursive(self.view);
}

- (void)btnDownload_Click: (id)sender
{
	CGRect buttonRect = [self.view convertRect:_btnDownload.frame fromView:_vBottom];
	[self bookDownloadDidSelected:_book.identity buttonRect:buttonRect buttonParentView:nil];
}

@end
