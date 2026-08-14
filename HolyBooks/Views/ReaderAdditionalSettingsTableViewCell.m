//
//  ReaderAdditionalSettingsTableViewCell.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 16/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "ReaderAdditionalSettingsTableViewCell.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"

@interface ReaderAdditionalSettingsTableViewCell ()

@property (retain, nonatomic) UILabel *lblTitle;
@property (retain, nonatomic) UIImageView *imgCheckMark;
@property (assign, nonatomic) ReaderSettingType type;

@end

@implementation ReaderAdditionalSettingsTableViewCell

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
	[_lblTitle release];
	[_imgCheckMark release];
	
	[super dealloc];
}

#pragma mark - methods
- (void)innerInit
{
	//UITapGestureRecognizer *tapRecognizer = [[[UITapGestureRecognizer alloc] init] autorelease];
	//[tapRecognizer addTarget:self action:@selector(tapRecognizerDidTap:)];
	//[self addGestureRecognizer:tapRecognizer];
	
	[self setupSubviews];
	[self setupConstraints];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupSubviews
{
	UILabel *lblTitle = [[[UILabel alloc] init] autorelease];
	lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
	lblTitle.font = [UIFont systemFontOfSize:13.0];
	[self.contentView addSubview:lblTitle];
	self.lblTitle = lblTitle;
	
	UIImageView *imgCheckMark = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]] autorelease];
	imgCheckMark.translatesAutoresizingMaskIntoConstraints = NO;
	[self.contentView addSubview:imgCheckMark];
	self.imgCheckMark = imgCheckMark;
}

- (void)setupConstraints
{
	//[self.contentView constraintHeight:48.0];
	
	[self.lblTitle alignLeadingWithPadding:14.0];
	[self.lblTitle alignAttribute:NSLayoutAttributeCenterY to:self.contentView withPadding:0.0];
	
	[self.imgCheckMark pinLeadingTo:self.lblTitle withPadding:10.0];
	[self.imgCheckMark alignTrailingWithPadding:13.0];
	[self.imgCheckMark constraintWidth:13.0];
	[self.imgCheckMark constraintHeight:11.0];
	[self.imgCheckMark alignCenterYTo:self.lblTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
	self.imgCheckMark.hidden = !selected;
}

- (void)fillWithTitle:(NSString *)title type:(ReaderSettingType)type
{
	self.lblTitle.text = title;
	self.type = type;
	if (type == ReaderSettingTypeFont)
	{
		UIFont *font = [UIFont fontWithName:title size:13.0];
		self.lblTitle.font = font;
	}
	else
	{
		
	}
	
}
/*
#pragma mark - Handlers
- (void)tapRecognizerDidTap:(UITapGestureRecognizer *)sender
{
	NSLog(@"did tap");
	self.imgCheckMark.hidden = !self.imgCheckMark.hidden;
	
	if ([self.delegate respondsToSelector:@selector(readerAdditionalSettingsTableViewCell:didSelectFontWithName:)])
	{
		[self.delegate readerAdditionalSettingsTableViewCell:self didSelectFontWithName:self.lblTitle.text];
	}
}
*/
@end
