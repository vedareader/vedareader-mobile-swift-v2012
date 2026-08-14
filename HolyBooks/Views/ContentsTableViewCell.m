//
//  ContentsTableViewCell.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 11/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "ContentsTableViewCell.h"

#import "UIView+Autolayout.h"

#define kTitlePaddingTop 8.0
#define kTitlePaddingBottom 8.0
#define kTitlePaddingLeading 10.0

@interface ContentsTableViewCell ()

@property (retain, nonatomic) ChapterDescription *chapterDescription;

@property (assign, nonatomic) UILabel *lblTitle;
@property (assign, nonatomic) UILabel *lblPage;

@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation ContentsTableViewCell

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
	[_chapterDescription release];
	[_tapRecognizer release];
	
	[super dealloc];
}

#pragma mark - methods
- (void)fillWithDescription:(ChapterDescription *)description
{
	self.chapterDescription = description;
	
	self.lblTitle.text = description.title;
	self.lblPage.text = [NSString stringWithFormat:@"%ld", (long)description.pageIndex + 1];
}

#pragma mark - private
- (void)innerInit
{
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	self.tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
	[self.tapRecognizer addTarget:self action:@selector(tapRecognizerDidTap:)];
	
	[self addGestureRecognizer:self.tapRecognizer];
	
	UILabel * const lblTitle = [[UILabel alloc] init];
	lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
	lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
	[lblTitle setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[lblTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh - 1 forAxis:UILayoutConstraintAxisHorizontal];

	[self.contentView addSubview:lblTitle];
	self.lblTitle = lblTitle;
	
	UILabel * const lblPage = [[UILabel alloc] init];
	lblPage.translatesAutoresizingMaskIntoConstraints = NO;
	lblPage.textAlignment = NSTextAlignmentRight;
	[lblPage setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];
	[lblPage setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
	
	[self.contentView addSubview:lblPage];
	self.lblPage = lblPage;
	
	[self.lblTitle alignTopWithPadding:kTitlePaddingTop];
	[self.lblTitle alignBottomWithPadding:kTitlePaddingBottom];
	[self.lblTitle alignLeadingWithPadding:kTitlePaddingLeading];
	
	[self.lblPage alignCenterYTo:self.lblTitle];
	[self.lblPage pinLeadingTo:self.lblTitle withPadding:10.0];
	[self.lblPage alignTrailingWithPadding:10.0];
}

#pragma mark - Handlers
- (void)tapRecognizerDidTap:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(contentsTableViewCellDidSelect:)])
	{
		[self.delegate contentsTableViewCellDidSelect:self];
	}
}

@end
