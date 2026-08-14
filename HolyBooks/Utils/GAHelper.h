//
//  GAHelper.h
//  Voice
//
//  Created by Roman Developer on 1/16/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

@interface GAHelper : NSObject

+ (void)startTrackingWithId: (NSString *)trackingId;
+ (void)logScreen: (NSString *)screenName;
+ (void)logEventWithCategory: (NSString *)category action: (NSString *)action;
+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action value:(NSNumber *)value;
+ (void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

@end
