//
//  AppHelper.m
//  Quotes
//
//  Created by RomanMac on 2/2/13.
//  Copyright (c) 2013 Roman Developer. All rights reserved.
//

#import "AppHelper.h"
#include <sys/xattr.h>

@implementation AppHelper

+ (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)applicationCacheDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString *)databasePath
{
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kDatabaseName];
}

+ (NSString *)resourceDBPath
{
	return [[NSBundle mainBundle] pathForResource:kDatabaseName ofType:nil];
}

+ (void)initDB
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self databasePath]])
	{
		NSError *copyError = nil;
		[[NSFileManager defaultManager] copyItemAtPath:[self resourceDBPath] toPath:[self databasePath] error:&copyError];
		if (copyError == nil)
		{
			[self setDoNotBackupAttr:[self databasePath]];
			NSLog(@"Initialized DB");
		}
		else
			NSLog(@"Copy error %@, %@", copyError, [copyError userInfo]);
	}
	else
		NSLog(@"DB already there: %@ ", [self databasePath]);
}

+ (void)callPhone:(NSString *)phone
{
	if ([NSTextCheckingResult phoneNumberCheckingResultWithRange:NSMakeRange(0, phone.length) phoneNumber:phone].numberOfRanges > 0)
	{
		NSString *phoneUrlString = [NSString stringWithFormat:@"tel://%@", [phone stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
		
		NSURL *phoneUrl = [NSURL URLWithString:phoneUrlString];
		
		if ([[UIApplication sharedApplication] canOpenURL:phoneUrl])
			[[UIApplication sharedApplication] openURL:phoneUrl];
	}
}

+ (void)openURL:(NSString *)stringURL
{
	if (stringURL == nil)
	{
		return;
	}
	
	NSURL *url = [NSURL URLWithString:stringURL];
	if ([[UIApplication sharedApplication] canOpenURL:url])
	{
		[[UIApplication sharedApplication] openURL:url];
	}
}

+ (BOOL)setDoNotBackupAttr:(NSString *)filename
{
	const char* filePath = [(NSString *)([[NSURL URLWithString:filename] path]) fileSystemRepresentation];
	const char* attrName = "com.apple.MobileBackup";
	
	u_int8_t attrValue = 1;
	int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
	
	NSLog(@"result of setting up do not backup attribute for file %@ is %@", filename, ( result == 0 ? @"TRUE" : @"FALSE" ));
	return result == 0;
}

+ (NSString *)currentCulture
{
	NSString *locale = [NSLocale preferredLanguages][0];
	if ([locale isEqualToString:@"ru"])
		return @"ru";
	else
		return @"en";
}

@end
