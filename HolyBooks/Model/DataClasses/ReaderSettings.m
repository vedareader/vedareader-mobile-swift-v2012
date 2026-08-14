//
//  ReaderSettings.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 17/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "ReaderSettings.h"

@implementation ReaderSettings

- (instancetype)initWithTransitionName:(NSString *)transitionName fontName:(NSString *)fontName
{
	if (self = [super init])
	{
		self.transitionName = transitionName;
		self.fontName = fontName;
	}
	
	return self;
}

+ (instancetype)createDefaultSettings
{
	return [[self alloc] initWithTransitionName:Local(@"BookReader.TransitionStyle.Flipping") fontName:@"Georgia"];
}

- (void)dealloc
{
	[_fontName release];
	[_transitionName release];
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"FontName: %@, TransitionName: %@",
			_fontName,
			_transitionName
			];
}

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		self.transitionName = [aDecoder decodeObjectForKey:@"transitionName"];
		self.fontName = [aDecoder decodeObjectForKey:@"fontName"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.transitionName forKey:@"transitionName"];
	[aCoder encodeObject:self.fontName forKey:@"fontName"];
}

#pragma mark - Helper methods
- (int)getTransitionType
{
	if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"PageTransitionType"]  isEqual: @""])
	{
		NSString *defaultTransitionType = @"1";
		[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		return 1;
	}
	else
	{
		return [[[NSUserDefaults standardUserDefaults] stringForKey:@"PageTransitionType"] integerValue];
	}
	
	
	/*if ([self.transitionName isEqualToString:Local(@"BookReader.TransitionStyle.Flipping")])
		return 2;
	else
		return 1;*/
}

@end
