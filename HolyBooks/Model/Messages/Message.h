//
//  Message.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 05/01/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

+ (nonnull NSString *)identifier;

+ (nullable instancetype)messageFromNotification:(nonnull NSNotification *)notification;

- (nonnull NSNotification *)notificationForObject:(nullable id)object;

@end
