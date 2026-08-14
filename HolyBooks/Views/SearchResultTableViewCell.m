//
//  SearchResultTableViewCell.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 25/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "SearchResultTableViewCell.h"

#import "UIView+Autolayout.h"

@interface SearchResultTableViewCell ()

@property (retain, nonatomic, nonnull) SearchResultItem *searchResult;

@property (assign, nonatomic) UILabel *lblChapterIndex;
@property (assign, nonatomic) UILabel *lblChapterTitle;
@property (assign, nonatomic) UILabel *lblPageIndex;
@property (assign, nonatomic) UILabel *lblText;

@property (retain, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation SearchResultTableViewCell

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
	[_searchResult release];
	[_tapRecognizer release];
	
	[super dealloc];
}

#pragma mark - methods
- (void)fillWithData:(SearchResultItem *)data
{
	self.searchResult = data;
	
	self.lblChapterIndex.text = [NSString stringWithFormat:Local(@"SearchResult.ChapterIndexFormat"), (long)data.chapterIndex];
	self.lblChapterTitle.text = [NSString stringWithFormat:Local(@"SearchResult.ChapterTitleFormat"), data.chapterTitle];
	self.lblPageIndex.text = [NSString stringWithFormat:Local(@"SearchResult.PageIndexFormat"), (long)data.pageIndex];
	self.lblText.text = [data.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	
	[self setNeedsLayout];
}

#pragma mark - private
- (void)innerInit
{
	self.tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
	
	[self.tapRecognizer addTarget:self action:@selector(tapRecognizerDidTap:)];
	
	[self addGestureRecognizer:self.tapRecognizer];
	
	UILabel * const lblChapterIndex = [[[UILabel alloc] init] autorelease];
	lblChapterIndex.translatesAutoresizingMaskIntoConstraints = NO;
	[lblChapterIndex setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];
	[lblChapterIndex setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisHorizontal];
	
	[self.contentView addSubview:lblChapterIndex];
	self.lblChapterIndex = lblChapterIndex;

	UILabel * const lblChapterTitle = [[[UILabel alloc] init] autorelease];
	lblChapterTitle.translatesAutoresizingMaskIntoConstraints = NO;
	lblChapterTitle.lineBreakMode = NSLineBreakByTruncatingTail;
	[lblChapterTitle setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
	[lblChapterTitle setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

	[self.contentView addSubview:lblChapterTitle];
	self.lblChapterTitle = lblChapterTitle;

	UILabel * const lblPageIndex = [[[UILabel alloc] init] autorelease];
	lblPageIndex.translatesAutoresizingMaskIntoConstraints = NO;
	[lblPageIndex setContentHuggingPriority:UILayoutPriorityDefaultLow + 1 forAxis:UILayoutConstraintAxisHorizontal];
	[lblPageIndex setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh + 1 forAxis:UILayoutConstraintAxisHorizontal];
	
	[self.contentView addSubview:lblPageIndex];
	self.lblPageIndex = lblPageIndex;
	
	UILabel * const lblText = [[UILabel alloc] init];
	lblText.translatesAutoresizingMaskIntoConstraints = NO;
	lblText.font = [UIFont systemFontOfSize:12.0];
	lblText.textColor = kColorLightGrey;

	[self.contentView addSubview:lblText];
	self.lblText = lblText;
	
	// constraints
	[self.contentView constraintHeight:50.0];
	
	[self.lblChapterIndex alignLeadingWithPadding:10.0];
	[self.lblChapterIndex alignAttribute:NSLayoutAttributeCenterY to:self.contentView withPadding:-10.0];
	[self.lblChapterIndex alignAttribute:NSLayoutAttributeBottom to:self.lblChapterTitle withPadding:0.0];

	[self.lblChapterTitle pinLeadingTo:self.lblChapterIndex withPadding:5.0];
	[self.lblChapterTitle alignAttribute:NSLayoutAttributeCenterY to:self.contentView withPadding:-10.0];
	
	[self.lblPageIndex pinLeadingTo:self.lblChapterTitle withPadding:5.0];
	[self.lblPageIndex alignAttribute:NSLayoutAttributeCenterY to:self.contentView withPadding:-10.0];
	[self.lblPageIndex alignAttribute:NSLayoutAttributeBottom to:self.lblChapterTitle withPadding:0.0];
	
	[self.lblPageIndex alignTrailingWithPadding:20.0];
	
	[self.lblText pinTopTo:self.lblChapterTitle withPadding:0.0];
	[self.lblText alignBottomWithPadding:5.0];
	[self.lblText alignLeadingWithPadding:20.0];
	[self.lblText alignTrailingWithPadding:20.0];
}

#pragma mark - Handlers
- (void)tapRecognizerDidTap:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(searchResultTableViewCellDidSelect:)])
	{
		[self.delegate searchResultTableViewCellDidSelect:self];
	}
}

@end
