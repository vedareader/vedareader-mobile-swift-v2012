//
//  HolyRecommendation.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyRecommendation.h"

@implementation HolyRecommendation

- (id)init
{
    return [self initWithIdentity:0 bookID:0];
}

- (id)initWithIdentity:(NSInteger)identity 
				bookID:(NSInteger)bookID
{
    if ((self = [super init]))
    {
		self.identity = identity;
		self.bookID = bookID;
	}
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Identity: %ld, BookID: %ld",
			(long)_identity, 
			(long)_bookID
			];
}

#pragma mark - Functionality
+ (HolyRecommendation *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
    //Create HolyRecommendation object
    HolyRecommendation *item = [[HolyRecommendation alloc] initWithIdentity:[[jsonData objectForKey:@"id"] integerValue] 
																	 bookID:[[jsonData objectForKey:@"bookID"] integerValue]
								];
    return [item autorelease];
}

+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonDataItem in jsonData)
    {
        NSObject *item = [self getFromDictionary:jsonDataItem];
        if (item)
            [items addObject:item];
    }
    return [items autorelease];
}

@end