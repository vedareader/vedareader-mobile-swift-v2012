//
//  GuideInfoList.h
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 12/22/2014.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kContentHost @"http://app.vedareader.com/"

// dev test
#ifndef kContentHost
#warning TEST SERVER!
#define kContentHost @"https://share.dev.ironwaterstudio.com/holybooks/"
#endif

#define kContentFileName @"data.json"

#define kContentSubdirectory @"content"
#define kBannersSubdirectory @"banners"
#define kBookImagesSubdirectory @"bookimages"
#define kBooksSubdirectory @"books"
#define kDownloadsSubdirectory @"downloads"
#define kAuthorsImagesSubdirectory @"authorimages"
#define kSetsImagesSubdirectory @"setsimages"

@interface HolyContentManager : NSObject

@property (nonatomic, retain) NSArray *languages;
@property (nonatomic, retain) NSArray *banners;
@property (nonatomic, retain) NSArray *recommendations;
@property (nonatomic, retain) NSArray *authors;
@property (nonatomic, retain) NSArray *books;
@property (nonatomic, retain) NSMutableDictionary *booksForAuthorId;
@property (nonatomic, retain) NSArray *sets;

+ (HolyContentManager *)sharedManager;
- (void)loadFromCache;
- (void)updateWithSuccess: (void (^)())successBlock
					error: (void (^)())errorBlock;

//Images
+ (NSString *)bookImageURLWithImageName: (NSString *)imageName;
+ (NSString *)bookImagePathWithURL: (NSString *)url;
+ (NSString *)bannerPathWithURL: (NSString *)url;
+ (NSString *)authorImageURLWithImageName:(NSString *)imageName;
+ (NSString *)authorImagePathWithURL:(NSString *)url;
+ (NSString *)setImageURLWithImageName:(NSString *)imageName;

//Working with books
+ (NSString *)epubURLWithFileName: (NSString *)fileName;
+ (NSString *)booksDirectory;
+ (NSString *)downloadsDirectory;
+ (NSString *)downloadFilePathForBook: (NSString *)bookName;
+ (NSString *)bookDirectoryForBook: (NSString *)bookName;
+ (NSInteger)booksAmountForAuthorId:(NSInteger)authorId;

//+ (void)unpackBookNamed: (NSString *)bookName completion: (void (^)())completion;

//+ (void)prepareBook: (NSString *)bookName;

@end
