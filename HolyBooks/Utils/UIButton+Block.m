//
//  UIButton+Block.m
//  BankFilter
//
//  Created by Vyacheslav Ksenofontov on 11/18/13
//  Copyright (c) 2013 IronWaterStudio. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+Block.h"

const int kButtonEventBlock = 0;

@implementation UIButton(Block)

- (void)addTarget:(id)target actionWithBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)controlEvents
{
	// Note: only one event supported!
	objc_setAssociatedObject( self, (void*)&kButtonEventBlock, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );
	
	[self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvents];
}

- (void)addActionBlock:(ActionBlock)actionBlock forControlEvents:(UIControlEvents)controlEvents
{
	[self addTarget:nil actionWithBlock:actionBlock forControlEvents:controlEvents];
}

- (void)callActionBlock:(id)sender
{	
	ActionBlock actionBlock = (ActionBlock)objc_getAssociatedObject( self, (void*)&kButtonEventBlock );
	actionBlock();
}

@end
