//
//  UIView+Create.h
//  Close
//
//  Created by Alexander Naumenko on 11/29/12.
//  Copyright (c) 2012 Alexander Naumenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)

+ (UIView *)createFromNib;
+ (UIView *)createFromNib:(NSString *)nibName;

@end
