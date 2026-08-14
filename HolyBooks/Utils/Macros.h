//
//  Macros.h
//  Psycho
//
//  Created by RomanMac on 12/15/12.
//  Copyright (c) 2012 ironwaterstudio. All rights reserved.
//

#ifndef Psycho_Macros_h
#define Psycho_Macros_h

#define CGRectChangeX(Rect, X) CGRectMake((Rect).origin.x + (X), (Rect).origin.y, (Rect).size.width, (Rect).size.height)
#define CGRectChangeY(Rect, Y) CGRectMake((Rect).origin.x, (Rect).origin.y + (Y), (Rect).size.width, (Rect).size.height)
#define CGRectChangeWidth(Rect, Width) CGRectMake((Rect).origin.x, (Rect).origin.y, (Rect).size.width + (Width), (Rect).size.height)
#define CGRectChangeHeight(Rect, Height) CGRectMake((Rect).origin.x, (Rect).origin.y, (Rect).size.width, (Rect).size.height + (Height))

#define CGRectSetX(Rect, X) CGRectMake((X), (Rect).origin.y, (Rect).size.width, (Rect).size.height)
#define CGRectSetY(Rect, Y) CGRectMake((Rect).origin.x, (Y), (Rect).size.width, (Rect).size.height)
#define CGRectSetWidth(Rect, Width) CGRectMake((Rect).origin.x, (Rect).origin.y, (Width), (Rect).size.height)
#define CGRectSetHeight(Rect, Height) CGRectMake((Rect).origin.x, (Rect).origin.y, (Rect).size.width, (Height))

#define CGSizeChangeWidth(Size, Width) CGSizeMake((Size).width + (Width), (Size).height)
#define CGSizeChangeHeight(Size, Height) CGSizeMake((Size).width, (Size).height + (Height))

#define CGSizeSetWidth(Size, Width) CGSizeMake((Width), (Size).height)
#define CGSizeSetHeight(Size, Height) CGSizeMake((Size).width, (Height))

#define NSLogRect(Rect) NSLog(@"X: %f, Y: %f, Width: %f, Height: %f", (Rect).origin.x, (Rect).origin.y, (Rect).size.width, (Rect).size.height);
#define NSLogPoint(Point) NSLog(@"X: %f, Y: %f", (Point).x, (Point).y);
#define NSLogSize(Size) NSLog(@"Width: %f, Height: %f", (Size).width, (Size).height);
#define NSLogRecursive(Object) NSLog(@"%@", [Object recursiveDescription]);
#define NSLogAutolayoutTrace(Object) NSLog(@"%@", [Object _autolayoutTrace]);
#define NSLogConstraints(Object) NSLog(@"%@", [Object constraints]);

#define DegToRad(Degrees) (Degrees) * 0.01745329f
#define RGB01(RGB255) (RGB255) / 255.0f
#define RGB(R, G, B) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:1.0]
#define RGBA(R, G, B, A) [UIColor colorWithRed:(R) / 255.0f green:(G) / 255.0f blue:(B) / 255.0f alpha:(A)]

#define DeviceUDID [[UIDevice currentDevice] uniqueIdentifier]

#define ScreenMaxLength (MAX(ScreenWidth, ScreenHeight))
#define ScreenMinLength (MIN(ScreenWidth, ScreenHeight))

#define IS_IPHONE_4 ([UIScreen mainScreen].bounds.size.height <= 480)
#define IS_IPHONE_5 (IS_IPHONE && ScreenMaxLength == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && ScreenMaxLength == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && ScreenMaxLength == 736.0)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//For IOS7 case
#define ScreenHeight ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? \
[[UIScreen mainScreen] bounds].size.height :\
( UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width ) )

//For IOS7 case
#define ScreenWidth ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? \
[[UIScreen mainScreen] bounds].size.width :\
( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width ) )

#define ScreenHeightLandscape ([[UIScreen mainScreen] bounds].size.width)
#define ScreenWidthLandscape ([[UIScreen mainScreen] bounds].size.height)

#define Local(String) NSLocalizedString((String), @"")

#define DOUBLE_IS_ZERO(x) ( fabs((double)(x)) < DBL_EPSILON )

#define APP_NAME [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#endif
