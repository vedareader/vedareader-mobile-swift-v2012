//
//  HolyBanner.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolyBanner : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, retain) NSString *imageEn;
@property (nonatomic, retain) NSString *imageRu;
@property (nonatomic, assign) NSInteger bookID;
@property (nonatomic, retain) NSString *siteURL;

- (id)initWithIdentity:(NSInteger)identity 
				imageEn:(NSString *)imageEn 
				imageRu:(NSString *)imageRu 
				bookID:(NSInteger)bookID 
				siteURL:(NSString *)siteURL;

+ (HolyBanner *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

@end