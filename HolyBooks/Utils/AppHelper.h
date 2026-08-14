//
//  AppHelper.h
//  Quotes
//
//  Created by RomanMac on 2/2/13.
//  Copyright (c) 2013 Roman Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDatabaseName @"holybooks.sqlite"

@interface AppHelper : NSObject

+ (NSString *)applicationDocumentsDirectory;
+ (NSString *)applicationCacheDirectory;
+ (NSString *)databasePath;
+ (NSString *)resourceDBPath;

+ (void)initDB;

+ (void)callPhone:(NSString *)phone;
+ (void)openURL:(NSString *)stringURL;
+ (BOOL)setDoNotBackupAttr:(NSString *)filename;

+ (NSString *)currentCulture;

@end
