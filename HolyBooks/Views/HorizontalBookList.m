//
//  HorizontalBookList.m
//  HolyBooks
//
//  Created by Roman Developer on 10/29/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HorizontalBookList.h"
#import "HolyContentManager.h"
#import "HorizontalBookListCollectionViewCell.h"
#import "HolyClasses.h"
#import "UIView+Create.h"
#import "NSArray+LINQ.h"
#import "Settings.h"

@interface HorizontalBookList ()

@property (nonatomic, retain) NSArray <HolyBook *> *books;

@end

@implementation HorizontalBookList

+ (instancetype)create
{
	HorizontalBookList *view = (HorizontalBookList *)[self createFromNib];
	[view innerInit];
	return view;
}

- (void)innerInit
{
	[self.colBooks registerNib:[UINib nibWithNibName:@"HorizontalBookListCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HorizontalBookListCollectionViewCell"];
}

- (void)dealloc
{
	[_books release];
	
	[_lblTitle release];
	[_colBooks release];
	[super dealloc];
}

- (NSMutableArray <NSNumber *> *)selectedLanguages
{
	NSMutableArray <NSNumber *> *selectedLanguages = [NSMutableArray array];
	for (HolyLanguage *language in [HolyContentManager sharedManager].languages)
		if ([[Settings sharedSettings] languageOnWithID:language.identity])
			[selectedLanguages addObject:@(language.identity)];

	return selectedLanguages;
}

- (void)fillWithType: (HorizontalBookListType)type horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass
{
	//Data
	switch (type)
	{
		case HorizontalBookListTypeRecommendation:
		{
			NSArray *temp = [[HolyContentManager sharedManager].recommendations select:@"bookID"];
			//NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"identity IN %@ && languageID IN %@", temp, [self selectedLanguages]];
			//self.books = [self.books filteredArrayUsingPredicate:myPredicate];
			self.books = [[HolyContentManager sharedManager].books where:@"identity IN (%@) && languageID IN (%@)", temp, [self selectedLanguages]];
			break;
		}
		case HorizontalBookListTypeAuthor:
			self.books = [[HolyContentManager sharedManager].books where:@"authorID == %ld && identity != %ld && languageID IN (%@)", (long)_authorID, (long)_excludeBookID, [self selectedLanguages]];
			break;
		case HorizontalBookListTypeMyLatest:
			self.books = [HolyBook getAll];	//TODO: order by download date (should be on file. And we should show files here)
			break;
			
		default:
			NSLog(@"HorizontalBookListType not recognized: %ld", (long)type);
			break;
	}
	
	//Interface
	self.horizontalSizeClass = horizontalSizeClass;
	_cCollectionViewHeight.constant = ((self.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? kHorizontalBookListCellCompactSize : kHorizontalBookListCellRegularSize).height;
	
	if (self.books.count == 0)
		self.lblTitle.hidden = YES;
	else
		self.lblTitle.hidden = NO;
	
	switch (type)
	{
		case HorizontalBookListTypeRecommendation:
			self.lblTitle.text = Local(@"HorizontalBookList.Recommendation");
		break;
		case HorizontalBookListTypeAuthor:
			self.lblTitle.text = Local(@"HorizontalBookList.Author");
		break;
		case HorizontalBookListTypeMyLatest:
			self.lblTitle.text = Local(@"HorizontalBookList.MyLatest");
		break;
			
		default:
			NSLog(@"HorizontalBookListType not recognized: %ld", (long)type);
		break;
	}
	
	[_colBooks reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentityShelf = @"HorizontalBookListCollectionViewCell";
	HorizontalBookListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentityShelf forIndexPath:indexPath];
	
	//Fill cell data
	HolyBook *book = self.books[indexPath.row];
	[cell fillDataWithBook:book horizontalSizeClass:self.horizontalSizeClass];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Selected: %ld", (long)indexPath.row);
	
	HolyBook *book = self.books[indexPath.row];
	[self.delegate bookDidSelected:book.identity];
	
	//GA
	[GAHelper logEventWithCategory:kCategoryLibrary action:kActionBookClick value:@(book.identity)];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? kHorizontalBookListCellCompactSize : kHorizontalBookListCellRegularSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? UIEdgeInsetsMake(0, 15, 0, 15) : UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
	return (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 15 : 28;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? 15 : 28;
}

@end
