//
//  Localization.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 16/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "Localization.h"

@implementation Localization

+ (NSString *)textForKey:(NSString *)key number:(NSInteger)number
{
	NSString *localizationKey = nil;

	NSString * const keyFormat = @"%@.%@";
	NSInteger const lastDigit = number % 10;
	if (lastDigit == 1 && (number < 10 || number > 20))
	{
		localizationKey = [NSString stringWithFormat:keyFormat, key, @"1"];
	}
	if (2 <= lastDigit && lastDigit <= 4 && (number < 10 || number > 20))
	{
		localizationKey = [NSString stringWithFormat:keyFormat, key, @"2-4"];
	}
	else
	{
		localizationKey = [NSString stringWithFormat:keyFormat, key, @"Many"];
	}
	
	return Local(localizationKey);
}

@end
