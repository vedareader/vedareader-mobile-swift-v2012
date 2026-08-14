//
//  AuthorDetailsViewController.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 20/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "AuthorDetailsViewController.h"
#import "HolyAuthor.h"
#import "HolyContentManager.h"
#import "NSArray+LINQ.h"
#import "UIView+Autolayout.h"
#import "IWSProgressButton.h"

#define kOffsetLimit ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 100 : 200)
#define kTopViewHeight ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 275 : 500)
#define kAuthorCoverSize ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? CGSizeMake(150, 150) : CGSizeMake(300, 300))
#define kAuthorCoverTopOffset ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 53-20 : 80-20)
#define kAuthorNameFont ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 20 : 24)

#define kMaxBlurRadius 20
#define kMaxScale 1.5

#define kAnimationDuration 0.25

@interface AuthorDetailsViewController ()
{
	BOOL _initialized;
}

@property (nonatomic, retain) NSArray *books;
@property (nonatomic, retain) HolyAuthor *author;

@property (nonatomic, retain) UIImageView *imgAuthor;
@property (nonatomic, retain) UIButton *btnShowFullPhoto;
@property (nonatomic, retain) UIViewController *fullScreenPhotoVC;
@property (nonatomic, retain) UILabel *lblAuthorName;
@property (nonatomic, retain) UIView *vBottomContainer;
@property (nonatomic, retain) UIView *vBottom;
@property (nonatomic, retain) IWSProgressButton *btnDownload;
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UIButton *btnBack;
@property (nonatomic, retain) UIView *vSelector;
@property (nonatomic, retain) UIButton *btnBooks;
@property (nonatomic, retain) UIButton *btnAboutAuthor;
@property (nonatomic, retain) UIImageView *verticalDivider;
@property (nonatomic, retain) UIImageView *divider;

@property (nonatomic, retain) UICollectionView *colBooks;
//@property (nonatomic, retain) UILabel *lblAuthorDescription;
@property (nonatomic, retain) UITextView *txtAuthorDescription;

@property (nonatomic, retain) NSLayoutConstraint *cBackgroundImageBottom;

@property (nonatomic, assign) BOOL shouldOpenMenu;

@end

@implementation AuthorDetailsViewController

#pragma mark - Life cycle

- (instancetype)initWithAuthorID:(NSInteger)authorID shouldOpenMenu:(BOOL)shouldOpenMenu
{
	if ((self = [super init]))
	{
		self.books = [[HolyContentManager sharedManager].books where:@"authorID == %ld", (long)authorID];
		self.author = [[HolyContentManager sharedManager].authors where:@"identity == %ld", (long)authorID].firstObject;
		self.shouldOpenMenu = shouldOpenMenu;
	}
	
	return self;
}

- (instancetype)initWithAuthorID:(NSInteger)authorID
{
	return [self initWithAuthorID:authorID shouldOpenMenu:NO];
}

- (void)dealloc
{
	[_books release];
	[_author release];
	[_imgAuthor release];
	[_lblAuthorName release];
	[_vBottomContainer release];
	[_vBottom release];
	[_btnDownload release];
	[_topView release];
	[_btnBack release];
	[_vSelector release];
	[_btnBooks release];
	[_btnAboutAuthor release];
	[_verticalDivider release];
	[_divider release];
	[_colBooks release];
	//[_lblAuthorDescription release];
	[_txtAuthorDescription release];
	[_btnShowFullPhoto release];
	
	[_imgBackground release];
	[_svScroll release];
	
	[_cBackgroundImageBottom release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSLog(@"books: %@", self.books);
	
	//Navigation
	self.navigationController.navigationBarHidden = YES;
	
	[self setupSubviews];
	
	//Background
	/*NSString *imagePath = [HolyContentManager authorImagePathWithURL:self.author.image];
	self.imgBackground.inputImage = [UIImage imageWithContentsOfFile:imagePath];
	self.imgBackground.blurRadius = kMaxBlurRadius;
	self.imgBackground.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
	self.imgBackground.backgroundColor = [UIColor whiteColor];*/
	
	[self.colBooks registerNib:[UINib nibWithNibName:@"VerticalBookListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VerticalBookListCollectionViewCell"];
	
	if (self.shouldOpenMenu)
		[self.delegate mainMenuStopInteracting];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenAuthorDetails];
}

- (void)viewWillLayoutSubviews
{
	//Correctly size background image
	/*if (self.imgBackground.inputImage != nil)
	{
		CGSize imageSize = self.imgBackground.inputImage.size;
		CGSize screenSize = self.view.frame.size;
		
		CGFloat heightRatio = imageSize.height / screenSize.height;
		CGFloat widthRatio = imageSize.width / screenSize.width;
		CGFloat minRatio = MAX(heightRatio, widthRatio); //MIN to fill, MAX to fit
		
		CGSize imageViewSize = CGSizeMake(imageSize.width / minRatio, imageSize.height / minRatio);
		
		self.imgBackground.heightConstraint.constant = imageViewSize.height;
		self.imgBackground.widthConstraint.constant = imageViewSize.width;
	}*/
	
	//Initialize front layer controls
	if (!_initialized)
	{
		[self setupConstraints];
		
		_initialized = YES;
	}
	
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
}

#pragma mark - Rotations
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		[self.colBooks.collectionViewLayout invalidateLayout];
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	}];
}

#pragma mark - Private methods
- (void)setupSubviews
{
	self.view.clipsToBounds = YES;
	
	UIView *imgBackground = [[[UIView alloc] init] autorelease];
	imgBackground.backgroundColor = [UIColor whiteColor];
	imgBackground.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:imgBackground];
	self.imgBackground = imgBackground;
	
	/*
	UIScrollView *svScroll = [[[UIScrollView alloc] init] autorelease];
	svScroll.translatesAutoresizingMaskIntoConstraints = NO;
	svScroll.delegate = self;
	[self.view addSubview:svScroll];
	self.svScroll = svScroll;
	*/
	
	//Top view
	self.topView = [[[UIView alloc] init] autorelease];
	self.topView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.topView];
	
	//Bottom view
	self.vBottomContainer = [[[UIView alloc] init] autorelease];
	self.vBottomContainer.translatesAutoresizingMaskIntoConstraints = NO;
	self.vBottom = [[UIView alloc] init];//[[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]] autorelease];
	self.vBottom.backgroundColor = [UIColor whiteColor];
	self.vBottom.translatesAutoresizingMaskIntoConstraints = NO;
	[self.vBottomContainer addSubview:self.vBottom];
	[self.view addSubview:self.vBottomContainer];
	
	//Back button
	UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBack.translatesAutoresizingMaskIntoConstraints = NO;
	[btnBack addTarget:self action:@selector(btnBack_Click:) forControlEvents:UIControlEventTouchUpInside];
	//[btnBack setImage:[UIImage imageNamed:@"arrow_back_white.png"] forState:UIControlStateNormal];
	[btnBack setImage:[UIImage imageNamed:@"arrow_back.png"] forState:UIControlStateNormal];
	[self.view addSubview:btnBack];
	self.btnBack = btnBack;

	//Content
	//Author avatar
	NSString *imagePath = [HolyContentManager authorImagePathWithURL:self.author.image];
	self.imgAuthor = [[[UIImageView alloc] init] autorelease];
	self.imgAuthor.translatesAutoresizingMaskIntoConstraints = NO;
	self.imgAuthor.image = [UIImage imageWithContentsOfFile:imagePath];
	//Round corners for author image
	//self.imgAuthor.layer.masksToBounds = YES;
	//self.imgAuthor.layer.cornerRadius = self.imgAuthor.frame.size.width / 2;
	[self.topView addSubview:self.imgAuthor];
	
	//Button to open photo full screen
	UIButton *btnTemp = [[UIButton alloc] init];
	[btnTemp setTitle:@"" forState:UIControlStateNormal];
	btnTemp.translatesAutoresizingMaskIntoConstraints = NO;
	btnTemp.backgroundColor = [UIColor clearColor];
	[self.view addSubview:btnTemp];
	[btnTemp setTitle:@"" forState:UIControlStateNormal];
	[btnTemp addTarget:self action:@selector(btnShowFullPhoto_Click:) forControlEvents:UIControlEventTouchUpInside];
	self.btnShowFullPhoto = btnTemp;
	
	//Author name
	self.lblAuthorName = [[[UILabel alloc] init] autorelease];
	self.lblAuthorName.translatesAutoresizingMaskIntoConstraints = NO;
	self.lblAuthorName.text = self.author.name;
	self.lblAuthorName.textColor = [UIColor blackColor];
	self.lblAuthorName.font = [UIFont systemFontOfSize:kAuthorNameFont];
	self.lblAuthorName.lineBreakMode = NSLineBreakByWordWrapping;
	self.lblAuthorName.numberOfLines = 0;
	self.lblAuthorName.textAlignment = NSTextAlignmentCenter;
	[self.topView addSubview:self.lblAuthorName];
	
	//Content switch view
	self.vSelector = [[[UIView alloc] init] autorelease];
	self.vSelector.translatesAutoresizingMaskIntoConstraints = NO;
	self.vSelector.backgroundColor = [UIColor whiteColor];
	[self.vBottom addSubview:self.vSelector];
	
	UIButton *btnBooks = [UIButton buttonWithType:UIButtonTypeCustom];
	btnBooks.translatesAutoresizingMaskIntoConstraints = NO;
	[btnBooks setTitle:Local(@"AuthorDetails.BtnBooks.Title") forState:UIControlStateNormal];
	[btnBooks setTitleColor:kBlueButtonTitleColor forState:UIControlStateNormal];
	[btnBooks.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[btnBooks addTarget:self action:@selector(btnBooks_Click:) forControlEvents:UIControlEventTouchUpInside];
	[self.vSelector addSubview:btnBooks];
	self.btnBooks = btnBooks;
	
	UIButton *btnAboutAuthor = [UIButton buttonWithType:UIButtonTypeCustom];
	btnAboutAuthor.translatesAutoresizingMaskIntoConstraints = NO;
	[btnAboutAuthor setTitle:Local(@"AuthorDetails.BtnAboutAuthor.Title") forState:UIControlStateNormal];
	[btnAboutAuthor setTitleColor:kGrayButtonTitleColor forState:UIControlStateNormal];
	[btnAboutAuthor.titleLabel setFont:[UIFont systemFontOfSize:15]];
	[btnAboutAuthor addTarget:self action:@selector(btnAboutAuthor_Click:) forControlEvents:UIControlEventTouchUpInside];
	[self.vSelector addSubview:btnAboutAuthor];
	self.btnAboutAuthor = btnAboutAuthor;
	
	self.verticalDivider = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider_vertical.png"]] autorelease];
	self.verticalDivider.translatesAutoresizingMaskIntoConstraints = NO;
	[self.vSelector addSubview:self.verticalDivider];
	
	self.divider = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider.png"]] autorelease];
	self.divider.translatesAutoresizingMaskIntoConstraints = NO;
	[self.vSelector addSubview:self.divider];
	
	UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
	layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
	layout.minimumLineSpacing = 0;
	layout.minimumInteritemSpacing = 0;
	layout.estimatedItemSize = CGSizeZero;
	
	UICollectionView *colBooks = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] autorelease];
	colBooks.translatesAutoresizingMaskIntoConstraints = NO;
	colBooks.dataSource = self;
	colBooks.delegate = self;
	colBooks.backgroundColor = [UIColor clearColor];
	self.colBooks = colBooks;
	[self.vBottom addSubview:self.colBooks];
	
	//Description
	/*
	self.lblAuthorDescription = [[[UILabel alloc] init] autorelease];
	self.lblAuthorDescription.translatesAutoresizingMaskIntoConstraints = NO;
	self.lblAuthorDescription.font = [UIFont systemFontOfSize:16];
	self.lblAuthorDescription.numberOfLines = 0;
	self.lblAuthorDescription.alpha = 0.0;
	*/
	NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:_author.desc ?: @""];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 4;
	[desc addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, desc.length)];
	[desc addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, desc.length)];
	
	UITextView *txtAuthorDescription = [[[UITextView alloc] init] autorelease];
	txtAuthorDescription.translatesAutoresizingMaskIntoConstraints = NO;
	//txtAuthorDescription.font = [UIFont systemFontOfSize:16];
	txtAuthorDescription.alpha = 0.0;
	txtAuthorDescription.showsVerticalScrollIndicator = NO;
	txtAuthorDescription.attributedText = desc;
	txtAuthorDescription.backgroundColor = [UIColor clearColor];
	txtAuthorDescription.editable = NO;
	txtAuthorDescription.selectable = NO;
	self.txtAuthorDescription = txtAuthorDescription;
	
	[self.vBottom addSubview:self.txtAuthorDescription];
	//[self.vBottom addSubview:self.lblAuthorDescription];
}

- (void)setupConstraints
{
	[self.imgBackground dockAll];
	
	[self.svScroll dockAll];
	
	//Top view
	[self.topView alignTopWithPadding: UIApplication.sharedApplication.statusBarFrame.size.height];
	[self.topView alignLeadingWithPadding:0];
	[self.topView alignTrailingWithPadding:0];
	
	[self.topView constraintHeight:kTopViewHeight];
	[self.topView alignWidthWithMultiplier:1];
	
	//Bottom view
	[self.vBottom dockAll];
	//[self.vBottom constraintHeight:400];
	[self.vBottomContainer dockBottom];
	[self.vBottomContainer alignWidthWithMultiplier:1];
	[self.vBottomContainer pinTopTo:self.topView withPadding:0];
	
	NSLayoutConstraint *vBottomHeightConstraint = [NSLayoutConstraint constraintWithItem:self.topView
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:nil
														 attribute:NSLayoutAttributeHeight
														multiplier:1
														  constant:400];
	vBottomHeightConstraint.priority = UILayoutPriorityDefaultHigh;
	vBottomHeightConstraint.active = YES;
	
	//Back button
	[self.btnBack alignTopWithPadding:UIApplication.sharedApplication.statusBarFrame.size.height];

	[self.btnBack alignLeadingWithPadding:10];
	[self.btnBack constraintWidth:40];
	[self.btnBack constraintHeight:40];
	
	//Content
	//Author avatar
	[self.imgAuthor constraintWidth:kAuthorCoverSize.width];
	[self.imgAuthor constraintHeight:kAuthorCoverSize.height];
	[self.imgAuthor alignTopWithPadding:kAuthorCoverTopOffset];
	
	//[self.btnShowFullPhoto centerXAnchor];
	[self.btnShowFullPhoto constraintWidth:kAuthorCoverSize.width];
	[self.btnShowFullPhoto constraintHeight:kAuthorCoverSize.height];
	[self.btnShowFullPhoto alignAttribute:NSLayoutAttributeLeading to:self.imgAuthor withPadding:0];
	
	[self.btnShowFullPhoto alignTopWithPadding:kAuthorCoverTopOffset + UIApplication.sharedApplication.statusBarFrame.size.height];

//	[self.btnShowFullPhoto alignAttribute:NSLayoutAttributeCento:self.imgAuthor withPadding:kAuthorCoverTopOffset];
	/*[self.imgAuthor alignTopWithPadding:0];
	[self.imgAuthor constraintWidth:[[UIScreen mainScreen] bounds].size.width];
	[self.imgAuthor constraintHeight:[[UIScreen mainScreen] bounds].size.width];*/
	
	//Author name
	[self.lblAuthorName alignLeadingWithPadding:10.0];
	[self.lblAuthorName alignTrailingWithPadding:10.0];
	[self.lblAuthorName pinTopTo:self.imgAuthor withPadding:18.0]; //alignTopWithPadding:kAuthorCoverTopOffset + 18.0];
	[self.lblAuthorName alignBottomWithPadding:20.0];
	
	//Content switch view
	[self.vSelector alignTopWithPadding:0];
	[self.vSelector alignLeadingWithPadding:0];
	[self.vSelector alignTrailingWithPadding:0];
	[self.vSelector constraintHeight:37.0];
	
	[self.btnBooks alignTopWithPadding:0];
	[self.btnBooks alignLeadingWithPadding:0];
	[self.btnBooks alignBottomWithPadding:0];
	
	[self.btnAboutAuthor alignTopWithPadding:0];
	[self.btnAboutAuthor alignTrailingWithPadding:0];
	[self.btnAboutAuthor alignBottomWithPadding:0];
	[self.btnAboutAuthor pinLeadingTo:self.btnBooks withPadding:0];
	
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.btnBooks attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
																	 toItem:self.btnAboutAuthor attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
	[self.vSelector addConstraint:constraint];
	
	[self.verticalDivider alignCenterXWithPadding:0];
	[self.verticalDivider alignTopWithPadding:4];
	[self.verticalDivider alignBottomWithPadding:4];
	
	[self.divider dockBottom];
	
	[self.topView centerXSubviews];
	
	[self.colBooks pinTopTo:self.vSelector withPadding:10.0];
	[self.colBooks alignLeadingWithPadding:0.0];
	[self.colBooks alignTrailingWithPadding:0.0];
	
	[self.vBottom alignBottomWithPadding:0];
	
	//Description
	[self.txtAuthorDescription pinTopTo:self.vSelector withPadding:15.0];
	[self.txtAuthorDescription alignLeadingWithPadding:15];
	[self.txtAuthorDescription alignTrailingWithPadding:15];
	[self.txtAuthorDescription alignBottomWithPadding:15];
	
	/*
	[self.lblAuthorDescription pinTopTo:self.vSelector withPadding:20.0];
	[self.lblAuthorDescription alignLeadingWithPadding:15];
	[self.lblAuthorDescription alignTrailingWithPadding:15];
	 */
	
	self.cBackgroundImageBottom = [self.imgBackground alignAttribute:NSLayoutAttributeBottom to:self.colBooks withPadding:0];
}
/*
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	if (scrollView.contentOffset.y > 0)
		return;
	
	//Transform
	CGFloat currentScale = (kOffsetLimit * kMaxScale + scrollView.contentOffset.y / 2) / kOffsetLimit;
	NSLog(@"Current scale: %f", currentScale);
	currentScale = MAX(currentScale, 1.0);
	self.imgBackground.transform = CGAffineTransformMakeScale(currentScale, currentScale);
	
	//Blur
	self.imgBackground.blurRadius = (1 + scrollView.contentOffset.y / kOffsetLimit) * kMaxBlurRadius;
	
	//Alfa
	if (scrollView.contentOffset.y < - kOffsetLimit / 2)
	{
		self.svScroll.alpha = (kOffsetLimit * 1.5 + scrollView.contentOffset.y) / kOffsetLimit;
		NSLog(@"Alfa: %f", _svScroll.alpha);
	}
	else
		self.svScroll.alpha = 1;

}
*/
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentityShelf = @"VerticalBookListCollectionViewCell";
	VerticalBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentityShelf forIndexPath:indexPath];
	
	//Fill cell data
	HolyBook *book = (HolyBook *)self.books[indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	HolyBook *book = (HolyBook *)self.books[indexPath.row];
	NSLog(@"Book selected: %ld", (long)book.identity);
	
	[self openBookDetailsForBookID:book.identity];
	
	//GA
	[GAHelper logEventWithCategory:kCategoryAuthor action:kActionBookClick value:@(book.identity)];
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

#pragma mark - Handlers
- (void)btnBack_Click: (id)sender
{
	if (!_shouldOpenMenu)
		[self.navigationController popViewControllerAnimated:YES];
	else
		[self.delegate mainMenuOpenSearchResults];
}

- (void)btnShowFullPhoto_Click: (id)sender
{
	NSLog(@"Show photo full screen.");
	
	UIViewController *vc = [[UIViewController alloc] init];
	vc.view.backgroundColor = [UIColor blackColor];
	
	UIImageView *photo = [[UIImageView alloc] init];
	NSString *imagePath = [HolyContentManager authorImagePathWithURL:self.author.image];
	photo.image = [UIImage imageWithContentsOfFile:imagePath];
	photo.translatesAutoresizingMaskIntoConstraints = NO;
	[photo setContentMode:UIViewContentModeScaleAspectFit];
	[vc.view addSubview:photo];
	[photo dockAll];
	
	UIButton *btnClosePhoto = [[UIButton alloc] init];
	[btnClosePhoto setTitle:@"" forState:UIControlStateNormal];
	btnClosePhoto.translatesAutoresizingMaskIntoConstraints = NO;
	[btnClosePhoto addTarget:self action:@selector(dismissVC:) forControlEvents:UIControlEventTouchUpInside];
	[vc.view addSubview:btnClosePhoto];
	[btnClosePhoto dockAll];
	
	_fullScreenPhotoVC = vc;
	[self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)dismissVC: (id)sender
{
	[_fullScreenPhotoVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnBooks_Click:(UIButton *)sender
{
	UIColor *currentCol = sender.currentTitleColor;
	if ([currentCol isEqual:kBlueButtonTitleColor])
		return;
	
	[sender setTitleColor:self.btnAboutAuthor.currentTitleColor forState:UIControlStateNormal];
	[self.btnAboutAuthor setTitleColor:currentCol forState:UIControlStateNormal];
	
	[UIView animateWithDuration:kAnimationDuration animations:^{
		self.colBooks.alpha = 1.0;
		self.txtAuthorDescription.alpha = 0.0;
		//self.lblAuthorDescription.alpha = 0.0;
	}];
}

- (void)btnAboutAuthor_Click:(UIButton *)sender
{
	UIColor *currentCol = sender.currentTitleColor;
	if ([currentCol isEqual:kBlueButtonTitleColor])
		return;
	
	[sender setTitleColor:self.btnBooks.currentTitleColor forState:UIControlStateNormal];
	[self.btnBooks setTitleColor:currentCol forState:UIControlStateNormal];

	[UIView animateWithDuration:kAnimationDuration animations:^{
		self.colBooks.alpha = 0.0;
		self.txtAuthorDescription.alpha = 1.0;
		//self.lblAuthorDescription.alpha = 1.0;
	}];
}

@end
