//
//  Message.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 05/01/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "Message.h"

#define kMessageDataKey @"data"

@implementation Message

+ (nonnull NSString *)identifier
{
	NSString *result = NSStringFromClass([self class]);
	return result;
}

+ (nullable instancetype)messageFromNotification:(nonnull NSNotification *)notification
{
	Message *result = [notification.userInfo objectForKey:kMessageDataKey];
	if (![result isKindOfClass:[self class]])
	{
		return nil;
	}
	
	return result;
}

- (nonnull NSNotification *)notificationForObject:(nullable id)object
{
	NSNotification *result = [NSNotification notificationWithName:[[self class] identifier]
														   object:object
														 userInfo:@{ kMessageDataKey : self }];
	
	return result;
}

@end
