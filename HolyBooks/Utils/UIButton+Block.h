//
//  UIButton+Block.h
//  BankFilter
//
//  Created by Vyacheslav Ksenofontov on 11/18/13
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionBlock)();

@interface UIButton(Block)

// Note: only one event supported!
- (void)addTarget:(id)target actionWithBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)controlEvents;
- (void)addActionBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)controlEvents;

@end
