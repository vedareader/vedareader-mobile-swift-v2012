//
//  HolyFile.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HolyLanguage.h"

typedef enum
{
	HolyFileTypeText,
	HolyFileTypeTextAndAudio
} HolyFileType;

@interface HolyFile : NSObject

@property (nonatomic, assign) HolyFileType type;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger size;

- (id)initWithType:(HolyFileType)type
				name:(NSString *)name
			  size:(NSInteger)size;

+ (HolyFile *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

//Database
+ (HolyFile *)getByBookID: (NSInteger)bookID;	//TODO: Add type
+ (BOOL)existsWithBookID: (NSInteger)bookID;
+ (NSArray *)getAllByBookID: (NSInteger)bookID;
- (void)insertWithBookID: (NSInteger)bookID;
- (void)removeWithBookID: (NSInteger)bookID;
+ (void)removeAllWithBookID: (NSInteger)bookID;
+ (void)removeAll;

@end