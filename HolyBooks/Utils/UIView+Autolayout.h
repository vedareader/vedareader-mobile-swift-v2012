//
//  UIView+Autolayout.h
//  TestProject
//
//  Created by RomanMac on 22/01/15.
//  Copyright (c) 2015 ironwaterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Autolayout)

//Children
- (void)centerXSubviews;
- (void)centerYSubviews;

//To parent
- (void)dockTop;
- (void)dockLeading;
- (void)dockBottom;
- (void)dockTrailing;

- (void)dockTopToCenter;
- (void)dockLeadingToCenter;
- (void)dockBottomToCenter;
- (void)dockTrailingToCenter;

- (NSArray *)createDockAll;
- (NSArray *)createDockAllWithEdgeInsets: (UIEdgeInsets)insets;

- (void)dockAll;
- (void)dockAllWithEdgeInsets: (UIEdgeInsets)insets;

- (NSLayoutConstraint *)alignTopWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignLeadingWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignBottomWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignTrailingWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignCenterXWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignCenterYWithPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignWidthWithMultiplier: (CGFloat)multiplier;
- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute withMultiplier: (CGFloat)multiplier;

//To sibling (assuming both have common superview)
- (NSLayoutConstraint *)pinLeadingTo: (UIView *)viewToPin withPadding: (CGFloat)padding;
- (NSLayoutConstraint *)pinTopTo: (UIView *)viewToPin withPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignCenterXTo: (UIView *)viewToCenter;
- (NSLayoutConstraint *)alignCenterYTo: (UIView *)viewToCenter;
- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute to: (UIView *)viewToAlign withPadding: (CGFloat)padding;
- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute to: (UIView *)viewToAlign viewAttribute: (NSLayoutAttribute)viewAttribute withMultiplier: (CGFloat)multiplier;

//Self
- (NSLayoutConstraint *)constraintWidth: (CGFloat)width;
- (NSLayoutConstraint *)constraintHeight: (CGFloat)height;
- (NSLayoutConstraint *)constraintHeightWeak: (CGFloat)height;
- (NSLayoutConstraint *)constraintHeightRatio: (CGFloat)heightRatio;

//Get
- (NSLayoutConstraint *)leadingTrailingBetweenSubview1: (UIView *)subview1 andSubview2: (UIView *)subview2;
- (NSLayoutConstraint *)leadingForSubview: (UIView *)subview;
- (NSLayoutConstraint *)trailingForSubview: (UIView *)subview;
- (NSLayoutConstraint *)topForSubview: (UIView *)subview;
- (NSLayoutConstraint *)bottomForSubview: (UIView *)subview;
- (NSLayoutConstraint *)widthConstraint;
- (NSLayoutConstraint *)heightConstraint;

//Set (needs testing, might not always be stable)
- (NSLayoutConstraint *)setWidth: (CGFloat)width;
- (NSLayoutConstraint *)setHeight: (CGFloat)height;

@end
