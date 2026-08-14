//
//  AuthorCollectionViewCell.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "AuthorCollectionViewCell.h"
#import "UIView+Autolayout.h"
#import "HolyContentManager.h"
#import "ImageManager.h"
#import "Localization.h"

@interface AuthorCollectionViewCell ()

@property (retain, nonatomic) UIImageView *img;
@property (retain, nonatomic) UILabel *lblAuthorName;
@property (retain, nonatomic) UILabel *lblBookQuantity;

@end

@implementation AuthorCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	if(!(self = [super initWithFrame:frame]))
	{
		return nil;
	}
	
	[self innerInit];
	return self;
}

- (void)dealloc
{
	[_img release];
	[_lblAuthorName release];
	[_lblBookQuantity release];
	
	[super dealloc];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.img = nil;
}

#pragma mark - methods
- (void)innerInit
{
	[self setupSubviews];
	[self setupConstraints];
}

- (void)setupSubviews
{
	self.contentView.layer.cornerRadius = 5.0;
	self.contentView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *img = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"author_default"]] autorelease];
	img.translatesAutoresizingMaskIntoConstraints = NO;
	img.clipsToBounds = YES;
	img.contentMode = UIViewContentModeScaleAspectFill;
	[self.contentView addSubview:img];
	self.img = img;
	
	UILabel *lblAuthorName = [[[UILabel alloc] init] autorelease];
	lblAuthorName.translatesAutoresizingMaskIntoConstraints = NO;
	lblAuthorName.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular];
	lblAuthorName.numberOfLines = 0;
	[self.contentView addSubview:lblAuthorName];
	self.lblAuthorName = lblAuthorName;
	
	UILabel *lblBookQuantity = [[[UILabel alloc] init] autorelease];
	lblBookQuantity.translatesAutoresizingMaskIntoConstraints = NO;
	lblBookQuantity.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
	lblBookQuantity.textColor = RGBA(0, 0, 0, 0.34);
	[self.contentView addSubview:lblBookQuantity];
	self.lblBookQuantity = lblBookQuantity;
}

- (void)setupConstraints
{
	CGFloat width = self.contentView.bounds.size.width;
	
	[self.img dockTop];
	NSLayoutConstraint *c = [self.img constraintHeight:width];
	c.priority = UILayoutPriorityDefaultHigh;
	[self.img constraintHeightRatio:1.0];

	[self.lblAuthorName pinTopTo:self.img withPadding:16.0];
	[self.lblAuthorName alignLeadingWithPadding:12.0];
	[self.lblAuthorName alignTrailingWithPadding:12.0];
	//[self.lblAuthorName alignCenterXTo:self.img];
	//[self.lblAuthorName constraintWidth:width - 2 * 12.0];
	
	[self.lblBookQuantity pinTopTo:self.lblAuthorName withPadding:4.0];
	[self.lblBookQuantity alignLeadingWithPadding:12.0];
	[self.lblBookQuantity alignTrailingWithPadding:12.0];
	//[self.lblBookQuantity alignCenterXTo:self.img];
	//[self.lblBookQuantity constraintWidth:width - 2 * 12.0];
	[self.lblBookQuantity alignBottomWithPadding:19.0];
}

- (void)fillWithAuthor:(HolyAuthor *)author
{
	self.lblAuthorName.text = author.name;
	
	NSString *imagePath = [HolyContentManager authorImagePathWithURL:author.image];
	NSString *imageURL = [HolyContentManager authorImageURLWithImageName:author.image];
	
	[ImageManager getAndCacheImageAsync:imageURL imagePath:imagePath completedBlock:^(UIImage *image) {
		self.img.image = image;
	}];
	
	NSInteger booksQuantity = [[[HolyContentManager sharedManager].booksForAuthorId objectForKey:@(author.identity)] integerValue];
	NSString *booksQuantityFormat = [Localization textForKey:@"Authors.BooksQuantity" number:booksQuantity];
	
	self.lblBookQuantity.text = [NSString stringWithFormat:booksQuantityFormat, (long)booksQuantity];
	
	// if need to get value from db
	/*
	NSInteger booksQuantity = [HolyContentManager booksAmountForAuthorId:author.identity];
	NSString *booksQuantityFormat = [Localization textForKey:@"Authors.BooksQuantity" number:booksQuantity];
	
	self.lblBookQuantity.text = [NSString stringWithFormat:booksQuantityFormat, (long)booksQuantity];
	 */
}

#pragma mark - Helper methods
+ (NSString *)reuseID
{
	NSString *result = NSStringFromClass(self);
	
	return result;
}

+ (void)registerFor:(UICollectionView *)collectionView
{
	NSString *reuseID = [self reuseID];
	
	[collectionView registerClass:[self class] forCellWithReuseIdentifier:reuseID];
}

- (NSString *)reuseIdentifier
{
	return [[self class] reuseID];
}


@end
