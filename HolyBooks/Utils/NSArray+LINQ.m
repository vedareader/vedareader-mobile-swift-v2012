//
//  NSArray+LINQ.m
//  CoreAnimationStudy
//
//  Created by Roman Developer on 3/5/14.
//
//

#import "NSArray+LINQ.h"

@implementation NSArray (LINQ)

- (NSArray *)where: (NSString *)predicateCondition, ...
{
	va_list args;
	va_start(args, predicateCondition);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition arguments:args];
	va_end(args);
	
	return [self filteredArrayUsingPredicate:predicate];
}

- (NSObject *)firstOrDefault: (NSString *)predicateCondition, ...
{
	va_list args;
	va_start(args, predicateCondition);
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition arguments:args];
	NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
	va_end(args);
	if (filteredArray.count > 0)
		return filteredArray[0];
	else
		return nil;
}

- (BOOL)contains: (NSString *)predicateCondition, ...
{
	va_list args;
	va_start(args, predicateCondition);
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition arguments:args];
	va_end(args);
	return ([[self filteredArrayUsingPredicate:predicate] count] > 0);
}

- (NSArray *)select: (NSString *)keyPath
{
	return [self valueForKeyPath:keyPath];
}

- (void)update: (NSString *)keyPath value: (id)value
{
	[self setValue:value forKeyPath:keyPath];
}

@end
