//
//  UIView+Autolayout.m
//  TestProject
//
//  Created by RomanMac on 22/01/15.
//  Copyright (c) 2015 ironwaterstudio. All rights reserved.
//

#import "UIView+Autolayout.h"

@implementation UIView (Autolayout)

#pragma mark - Children
- (void)centerXSubviews
{
	for (UIView *view in self.subviews)
	{
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
															toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	}
}

- (void)centerYSubviews
{
	for (UIView *view in self.subviews)
	{
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
															toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
	}
}

#pragma mark - To parent
- (void)dockTop
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}

- (void)dockLeading
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)dockBottom
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
															 toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
															 toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
															 toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)dockTrailing
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)dockTopToCenter
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)dockLeadingToCenter
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)dockBottomToCenter
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)dockTrailingToCenter
{
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
	[self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (NSArray *)createDockAll
{
	return @[
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0]
			 ];
}

- (NSArray *)createDockAllWithEdgeInsets: (UIEdgeInsets)insets
{
	return @[
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1 constant:insets.left],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1 constant:-insets.right],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top],
			 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
											 toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-insets.bottom]
			 ];
}

- (void)dockAll
{
	[NSLayoutConstraint activateConstraints:[self createDockAll]];
}

- (void)dockAllWithEdgeInsets: (UIEdgeInsets)insets
{
	[NSLayoutConstraint activateConstraints:[self createDockAllWithEdgeInsets:insets]];
}

- (NSLayoutConstraint *)alignTopWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeTop multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignLeadingWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeLeading multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignBottomWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeBottom multiplier:1 constant:-padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignTrailingWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeTrailing multiplier:1 constant:-padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignCenterXWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeCenterX multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignCenterYWithPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeCenterY multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignWidthWithMultiplier: (CGFloat)multiplier
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:NSLayoutAttributeWidth multiplier:multiplier constant:0];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute withMultiplier: (CGFloat)multiplier
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual
																  toItem:self.superview	attribute:attribute multiplier:multiplier constant:0];
	constraint.active = YES;
	return constraint;
}

#pragma mark - To sibling
- (NSLayoutConstraint *)pinLeadingTo: (UIView *)viewToPin withPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
																  toItem:viewToPin attribute:NSLayoutAttributeTrailing multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)pinTopTo: (UIView *)viewToPin withPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
																  toItem:viewToPin attribute:NSLayoutAttributeBottom multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignCenterXTo: (UIView *)viewToCenter
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
																  toItem:viewToCenter attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
	[self.superview addConstraint:constraint];
	return constraint;
}

- (NSLayoutConstraint *)alignCenterYTo: (UIView *)viewToCenter
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
																  toItem:viewToCenter attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute to: (UIView *)viewToAlign withPadding: (CGFloat)padding
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual
																  toItem:viewToAlign attribute:attribute multiplier:1 constant:padding];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)alignAttribute: (NSLayoutAttribute)attribute to: (UIView *)viewToAlign viewAttribute: (NSLayoutAttribute)viewAttribute withMultiplier: (CGFloat)multiplier
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual
																  toItem:viewToAlign attribute:viewAttribute multiplier:multiplier constant:0];
	constraint.active = YES;
	return constraint;
}

#pragma mark - Self
- (NSLayoutConstraint *)constraintWidth: (CGFloat)width
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
																  toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:width];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)constraintHeight: (CGFloat)height
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
																  toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:height];
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)constraintHeightWeak: (CGFloat)height
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
																  toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:height];
	constraint.priority = 999;
	
	constraint.active = YES;
	return constraint;
}

- (NSLayoutConstraint *)constraintHeightRatio: (CGFloat)heightRatio
{
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
																  attribute:NSLayoutAttributeWidth
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self
																  attribute:NSLayoutAttributeHeight
																 multiplier:heightRatio
																   constant:0];
	constraint.active = YES;

	return constraint;
}

#pragma mark - Get
- (NSLayoutConstraint *)leadingTrailingBetweenSubview1: (UIView *)subview1 andSubview2: (UIView *)subview2
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		if ((constraint.firstItem == subview1 && constraint.secondItem == subview2) ||
			(constraint.secondItem == subview1 && constraint.firstItem == subview2))
			if ((constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondAttribute == NSLayoutAttributeTrailing) ||
				(constraint.secondAttribute == NSLayoutAttributeLeading && constraint.firstAttribute == NSLayoutAttributeTrailing))
				return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)leadingForSubview: (UIView *)subview
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		if ((constraint.firstItem == subview && constraint.firstAttribute == NSLayoutAttributeLeading && constraint.secondItem == self) ||
			(constraint.secondItem == subview && constraint.secondAttribute == NSLayoutAttributeLeading && constraint.firstItem == self))
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)trailingForSubview: (UIView *)subview
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		if ((constraint.firstItem == subview && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondItem == self) ||
			(constraint.secondItem == subview && constraint.secondAttribute == NSLayoutAttributeTrailing && constraint.firstItem == self))
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)topForSubview: (UIView *)subview
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		if ((constraint.firstItem == subview && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondItem == self) ||
			(constraint.secondItem == subview && constraint.secondAttribute == NSLayoutAttributeTop && constraint.firstItem == self))
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)bottomForSubview: (UIView *)subview
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		if ((constraint.firstItem == subview && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondItem == self) ||
			(constraint.secondItem == subview && constraint.secondAttribute == NSLayoutAttributeBottom && constraint.firstItem == self))
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)widthConstraint
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		//Skip intrinsic content size auto constraints
		if ([constraint isKindOfClass:NSClassFromString(@"NSContentSizeLayoutConstraint")])
			continue;
		
		if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeWidth)
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)heightConstraint
{
	for (NSLayoutConstraint *constraint in self.constraints)
	{
		//Skip intrinsic content size auto constraints
		if ([constraint isKindOfClass:NSClassFromString(@"NSContentSizeLayoutConstraint")])
			continue;
		
		if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight)
			return constraint;
	}
	
	return nil;
}

- (NSLayoutConstraint *)setWidth: (CGFloat)width
{
	NSLayoutConstraint *widthConstraint = [self widthConstraint];
	if (widthConstraint != nil)
	{
		widthConstraint.constant = width;
		return widthConstraint;
	}
	else
		return [self constraintWidth:width];
}

- (NSLayoutConstraint *)setHeight: (CGFloat)height
{
	NSLayoutConstraint *heightConstraint = [self heightConstraint];
	if (heightConstraint != nil)
	{
		heightConstraint.constant = height;
		return heightConstraint;
	}
	else
		return [self constraintHeight:height];
}

@end
