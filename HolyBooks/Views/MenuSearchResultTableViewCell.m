//
//  MenuSearchResultTableViewCell.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 26/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "MenuSearchResultTableViewCell.h"
#import "HolyBook.h"
#import "HolyAuthor.h"
#import "UIView+Autolayout.h"

@interface MenuSearchResultTableViewCell ()

//@property (retain, nonatomic, nonnull) SearchResultItem *searchResult;

@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (retain, nonatomic) UILabel *lblTitle;
@property (retain, nonatomic) UILabel *lblItemType;

@end

@implementation MenuSearchResultTableViewCell

- (instancetype)init
{
	self = [super init];
	if (self == nil)
	{
		return nil;
	}
	
	[self innerInit];
	
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self == nil)
	{
		return nil;
	}
	
	[self innerInit];
	
	return self;
}

- (void)dealloc
{
	[_tapRecognizer release];
	[_lblTitle release];
	[_lblItemType release];
	
	[super dealloc];
}

#pragma mark - methods
- (void)fillWithItem:(id)searchItem
{
	if ([searchItem isKindOfClass:[HolyBook class]])
	{
		self.lblTitle.text = ((HolyBook *)searchItem).name;
		self.lblItemType.text = @"Книга";
	}
	else
	{
		self.lblTitle.text = ((HolyAuthor *)searchItem).name;
		self.lblItemType.text = @"Автор";
	}
}

#pragma mark - private
- (void)innerInit
{
	//self.tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
	//[self.tapRecognizer addTarget:self action:@selector(tapRecognizerDidTap:)];
	//[self addGestureRecognizer:self.tapRecognizer];
	
	UILabel *lblTitle = [[[UILabel alloc] init] autorelease];
	lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
	lblTitle.font = [UIFont systemFontOfSize:18.0];
	lblTitle.textColor = [UIColor whiteColor];
	self.lblTitle = lblTitle;
	
	[self.contentView addSubview:lblTitle];
	
	UILabel *lblItemType = [[[UILabel alloc] init] autorelease];
	lblItemType.translatesAutoresizingMaskIntoConstraints = NO;
	lblItemType.font = [UIFont systemFontOfSize:14.0];
	lblItemType.textColor = RGBA(255, 255, 255, 0.34);
	self.lblItemType = lblItemType;
	
	[self.contentView addSubview:lblItemType];
	
	//self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// constraints
	//[self.contentView constraintHeight:100.0];
	
	NSLayoutConstraint *cTop = [NSLayoutConstraint constraintWithItem:lblTitle
															attribute:NSLayoutAttributeTop
															relatedBy:NSLayoutRelationLessThanOrEqual
															   toItem:self.contentView
															attribute:NSLayoutAttributeTop
														   multiplier:1
															 constant:13.0];
	cTop.priority = UILayoutPriorityDefaultHigh;
	cTop.active = YES;
	
	//[lblTitle alignTopWithPadding:3.0];
	[lblTitle alignLeadingWithPadding:23.0];
	[lblTitle alignTrailingWithPadding:23.0];
	//[lblTitle constraintHeight:24.0];
	
	[lblItemType pinTopTo:lblTitle withPadding:0.0];
	[lblItemType alignAttribute:NSLayoutAttributeLeading to:lblTitle withPadding:0.0];
	[lblItemType alignAttribute:NSLayoutAttributeTrailing to:lblTitle withPadding:0.0];
	//[lblItemType constraintHeight:19.0];
	
	NSLayoutConstraint *cBottom = [NSLayoutConstraint constraintWithItem:lblItemType
															attribute:NSLayoutAttributeBottom
															relatedBy:NSLayoutRelationLessThanOrEqual
															   toItem:self.contentView
															attribute:NSLayoutAttributeBottom
														   multiplier:1
															 constant:13.0];
	cBottom.priority = UILayoutPriorityDefaultHigh;
	cBottom.active = YES;
	
	//[lblItemType alignBottomWithPadding:3.0];
}

#pragma mark - Handlers
- (void)tapRecognizerDidTap:(id)sender
{
//	if ([self.delegate respondsToSelector:@selector(searchResultTableViewCellDidSelect:)])
//	{
//		[self.delegate searchResultTableViewCellDidSelect:self];
//	}
}

@end
