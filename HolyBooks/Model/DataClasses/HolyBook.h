//
//  HolyBook.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolyBook : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, assign) NSInteger languageID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger authorID;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, assign) NSInteger package;
@property (nonatomic, assign) NSInteger packageOrder;
@property (nonatomic, retain) NSArray *files;
@property (nonatomic, assign) double position;

- (id)initWithIdentity:(NSInteger)identity
			languageID:(NSInteger)languageID
				  name:(NSString *)name
			  authorID:(NSInteger)authorID
				 image:(NSString *)image
				  desc:(NSString *)desc
				   set:(NSInteger)setID
			  setOrder:(NSInteger)setOrder
				 files:(NSArray *)files
			  position:(double)position;

+ (HolyBook *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

//Database
+ (NSArray *)getAll;
+ (NSArray *)getByPackageID: (NSInteger)identity;
+ (HolyBook *)getByID: (NSInteger)identity;
+ (BOOL)existsWithID: (NSInteger)identity;
+ (NSInteger)booksQuantityWithAuthorID:(NSInteger)authorID;
+ (NSInteger)booksQuantityWithSetID:(NSInteger)setID;
- (void)update;
- (void)insert;
- (void)remove;
+ (void)removeAll;

@end
