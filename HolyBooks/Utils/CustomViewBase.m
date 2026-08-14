//
//  CustomViewBase.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/10/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import "CustomViewBase.h"

#import "UIView+Autolayout.h"

@implementation CustomViewBase

+ (instancetype)create
{
	CustomViewBase *result = [[[self alloc] init] autorelease];
	
	return result;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self innerInit];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self innerInit];
	}
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self innerInit];
	}
	
	return self;
}

- (void)innerInit
{
	if (_contentView != nil)
	{
		return;
	}
	
	[self loadFromXIB];
	
	[self postInit];
}

- (void)dealloc
{
	[_contentView release];
	
	[super dealloc];
}

- (void)postInit
{
}

#pragma mark - private helpers
- (void)loadFromXIB
{
	NSString *nibName = NSStringFromClass([self class]);
	_contentView = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
	[_contentView retain];
	_contentView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[self addSubview:_contentView];

	[_contentView dockAll];
}

@end
