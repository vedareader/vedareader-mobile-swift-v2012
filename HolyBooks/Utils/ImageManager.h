//
//  ImageManager.h
//  RussianCuisine
//
//  Created by Roman Developer on 12/4/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kImagePath @"Images"

typedef void (^ImageLoadedCompletedBlock)(UIImage *image);

@interface ImageManager : NSObject

+ (UIImage *)getImageNamed: (NSString *)name;
+ (void)saveImage: (NSData *)data withName: (NSString *)name;
+ (void)downloadImage: (NSString *)url;
+ (void)removeImageWithName: (NSString *)name;
+ (BOOL)existImageWithName: (NSString *)name;

+ (UIImage *)preloadImage: (UIImage *)img;

+ (void)getAndCacheImageAsync: (NSString *)absoluteURL completedBlock: (ImageLoadedCompletedBlock)completedBlock;
+ (void)getImageAsync: (NSString *)absoluteURL completedBlock: (ImageLoadedCompletedBlock)completedBlock;
+ (void)getImageForPathAsync: (NSString *)imagePath completedBlock: (ImageLoadedCompletedBlock)completedBlock;

//Specifically for holly books
+ (void)getAndCacheImageAsync: (NSString *)absoluteURL imagePath: (NSString *)imagePath completedBlock: (ImageLoadedCompletedBlock)completedBlock;

@end
