//
//  HolySet.h
//  HolyBooks
//
//  Created by Alexander Popov on 23/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolySet : NSObject

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

+ (HolySet *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

//Database
+ (NSArray *)getAll;
+ (HolySet *)getByID: (NSInteger)identity;
+ (BOOL)existsWithID: (NSInteger)identity;
- (void)insert;
- (NSInteger)getBooksCount;

@end
