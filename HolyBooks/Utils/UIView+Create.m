//
//  UIView+Create.m
//  Close
//
//  Created by Alexander Naumenko on 11/29/12.
//  Copyright (c) 2012 Alexander Naumenko. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)

+ (UIView *)createFromNib:(NSString *)nibName
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id obj in arr)
        if ([obj isKindOfClass:self])
            return obj;
    return nil;
}

+ (UIView *)createFromNib
{
    return [self createFromNib:NSStringFromClass(self)];
}

@end
