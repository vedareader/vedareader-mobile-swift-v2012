//
//  NSArray+LINQ.h
//  CoreAnimationStudy
//
//  Created by Roman Developer on 3/5/14.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (LINQ)

- (NSArray *)where: (NSString *)predicateCondition, ...;
- (NSObject *)firstOrDefault: (NSString *)predicateCondition, ...;
- (BOOL)contains: (NSString *)predicateCondition, ...;
- (NSArray *)select: (NSString *)keyPath;
- (void)update: (NSString *)keyPath value: (id)value;

@end
