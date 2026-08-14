//
//  AuthorsCollectionViewLayout.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "AuthorsCollectionViewLayout.h"

//static const CGFloat numberOfColumns = 2.0;
static const CGFloat cellPadding = 8.0;

@interface AuthorsCollectionViewLayout ()

@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGFloat contentWidth;
@property (assign, nonatomic) UIEdgeInsets insets;

@end

@implementation AuthorsCollectionViewLayout

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.numberOfColumns = IS_IPHONE ? 2 : 3;
		self.contentWidth = 0.0;
		self.contentHeight = 0.0;
		self.cache = [NSMutableArray array];
	}
	
	return self;
}

- (void)dealloc
{
	[_cache release];
	
	[super dealloc];
}

- (void)prepareLayout
{
	self.contentWidth = [self calculateContentWidth];
	
	if (self.cache.count == 0)
	{
		CGFloat columnWidth = self.contentWidth / self.numberOfColumns;
		NSMutableArray *xOffset = [NSMutableArray array];
		NSMutableArray *yOffset = [NSMutableArray array];
		for (int i = 0; i < self.numberOfColumns; ++i)
		{
			[xOffset addObject:@(i * columnWidth)];
			[yOffset addObject:@(0)];
		}

		NSInteger column = 0;
		for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; ++i)
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
			CGFloat width = columnWidth - cellPadding * 2;
			CGFloat itemHeight =  [self.delegate collectionView:self.collectionView heightForItemAtIndexPath:indexPath withWidth:width];
			CGFloat height = cellPadding * 2 + itemHeight;
			CGRect frame = CGRectMake([xOffset[column] floatValue], [yOffset[column] floatValue], columnWidth, height);
			CGRect insetFrame = CGRectInset(frame, cellPadding, cellPadding);
			
			UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
			attributes.frame = insetFrame;
			[self.cache addObject:attributes];
			
			self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
			yOffset[column] = @([yOffset[column] floatValue] + height);
			
			column = column >= (self.numberOfColumns - 1) ? 0 : ++column;
		}
	}
}

- (CGSize)collectionViewContentSize
{
	return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *layoutAttributes = [NSMutableArray array];
	
	for (UICollectionViewLayoutAttributes *attr in self.cache)
	{
		if (CGRectIntersectsRect(attr.frame, rect))
			[layoutAttributes addObject:attr];
	}
	
	return layoutAttributes;
}

- (CGFloat)calculateContentWidth
{
	UIEdgeInsets insets = self.collectionView.contentInset;
	//NSLog(@"Insets: left - %.2f, right - %.2f, contentView width before: %.2f", insets.left, insets.right, CGRectGetWidth(self.collectionView.bounds));
	return CGRectGetWidth(self.collectionView.bounds) - (insets.left + insets.right);
}

@end
