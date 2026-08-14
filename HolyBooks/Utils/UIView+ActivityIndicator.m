//
//  UIView+ActivityIndicator.m
//  IronWaterStudio
//
//  Created by Vyacheslav Ksenofontov on 11/28/13.
//  Updated by Olga Zhegulo on 19 Aug 2015.
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import "UIView+ActivityIndicator.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "UIButton+Block.h"
#import "UIView+Autolayout.h"
#import "Constants.h"


const int kActivityIndicatorView = 0;
const int kActivityIndicatorViewCount = 0;

@implementation UIView(ActivityIndicator)

- (void)setActivityView:(UIView *)activityView {
	objc_setAssociatedObject(self, (void*)&kActivityIndicatorView, activityView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)activityView{
	return objc_getAssociatedObject( self, (void*)&kActivityIndicatorView);
}

- (void)setActivityViewCount:(int)count {
	objc_setAssociatedObject(self, (void*)&kActivityIndicatorViewCount, @(count), OBJC_ASSOCIATION_RETAIN);
}

- (int)activityViewCount {
	return [objc_getAssociatedObject(self, (void*)&kActivityIndicatorViewCount) intValue];
}


#pragma mark - ActivityIndicator
- (void)hideActivityIndicator
{
	@synchronized(self)
	{
		int count = self.activityViewCount;
		if(count > 0)
		{
			--count;
			self.activityViewCount = count;
			
			if(0 == count)
			{
				[self.activityView removeFromSuperview];
				self.activityView = nil;
			}
		}
	}
}

- (void)flushActivityIndicator
{
	@synchronized(self)
	{
		self.activityViewCount = 0;
		[self.activityView removeFromSuperview];
		self.activityView = nil;
	}
}

- (void)showActivityIndicator
{
	[self showActivityIndicator:YES
						  style:UIActivityIndicatorViewStyleGray
						  color:kColorActivityIndicator
				 grayBackground:NO
						  alpha:0.0
				withCancelBlock:nil];
}

- (void)showActivityIndicatorWithColor:(UIColor *)color
{
	[self showActivityIndicator:YES withColor:color withCancelBlock:nil];
}

- (void)showActivityIndicatorWithAlpha:(CGFloat)alpha
{
	[self showActivityIndicator:YES
						  style:UIActivityIndicatorViewStyleWhiteLarge
						  color:kColorActivityIndicator
				 grayBackground:NO
						  alpha:alpha
				withCancelBlock:nil];
}

- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityStyle
{
	[self showActivityIndicator:YES
						  style:activityStyle
						  color:nil
				 grayBackground:NO
						  alpha:0
				withCancelBlock:nil];
}

- (void)showActivityIndicator:(BOOL)showActivity withCancelBlock:(void(^)())cancelBlock
{
	[self showActivityIndicator:showActivity
					  withColor:[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.5f]
				withCancelBlock:cancelBlock];
}

- (void)showActivityIndicator:(BOOL)showActivity
					withColor:(UIColor *)color
			  withCancelBlock:(void(^)())cancelBlock
{
	[self showActivityIndicator:showActivity
						  style:UIActivityIndicatorViewStyleWhiteLarge
						  color:color
				 grayBackground:YES
						  alpha:0
				withCancelBlock:cancelBlock];
}

- (void)showActivityIndicator:(BOOL)showActivity
			   grayBackground:(BOOL)grayBackground
						style:(UIActivityIndicatorViewStyle)activityStyle
			  withCancelBlock:(void(^)())cancelBlock
{
	[self showActivityIndicator:showActivity
						  style:activityStyle
						  color:nil
				 grayBackground:grayBackground
						  alpha:0
				withCancelBlock:cancelBlock];
}

- (void)showActivityIndicator:(BOOL)showActivity
						style:(UIActivityIndicatorViewStyle)activityStyle
			   grayBackground:(BOOL)grayBackground
						alpha:(CGFloat)backgroundAlpha
			  withCancelBlock:(void(^)())cancelBlock
{
	[self showActivityIndicator:showActivity
						  style:activityStyle
						  color:nil
				 grayBackground:grayBackground
						  alpha:backgroundAlpha
				withCancelBlock:cancelBlock];
}

- (void)showActivityIndicator:(BOOL)showActivity
						style:(UIActivityIndicatorViewStyle)activityStyle
						color:(UIColor *)color
			   grayBackground:(BOOL)grayBackground
						alpha:(CGFloat)backgroundAlpha
			  withCancelBlock:(void(^)())cancelBlock
{
	@synchronized(self)
	{
		int count = self.activityViewCount;
		self.activityViewCount = count + 1;
		if(count > 0)
			return; // EXIT
		
		// ActivityView
		CGSize _size = self.frame.size;
		
		UIView *_activityView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
		_activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//		NSLog(@"Show activity in frame %@, bounds: %@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bounds));
		
		_activityView.alpha = 1.0f;
		_activityView.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:backgroundAlpha];
		[self addSubview:_activityView];
		
		if (showActivity)
		{
			// GrayView: small gray square besides activity
			if (grayBackground)
			{
				float sizeGrayView = 62.0;
				
				UIView *grayView = [[[UIView alloc] initWithFrame:CGRectMake( _size.width/2.0 - sizeGrayView/2.0,
																			 _size.height/2.0 - sizeGrayView/2.0,
																			 sizeGrayView,
																			 sizeGrayView)] autorelease];
				grayView.alpha = 0.35f;
				grayView.backgroundColor = [UIColor blackColor];
				[grayView.layer setCornerRadius:15.0f];
				[grayView.layer setMasksToBounds:YES];
				
				grayView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
				[_activityView addSubview:grayView];
			}
			
			// ActivityIndicatorView
			//float sizeActivityyView = activityStyle == UIActivityIndicatorViewStyleWhiteLarge ? 37.0f : 20.0f;
			UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc]
												  initWithActivityIndicatorStyle:activityStyle] autorelease];
			activity.frame = CGRectMake((_size.width - activity.frame.size.width) / 2.0,
										(_size.height - activity.frame.size.height) / 2.0,
										activity.frame.size.width,
										activity.frame.size.height);
			activity.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
			
			if (color)
				activity.color = color;
			//[activity setContentMode:UIViewContentModeCenter];
			[activity startAnimating];
			[_activityView addSubview:activity];
		}
		
		if (cancelBlock)
		{
			UIButton *activityButton = [[[UIButton alloc] initWithFrame:_activityView.bounds] autorelease];
			activityButton.backgroundColor = [UIColor clearColor];
			[activityButton addActionBlock:cancelBlock forControlEvents:UIControlEventTouchUpInside];
			[_activityView addSubview:activityButton];
		}
		
		// current ActivityView
		self.activityView = _activityView;
	}
}

- (void)showActivityIndicatorWithTouchBlock:(void (^)())block
{
	@synchronized(self)
	{
		[self showActivityIndicator];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button addTarget:self actionWithBlock:block forControlEvents:UIControlEventTouchUpInside];
		button.frame = self.activityView.bounds;
		
		[self.activityView addSubview:button];
	}
}

- (void)layoutActivityIndicator
{
	@synchronized(self)
	{
		CGSize _size = self.frame.size;
		
		UIView *activity = self.activityView;
		activity.frame = CGRectMake(0,
									0,
									_size.width,
									_size.height);
	}
}

@end
