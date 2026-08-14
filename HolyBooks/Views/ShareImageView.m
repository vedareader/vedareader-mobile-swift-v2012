//
//  ShareImageView.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 27/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "ShareImageView.h"
#import "UIView+Autolayout.h"
#import "NSString+SizeWithFont.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxTextHeight 300

@interface ShareImageView ()

@property (retain, nonatomic) UIImageView *imgBackground;
@property (retain, nonatomic) UIImageView *imgLogo;
@property (retain, nonatomic) UILabel *lblAppName;
@property (retain, nonatomic) UILabel *lblText;
@property (retain, nonatomic) UILabel *lblChapter;
@property (retain, nonatomic) UILabel *lblAuthor;

@property (retain, nonatomic) ShareData *shareData;

@end

@implementation ShareImageView

#pragma mark - Life cycle
- (instancetype)initWithShareData:(ShareData *)shareData
{
	if ((self = [super init]))
	{
		self.shareData = shareData;
	}
	
	[self innerInit];
	
	return self;
}

- (void)dealloc
{
	[_imgBackground release];
	[_imgLogo release];
	[_lblAppName release];
	[_lblText release];
	[_lblChapter release];
	[_lblAuthor release];
	[_shareData release];

	[super dealloc];
}

#pragma mark - Private methods
- (void)innerInit
{
	self.backgroundColor = [UIColor whiteColor];
	
	//Setup subviews
	UIImageView *imgTopQuotes = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quotes_left.png"]] autorelease];
	UIImageView *imgBottomQuotes = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quotes_right.png"]] autorelease];
	
	imgTopQuotes.translatesAutoresizingMaskIntoConstraints = NO;
	imgBottomQuotes.translatesAutoresizingMaskIntoConstraints = NO;
	
	UIImageView *imgLogo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]] autorelease];
	imgLogo.contentMode = UIViewContentModeCenter;
	imgLogo.translatesAutoresizingMaskIntoConstraints = NO;
	
	UILabel *lblAppName = [[[UILabel alloc] init] autorelease];
	lblAppName.translatesAutoresizingMaskIntoConstraints = NO;
	lblAppName.text = @"VedaReader";
	lblAppName.font = [UIFont systemFontOfSize:12];
	lblAppName.textColor = RGBA(0, 0, 0, 0.34);
	
	UILabel *lblText = [[[UILabel alloc] init] autorelease];
	lblText.translatesAutoresizingMaskIntoConstraints = NO;
	lblText.font = [UIFont systemFontOfSize:20 weight:UIFontWeightLight];
	lblText.textColor = [UIColor blackColor];
	lblText.numberOfLines = 0;
	
	UILabel *lblChapter = [[[UILabel alloc] init] autorelease];
	lblChapter.translatesAutoresizingMaskIntoConstraints = NO;
	lblChapter.font = [UIFont systemFontOfSize:16];
	lblChapter.textColor = [UIColor blackColor];
	lblChapter.textAlignment = NSTextAlignmentRight;
	
	UILabel *lblAuthor = [[[UILabel alloc] init] autorelease];
	lblAuthor.translatesAutoresizingMaskIntoConstraints = NO;
	lblAuthor.font = [UIFont systemFontOfSize:12];
	lblAuthor.textColor = RGBA(0, 0, 0, 0.34);
	lblAuthor.textAlignment = NSTextAlignmentRight;

	[self addSubview:imgTopQuotes];
	[self addSubview:imgBottomQuotes];

	[self addSubview:imgLogo];
	[self addSubview:lblAppName];
	[self addSubview:lblText];
	[self addSubview:lblChapter];
	[self addSubview:lblAuthor];

	self.imgLogo = imgLogo;
	self.lblAppName = lblAppName;
	self.lblText = lblText;
	self.lblChapter = lblChapter;
	self.lblAuthor = lblAuthor;
	
	//Constraints
	CGFloat width = 364.0;//375.0;
	CGFloat leftTextPadding = 33.0;
	CGFloat rightTextpadding = 34.0;
	
	[imgTopQuotes alignLeadingWithPadding:2.0];
	[imgTopQuotes alignTopWithPadding:20.0];
	
	[imgBottomQuotes alignTrailingWithPadding:2.0];
	[imgBottomQuotes pinTopTo:lblText withPadding:-imgBottomQuotes.bounds.size.height / 2];
	
	[lblAppName alignTopWithPadding:24.0];
	[lblAppName alignTrailingWithPadding:34.0];
	[lblAppName pinLeadingTo:imgLogo withPadding:9.0];
	
//	[imgLogo constraintWidth:20];
//	[imgLogo constraintHeightRatio:1.0];
	[imgLogo alignTopWithPadding:20.0];
	
	[lblText pinTopTo:imgLogo withPadding:20.0];
	[lblText alignLeadingWithPadding:leftTextPadding];
	[lblText alignTrailingWithPadding:rightTextpadding];
	
	[lblChapter pinTopTo:lblText withPadding:27.0];
	[lblChapter alignTrailingWithPadding:rightTextpadding];
	
	[lblAuthor pinTopTo:lblChapter withPadding:5.0];
	[lblAuthor alignTrailingWithPadding:rightTextpadding];
	[lblAuthor alignBottomWithPadding:27.0];
	
	CGFloat constraintWidth = width - (leftTextPadding + rightTextpadding);
	
	//NSLog(@"constraintWidth: %f", constraintWidth);
	
	CGFloat lblTextHeight = ceilf([self.shareData.text textSizeWithFont:self.lblText.font width:constraintWidth].height);
	CGFloat lblChapterHeight = ceilf([self.shareData.chapter textSizeWithFont:self.lblChapter.font width:constraintWidth].height);
	CGFloat lblAuthorHeight = ceilf([self.shareData.authorName textSizeWithFont:self.lblAuthor.font width:constraintWidth].height);
	
	// Big texts will be truncated here
	lblTextHeight = MIN(lblTextHeight, kMaxTextHeight);
	
	[lblText constraintHeight:lblTextHeight];
	[lblChapter constraintHeight:lblChapterHeight];
	[lblAuthor constraintHeight:lblAuthorHeight];
	
	CGFloat sumOfDesignIdentations = 20.0 + 20.0 + 27.0 + 5.0 + 27.0;
	CGFloat imgLogoHeight = 20.0;
	
	CGFloat height = imgLogoHeight + lblTextHeight + lblChapterHeight + lblAuthorHeight + sumOfDesignIdentations;
	
	self.frame = CGRectMake(0, 0, width, height);
	
	NSLog(@"shareImage frame: %@", NSStringFromCGRect(self.frame));
	
	//self.layer.contentsScale = [UIScreen mainScreen].scale;
	
	[self fillData];
}

#pragma mark - Functionality
- (void)fillData
{
	//Fill data
	self.lblText.text = self.shareData.text;
	self.lblChapter.text = self.shareData.chapter;
	self.lblAuthor.text = self.shareData.authorName;
}

- (UIImage *)renderedImage
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 2.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	//UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
	
	return img;
}

@end
