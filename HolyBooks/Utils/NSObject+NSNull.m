//
//  NSObject+NSNull.m
//  Psycho
//
//  Created by RomanMac on 1/6/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import "NSObject+NSNull.h"

@implementation NSObject (NSNull)

- (id)nilIfNull
{
	if ([self class] == [NSNull class])
		return nil;
	else
		return self;
}

//Empty objects tests
+ (BOOL)isNullObject:(NSObject *)obj
{
	return obj == nil || [obj isKindOfClass:[NSNull class]];
}

+ (BOOL)isEmptyString:(NSObject *)string
{
	return [self isNullObject:string] || [(NSString *)string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

+ (NSObject *)nullIfNil:(NSObject *)obj
{
	return obj == nil ? [NSNull null] : obj;
}

+ (NSObject *)nullIfNilOrEmpty:(NSString *)str
{
	return str == nil || [self isEmptyString:str] ? [NSNull null] : str;
}


@end
