//
//  HolyLanguage.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolyLanguage : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, retain) NSString *name;

- (id)initWithIdentity:(NSInteger)identity
				name:(NSString *)name;

+ (HolyLanguage *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

//Database
+ (NSArray *)getAll;
+ (HolyLanguage *)getByID: (NSInteger)identity;
+ (BOOL)existsWithID: (NSInteger)identity;
- (void)insert;

@end