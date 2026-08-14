//
//  NSObject+NSNull.h
//  Psycho
//
//  Created by RomanMac on 1/6/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSNull)

- (id)nilIfNull;

+ (BOOL)isNullObject:(NSObject *)obj;
+ (BOOL)isEmptyString:(NSObject *)string;
+ (NSObject *)nullIfNil:(NSObject *)obj;
+ (NSObject *)nullIfNilOrEmpty:(NSString *)str;

@end
