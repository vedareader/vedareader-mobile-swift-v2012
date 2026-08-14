//
//  HolyAuthor.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolyAuthor : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, assign) NSInteger languageID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *desc;

- (id)initWithIdentity:(NSInteger)identity
			languageID:(NSInteger)languageID
				  name:(NSString *)name
				 image:(NSString *)image
				  desc:(NSString *)desc;

+ (HolyAuthor *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

//Database
+ (NSArray *)getAll;
+ (HolyAuthor *)getByID: (NSInteger)identity;
+ (BOOL)existsWithID: (NSInteger)identity;
- (void)insert;

@end
