//
//  HolyRecommendation.h
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HolyRecommendation : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, assign) NSInteger bookID;

- (id)initWithIdentity:(NSInteger)identity 
				bookID:(NSInteger)bookID;

+ (HolyRecommendation *)getFromDictionary:(NSDictionary *)jsonDictionary;
+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData;

@end