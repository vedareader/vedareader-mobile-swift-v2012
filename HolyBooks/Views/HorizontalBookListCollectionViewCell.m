//
//  HorizontalBookListCollectionViewCell.m
//  HolyBooks
//
//  Created by Roman Developer on 10/28/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HorizontalBookListCollectionViewCell.h"
#import "UIView+Autolayout.h"
#import "HolyContentManager.h"
#import "NSArray+LINQ.h"
#import "HolyAuthor.h"
#import "HolyBook.h"
#import "ImageManager.h"

@implementation HorizontalBookListCollectionViewCell

- (instancetype)init
{
	if (self = [super init])
	{
		[self innerInit];
	}
	
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self innerInit];
}

- (void)innerInit
{
	//Constraints
	self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView dockAll];
	
	[_imgBookCover dockTop];
	[_imgBookCover constraintHeight:112];
	
	[_lblBookName alignLeadingWithPadding:0];
	[_lblBookName alignTrailingWithPadding:0];
	[_lblBookName pinTopTo:_imgBookCover withPadding:8];
	
	[_lblBookAuthor pinTopTo:_lblBookName withPadding:0];
	[_lblBookAuthor alignLeadingWithPadding:0];
	[_lblBookAuthor alignTrailingWithPadding:0];
}

- (void)dealloc
{
    [_imgBookCover release];
    [_lblBookName release];
    [_lblBookAuthor release];
    [super dealloc];
}

#pragma mark - Functionality
- (void)fillDataWithBook: (HolyBook *)book horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass
{
	//For regular size class
	if (horizontalSizeClass == UIUserInterfaceSizeClassRegular)
	{
		_lblBookName.font = [UIFont boldSystemFontOfSize:14];
		_lblBookAuthor.font = [UIFont systemFontOfSize:12];
		[_imgBookCover heightConstraint].constant = 200;
		//NSLog(@"Regular, height constraint: %@, all constraints: %@", [_imgBookCover heightConstraint], _imgBookCover.constraints);
	}
	else
	{
		_lblBookName.font = [UIFont boldSystemFontOfSize:12];
		_lblBookAuthor.font = [UIFont systemFontOfSize:8];
		[_imgBookCover heightConstraint].constant = 112;
		//NSLog(@"Compact, height constraint: %@, all constraints: %@", [_imgBookCover heightConstraint], _imgBookCover.constraints);
	}
//	NSLogRecursive(self);
//	NSLogConstraints(self);
	
	HolyAuthor *author = [[[HolyContentManager sharedManager].authors where:@"identity == %d", book.authorID] lastObject];
	NSString *imagePath = [HolyContentManager bookImagePathWithURL:book.image];
	NSString *imageURL = [HolyContentManager bookImageURLWithImageName:book.image];
	
	_imgBookCover.image = [UIImage imageNamed:@"book_default.png"];
	[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
		_imgBookCover.image = image;
	}];
	
	_lblBookName.text = book.name;
	_lblBookAuthor.text = author.name;
	
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

@end
