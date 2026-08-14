//
//  UIViewController+CustomDraw.m
//  BankFilter
//
//  Created by Vyacheslav Ksenofontov on 11/18/13
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import "UIViewController+CustomDraw.h"
#import "UIButton+Block.h"

@implementation UIViewController(CustomDraw)

#pragma mark - UIButton
- (UIButton*)buttonWithImage:(NSString *)imageName withPressed:(BOOL)hasPressedImage action:(SEL)selector
{
	UIImage* image = [UIImage imageNamed:[imageName stringByAppendingString:@".png"]];
	UIButton *button = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)] autorelease];
	
	[button setImage:image forState:UIControlStateNormal];
	if (hasPressedImage)
	{
		UIImage* imagePressed = [UIImage imageNamed:[imageName stringByAppendingString:@"_pressed.png"]];
		[button setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
	}
	
	[button addTarget:self action:selector forControlEvents: UIControlEventTouchUpInside];

	return button;
}

#pragma mark - UIBarButtonItem
- (UIBarButtonItem*)barButtonWithImage:(NSString *)imageName action:(SEL)selector
{
	UIImage* image = [UIImage imageNamed:[imageName stringByAppendingString:@".png"]];
	UIImage* imagePressed = [UIImage imageNamed:[imageName stringByAppendingString:@"_pressed.png"]];
	
	UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	if (!IS_IOS7)
		button.imageEdgeInsets = UIEdgeInsetsZero;

	[button setImage:image forState:UIControlStateNormal];
	[button setImage:image forState:UIControlStateDisabled];
	[button setImage:imagePressed forState:UIControlStateSelected];
	[button setImage:imagePressed forState:UIControlStateHighlighted];
	
	[button addTarget:self action:selector forControlEvents: UIControlEventTouchUpInside];
	return [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease];
}

- (UIBarButtonItem*)barButtonWithImage:(NSString *)imageName actionBlock:(ActionBlock)actionBlock
{
	UIImage* image = [UIImage imageNamed:[imageName stringByAppendingString:@".png"]];
	UIImage* imagePressed = [UIImage imageNamed:[imageName stringByAppendingString:@"_pressed.png"]];
	
	UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
	button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	if (!IS_IOS7)
		button.imageEdgeInsets = UIEdgeInsetsZero;

	[button setImage:image forState:UIControlStateNormal];
	[button setImage:image forState:UIControlStateDisabled];	
	[button setImage:imagePressed forState:UIControlStateSelected];
	[button setImage:imagePressed forState:UIControlStateHighlighted];
	
	[button addTarget:self actionWithBlock:actionBlock forControlEvents:UIControlEventTouchUpInside];
	return [[[UIBarButtonItem alloc] initWithCustomView: button] autorelease];
}

#pragma mark - Shortcuts
- (void)setNavigationBackButton
{
	[self setNavigationBackButtonWithPopToRoot:NO];
}

- (void)setNavigationBackButtonWithPopToRoot:(BOOL)popToRoot
{
	[self setNavigationBackButtonWithPopToRoot:popToRoot withSelector:nil];
}

/**
 * Set sletat back button with ability to back to root view controller or on prev. view controller in history.
 */
- (void)setNavigationBackButtonWithPopToRoot:(BOOL)popToRoot withSelector:(SEL)selClick
{
    __block UIViewController *_self = self;
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"navbar_button_back"
														 actionBlock:^{
															 if (selClick && [self respondsToSelector:selClick])
																 [self performSelector:selClick];
															 if (popToRoot)
																 [_self.navigationController popToRootViewControllerAnimated:YES];
															 else
																 [_self.navigationController popViewControllerAnimated:YES];
//															 [_self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_bg"] forBarMetrics:UIBarMetricsDefault];
//															 [_self.navigationController.navigationBar setShadowImage:[[[UIImage alloc] init] autorelease]];
														 }];
	if (self.navigationItem.leftBarButtonItem.customView && [self.navigationItem.leftBarButtonItem.customView isKindOfClass:[UIButton class]])
	{
		UIButton *btn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
		if (!IS_IOS7)
		{
			btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
			btn.frame = CGRectMake(0, 0, btn.frame.size.width + 5, btn.frame.size.height);
		}
	}
	
	// ??? SWIPE BACK BUTTON ???
	// Allow return behaviour to the cases when not menu back navigaiont i.e. popToRoot = NO
	if (!popToRoot && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
		self.navigationController.interactivePopGestureRecognizer.delegate = nil;//(id<UIGestureRecognizerDelegate>)self;
}

- (void)setNavigationForwardButtonWithActionBlock:(ActionBlock)actionBlock
{
	self.navigationItem.rightBarButtonItem = [self barButtonWithImage:@"navbar_icon_next"
														  actionBlock:actionBlock];
	
}

- (void)setNavigationMenuButtonWithSelector:(SEL)selClick
{
 	UIBarButtonItem *buttonItem = [self barButtonWithImage:@"navbar_icon_menu"
													action:selClick];
	if (IS_IOS7)
	{
		UIBarButtonItem *spaceFix = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
		spaceFix.width = -6;
		self.navigationItem.leftBarButtonItems = @[spaceFix, buttonItem];
	}
	else
	{
		UIBarButtonItem *spaceFix = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL] autorelease];
		spaceFix.width = 5;
		buttonItem.customView.frame = CGRectSetY(buttonItem.customView.frame, 20);
		self.navigationItem.leftBarButtonItems = @[spaceFix, buttonItem];
	}
}

- (void)fixDesign
{
	if (IS_IOS7)
	{
		self.automaticallyAdjustsScrollViewInsets = NO; // Avoid the top UITextView space, iOS7 (~bug?)
		self.edgesForExtendedLayout = UIRectEdgeNone;
		//self.navigationController.navigationBar.translucent = NO;
		self.view.bounds = CGRectMake(self.view.bounds.origin.x, -self.topLayoutGuide.length, self.view.bounds.size.width, self.view.bounds.size.height);
	}
}

- (void)clearSearchBar:(UISearchBar *)searchBar withBackgroundImage:(NSString *)imageName
{
	if (searchBar)
	{
		for (UIView *searchBarSubview in searchBar.subviews)
		{
			if ([searchBarSubview respondsToSelector:@selector(setBorderStyle:)])
			{
				[(UITextField *)searchBarSubview setBorderStyle:UITextBorderStyleRoundedRect];
				((UITextField *)searchBarSubview).background = nil;
				searchBarSubview.backgroundColor = [UIColor whiteColor];
				CALayer *layer = searchBarSubview.layer;
				layer.borderWidth = 0.0f;
				layer.borderColor = [UIColor grayColor].CGColor;
				//layer.borderColor = [UIColor grayColor].CGColor;
				layer.cornerRadius = 1.0f;
			}
		}
	}
	if (imageName)
		searchBar.backgroundImage = [UIImage imageNamed:imageName];
}

@end
