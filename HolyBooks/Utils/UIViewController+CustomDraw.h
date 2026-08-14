//
//  UIViewController+CustomDraw.h
//  BankFilter
//
//  Created by Vyacheslav Ksenofontov on 11/18/13
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIButton+Block.h"

@interface UIViewController(CustomDraw)

#pragma mark - UIButton
- (UIButton*) buttonWithImage:(NSString *)imageName withPressed:(BOOL)hasPressedImage action:(SEL)selector;

#pragma mark - UIBarButtonItem
- (UIBarButtonItem*)barButtonWithImage:(NSString *)imageName action:(SEL)selector;
- (UIBarButtonItem*)barButtonWithImage:(NSString *)imageName actionBlock:(ActionBlock)actionBlock;
- (void)setNavigationBackButton;
- (void)setNavigationBackButtonWithPopToRoot:(BOOL)popToRoot;
- (void)setNavigationBackButtonWithPopToRoot:(BOOL)popToRoot withSelector:(SEL)selClick;
- (void)setNavigationForwardButtonWithActionBlock:(ActionBlock)actionBlock;
- (void)setNavigationMenuButtonWithSelector:(SEL)selClick;
- (void)fixDesign;
- (void)clearSearchBar:(UISearchBar *)searchBar withBackgroundImage:(NSString *)imageName;

@end
