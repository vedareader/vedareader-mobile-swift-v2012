//
//  GuideState.h
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 12/25/2014.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadInfo.h"
#import "HolyFile.h"

#define kPagePositionNotSelected 0.0

@interface BookState : NSObject

@property (nonatomic, assign) NSInteger identity;
@property (nonatomic, assign) BOOL isDownloaded;
@property (nonatomic, assign) BOOL shouldDownload;
@property (nonatomic, assign) BOOL isUnpacking;
@property (nonatomic, assign) HolyFileType fileType;
@property (nonatomic, retain) DownloadInfo *downloadInfo;

@property (nonatomic, assign) double pagePosition;

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) int fontSize;

- (id)initWithIdentity:(NSInteger)identity
		  downloadInfo:(DownloadInfo *)downloadInfo
		  isDownloaded:(BOOL)isDownloaded
		   isUnpacking:(BOOL)isUnpacking
			  fileType:(HolyFileType)fileType
		  pagePosition:(double)pagePosition
			  fontName:(NSString *)fontName
			  fontSize:(int)fontSize;

- (void)save;
- (void)clear;
+ (BookState *)getByID: (NSInteger)bookID;

@end