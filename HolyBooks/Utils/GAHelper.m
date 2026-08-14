//
//  GAHelper.m
//  Voice
//
//  Created by Roman Developer on 1/16/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "GAHelper.h"

@implementation GAHelper

+ (void)startTrackingWithId: (NSString *)trackingId
{
	[[GAI sharedInstance] trackerWithTrackingId:trackingId];
}

+ (void)logScreen: (NSString *)screenName
{
	id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	[tracker set:kGAIScreenName value:screenName];
	GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
	[tracker send:[builder build]];
}

+ (void)logEventWithCategory: (NSString *)category action: (NSString *)action
{
	[self logEventWithCategory:category action:action label:nil value:nil];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action value:(NSNumber *)value
{
	[self logEventWithCategory:category action:action label:nil value:value];
}

+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	
	[tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
														  action:action  // Event action (required)
														   label:label          // Event label
														   value:value] build]];    // Event value
}

@end
