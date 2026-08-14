//
//  HolyBanner.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyBanner.h"

@implementation HolyBanner

- (id)init
{
    return [self initWithIdentity:0 imageEn:nil imageRu:nil bookID:0 siteURL:nil];
}

- (id)initWithIdentity:(NSInteger)identity 
				imageEn:(NSString *)imageEn 
				imageRu:(NSString *)imageRu 
				bookID:(NSInteger)bookID 
				siteURL:(NSString *)siteURL
{
    if ((self = [super init]))
    {
		self.identity = identity;
		self.imageEn = imageEn;
		self.imageRu = imageRu;
		self.bookID = bookID;
		self.siteURL = siteURL;
	}
    return self;
}

- (void)dealloc
{
	[_imageEn release];
	[_imageRu release];
	[_siteURL release];
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Identity: %ld, ImageEn: %@, ImageRu: %@, BookID: %ld, SiteURL: %@",
			(long)_identity, 
			_imageEn, 
			_imageRu, 
			(long)_bookID, 
			_siteURL
			];
}

#pragma mark - Functionality
+ (HolyBanner *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
    //Create HolyBanner object
    HolyBanner *item = [[HolyBanner alloc] initWithIdentity:[[jsonData objectForKey:@"id"] integerValue] 
													imageEn:[jsonData objectForKey:@"imageEn"] 
													imageRu:[jsonData objectForKey:@"imageRu"] 
													 bookID:[[jsonData objectForKey:@"bookID"] integerValue] 
													siteURL:[jsonData objectForKey:@"siteURL"]
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