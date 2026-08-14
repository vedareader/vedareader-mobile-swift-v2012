//
//  MyBooksViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 9/17/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "MyBooksViewController.h"
#import "HolyContentManager.h"
#import "HolyBook.h"
#import "BookState.h"

#import "UIViewController+CustomDraw.h"
#import "UIImage+Background.h"
#import "UIView+Autolayout.h"
#import "NSArray+LINQ.h"

@interface MyBooksViewController ()

@property (nonatomic, retain) NSArray <HolyBook *> *downloadedBooks;

@property (nonatomic, assign) BOOL isEdit;

@end

@implementation MyBooksViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//Navigation
	self.navigationController.navigationBarHidden = NO;
	
	if (@available(iOS 11, *))
	{
		self.colBooks.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}
	else
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	//Navigation buttons
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"icon_menu" action:@selector(btnMenu_Click:)];
	self.title = Local(@"MyBooks.Title");
	
	//Empty view
	_lblEmpty1.text = Local(@"MyBooks.Empty1");
	_lblEmpty2.text = Local(@"MyBooks.Empty2");
	
	//Background
	_colBooks.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage backgroundImage]] autorelease];
	
	[_colBooks registerNib:[UINib nibWithNibName:@"VerticalBookListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"VerticalBookListCollectionViewCell"];
	[_colBooks registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
	
	self.colCollection = _colBooks;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Navigation
	self.navigationController.navigationBarHidden = NO;
	
	[self reloadData];
	
	[self setRightBarButton];
	
	[self.delegate mainMenuResumeInteracting];
	
	//GA
	[GAHelper logScreen:kScreenMyBooks];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	//NSLog(@"MyBooksViewController viewWillLayoutSubviews");
	
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
	
	//NSLog(@"MyBooksViewController traitCollectionDidChange");
	
	[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	[_colBooks reloadData];
}

- (void)dealloc
{
	[_colBooks release];
	[_hblRecommendations release];
	[_imgDivider release];
    [_vEmpty release];
    [_lblEmpty1 release];
    [_lblEmpty2 release];
	[super dealloc];
}

#pragma mark - Private
- (void)reloadData
{
	//Data
	self.downloadedBooks = [HolyBook getAll];
	
	//Empty view
	_colBooks.hidden = (self.downloadedBooks.count == 0);
	_vEmpty.hidden = !_colBooks.hidden;
}

- (UIView *)headerView
{
	UIView *vHeader = [[[UIView alloc] init] autorelease];
	//vHeader.backgroundColor = [UIColor magentaColor];
	
	//Horizontal list
	self.hblRecommendations = [HorizontalBookList create];
	_hblRecommendations.delegate = self;
	[vHeader addSubview:_hblRecommendations];
	
	_hblRecommendations.translatesAutoresizingMaskIntoConstraints = NO;
	[_hblRecommendations dockTop];
	[_hblRecommendations constraintHeight:kHorizontalBookListHeight];
	
	[_hblRecommendations fillWithType:HorizontalBookListTypeMyLatest horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	
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

- (void)setRightBarButton
{
	if (self.downloadedBooks.count == 0)
		self.navigationItem.rightBarButtonItem = nil;
	else
	{
		NSString *title = self.isEdit ? Local(@"MyBooks.Done") : Local(@"MyBooks.Edit");
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(btnEdit_Click:)];
	}
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.downloadedBooks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentityShelf = @"VerticalBookListCollectionViewCell";
	VerticalBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentityShelf forIndexPath:indexPath];
	
	//Fill cell data
	HolyBook *book = self.downloadedBooks[indexPath.row];
	[cell fillDataWithBook:book horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	cell.delegate = self;
	[cell setDeleteVisible:self.isEdit];
	
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
		
		//If initialized, just return
		if (reusableView.subviews.count == 0)
		{
			UIView *headerView = [self headerView];
			headerView.translatesAutoresizingMaskIntoConstraints = NO;
			[reusableView addSubview:headerView];
			[headerView alignTopWithPadding:0];
			[headerView alignLeadingWithPadding:0];
			[headerView alignTrailingWithPadding:0];
			
			[headerView constraintHeight:kHorizontalBookListHeight];
		}
		
		return reusableView;
	}
	
	return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
	CGSize headerSize = CGSizeMake(collectionView.frame.size.width, kHorizontalBookListHeight);
	return headerSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	HolyBook *book = self.downloadedBooks[indexPath.row];
	NSLog(@"Book selected: %ld", (long)book.identity);
	
	[self openBookDetailsForBookID:book.identity];
	
	//GA
	[GAHelper logEventWithCategory:kCategoryMyBooks action:kActionBookClick value:@(book.identity)];
}

#pragma mark - VerticalBookListCellDelegate
- (void)bookDeleteSelected:(NSInteger)bookID
{
	//Delete
	HolyBook *book = [HolyBook getByID:bookID];
	[book remove];
	[[BookState getByID:bookID] clear];
	
	//Reload content
	[self reloadData];
	[_colBooks reloadData];
	[_hblRecommendations fillWithType:HorizontalBookListTypeMyLatest horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	
	//Edit state
	if (self.downloadedBooks.count == 0)
	{
		self.isEdit = NO;
		[self setRightBarButton];
	}
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

- (void)btnEdit_Click: (id)sender
{
	if (self.downloadedBooks.count == 0)
		return;
	
	self.isEdit = !self.isEdit;
	
	[self setRightBarButton];
	
	[_colBooks reloadData];
}

@end
