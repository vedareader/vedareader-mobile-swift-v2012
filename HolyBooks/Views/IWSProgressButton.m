//
//  IWSProgressButton.m
//  HolyBooks
//
//  Created by Roman Developer on 2/1/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "IWSProgressButton.h"

@interface IWSProgressButton ()

@property (nonatomic, retain) UIView *vProgress;

@end

@implementation IWSProgressButton

- (void)configureForState: (BookState *)bookState
{
	if (!bookState.isDownloaded)
	{
		if (bookState.downloadInfo == nil)
		{
			[self setTitle:Local(@"VerticalBookList.Download") forState:UIControlStateNormal];
			[self setTitleColor:kColorBlue forState:UIControlStateNormal];
			
			self.layer.borderColor = [kColorBlue CGColor];
			
			[self setProgress:0];
		}
		else
		{
			[self setTitle:Local(@"VerticalBookList.Downloading") forState:UIControlStateNormal];
			[self setTitleColor:kColorBlue forState:UIControlStateNormal];
			
			self.layer.borderColor = [kColorBlue CGColor];
			
			//NSLog(@"bytesReceived: %f, bytesTotal: %f", (CGFloat)bookState.downloadInfo.bytesReceived, (CGFloat)bookState.downloadInfo.bytesTotal);
			if (bookState.downloadInfo.bytesTotal != 0)
				[self setProgress:(CGFloat)bookState.downloadInfo.bytesReceived / (CGFloat)bookState.downloadInfo.bytesTotal];
		}
	}
	else
	{
		[self setTitle:Local(@"VerticalBookList.Read") forState:UIControlStateNormal];
		[self setTitleColor:kColorGreen forState:UIControlStateNormal];
		
		self.layer.borderColor = [kColorGreen CGColor];
		
		[self setProgress:0];
	}
}

- (void)setProgress: (CGFloat)progress
{
	//Init
	if (_vProgress == nil)
	{
		_vProgress = [[[UIView alloc] init] autorelease];
		_vProgress.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
		_vProgress.alpha = 0.4;
		[self insertSubview:_vProgress atIndex:0];
	}
	
	//Progress
	_vProgress.backgroundColor = [UIColor colorWithCGColor:self.layer.borderColor];
	_vProgress.frame = CGRectSetWidth(_vProgress.frame, self.frame.size.width * progress);
	_vProgress.frame = CGRectSetHeight(_vProgress.frame, self.frame.size.height);
	
	//NSLog(@"Progress: %f, width should be: %f", progress, self.frame.size.width * progress);
	//NSLogRect(_vProgress.frame);
}

@end
