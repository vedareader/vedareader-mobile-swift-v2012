//
//  ImageManager.m
//  RussianCuisine
//
//  Created by Roman Developer on 12/4/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import "ImageManager.h"
#import "AppHelper.h"

@implementation ImageManager

+ (NSString *)filePathByName: (NSString *)name
{
	NSString *imagesDirectory = [[AppHelper applicationDocumentsDirectory] stringByAppendingPathComponent:kImagePath];
	NSString *filePath = [imagesDirectory stringByAppendingPathComponent:[name lastPathComponent]];
	
	return filePath;
}

+ (UIImage *)getImageNamed: (NSString *)name
{
	return [UIImage imageWithData:[NSData dataWithContentsOfFile:[ImageManager filePathByName:name]]];
}

+ (void)saveImage: (NSData *)data withName: (NSString *)name
{
	NSString *imagesDirectory = [[AppHelper applicationDocumentsDirectory] stringByAppendingPathComponent:kImagePath];
	if (![[NSFileManager defaultManager] fileExistsAtPath:imagesDirectory])
		[[NSFileManager defaultManager] createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	
	[data writeToFile:[ImageManager filePathByName:name] atomically:YES];
	
	//Do not backup
	[AppHelper setDoNotBackupAttr:[ImageManager filePathByName:name]];
}

+ (void)downloadImage: (NSString *)url
{
	NSURL *imageURL = [NSURL URLWithString:url];
	NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

	[self saveImage:imageData withName:[url lastPathComponent]];
}

+ (void)removeImageWithName: (NSString *)name
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:[ImageManager filePathByName:name]])
		[[NSFileManager defaultManager] removeItemAtPath:[ImageManager filePathByName:name] error:nil];
}

+ (BOOL)existImageWithName: (NSString *)name
{	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[ImageManager filePathByName:name]])
		return YES;
	else
		return NO;
}

+ (UIImage *)preloadImage: (UIImage *)img
{
	//Avoiding lazy load
	CGSize imageSize = img.size;
	UIGraphicsBeginImageContext(imageSize);
	[img drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

+ (void)getAndCacheImageAsync: (NSString *)absoluteURL completedBlock: (ImageLoadedCompletedBlock)completedBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		UIImage *img = nil;
		if ([ImageManager existImageWithName:absoluteURL])
		{
			img = [ImageManager getImageNamed:absoluteURL];
			img = [ImageManager preloadImage:img];
		}
		else
		{
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:absoluteURL]];
			[ImageManager saveImage:imageData withName:absoluteURL];
			img = [UIImage imageWithData:imageData];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completedBlock(img);
		});
	});
}

+ (void)getImageAsync: (NSString *)absoluteURL completedBlock: (ImageLoadedCompletedBlock)completedBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:absoluteURL]];
		[ImageManager saveImage:imageData withName:absoluteURL];
		UIImage *img = [UIImage imageWithData:imageData];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completedBlock(img);
		});
	});
}

+ (void)getImageForPathAsync: (NSString *)imagePath completedBlock: (ImageLoadedCompletedBlock)completedBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
		img = [ImageManager preloadImage:img];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completedBlock(img);
		});
	});
}

+ (void)getAndCacheImageAsync: (NSString *)absoluteURL imagePath: (NSString *)imagePath completedBlock: (ImageLoadedCompletedBlock)completedBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		UIImage *img = nil;
		if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
		{
			img = [UIImage imageWithContentsOfFile:imagePath];
			img = [ImageManager preloadImage:img];
		}
		else
		{
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:absoluteURL]];
			[imageData writeToFile:imagePath atomically:NO];
			img = [UIImage imageWithData:imageData];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			completedBlock(img);
		});
	});
}

@end
