//
//  UIView+ActivityIndicator.h
//  IronWaterStudio
//
//  Created by Vyacheslav Ksenofontov on 11/28/13.
//  Updated by Olga Zhegulo on 19 Aug 2015.
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(ActivityIndicator)

- (void)hideActivityIndicator;
- (void)flushActivityIndicator;

- (void)showActivityIndicator;
- (void)showActivityIndicatorWithColor:(UIColor *)color;
- (void)showActivityIndicatorWithAlpha:(CGFloat)alpha;
- (void)showActivityIndicatorWithStyle:(UIActivityIndicatorViewStyle)activityStyle;

- (void)showActivityIndicator:(BOOL)showActivity
			  withCancelBlock:(void(^)())cancelBlock;

- (void)showActivityIndicator:(BOOL)showActivity
			   grayBackground:(BOOL)grayBackground
						style:(UIActivityIndicatorViewStyle)activityStyle
			  withCancelBlock:(void(^)())cancelBlock;

- (void)showActivityIndicator:(BOOL)showActivity
						style:(UIActivityIndicatorViewStyle)activityStyle
			   grayBackground:(BOOL)grayBackground
						alpha:(CGFloat)backgroundAlpha
			  withCancelBlock:(void(^)())cancelBlock;

- (void)showActivityIndicator:(BOOL)showActivity
						style:(UIActivityIndicatorViewStyle)activityStyle
						color:(UIColor *)color
			   grayBackground:(BOOL)grayBackground
						alpha:(CGFloat)backgroundAlpha
			  withCancelBlock:(void(^)())cancelBlock;

//NOTE: NEEDED when activity added in viewDidLoad; call when layout subviews
//Put activity into center of view (needed when view size changes since activity added)
- (void)layoutActivityIndicator;

@property (readonly, nonatomic) UIView *activityView;

@end
