//
//  UIImageView+Background.m
//  HolyBooks
//
//  Created by Roman Developer on 11/2/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "UIImage+Background.h"

@implementation UIImage (Background)

+ (UIImage *)backgroundImage
{
	if (IS_IPHONE_4)
		return [UIImage imageNamed:@"books_background.png"];
	else if (IS_IPHONE_5)
		return [UIImage imageNamed:@"books_background-568h.png"];
	else if (IS_IPHONE_6)
		return [UIImage imageNamed:@"books_background-667h.png"];
	else if (IS_IPHONE_6P)
		return [UIImage imageNamed:@"books_background-736h.png"];
	else
		return [UIImage imageNamed:@"books_background.png"];
}

+ (UIImage *)menuBackgroundImage
{
	if (IS_IPHONE_4)
		return [UIImage imageNamed:@"menu_background.png"];
	else if (IS_IPHONE_5)
		return [UIImage imageNamed:@"menu_background-568h.png"];
	else if (IS_IPHONE_6)
		return [UIImage imageNamed:@"menu_background-667h.png"];
	else if (IS_IPHONE_6P)
		return [UIImage imageNamed:@"menu_background-736h.png"];
	else
		return [UIImage imageNamed:@"menu_background.png"];
}

@end
