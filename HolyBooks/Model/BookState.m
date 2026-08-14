//
//  GuideState.m
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 12/25/2014.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import "BookState.h"
#import "NSArray+LINQ.h"

#define kBookStateKey @"BookState"
#define kBookStateIDsKey @"BookStateIDs"

#define kVersion_1 1
#define kVersion_2 2
#define kVersion 3

@implementation BookState

- (id)init
{
	return [self initWithIdentity:0 downloadInfo:nil isDownloaded:NO isUnpacking:NO fileType:HolyFileTypeText pagePosition:kPagePositionNotSelected
			fontName:nil fontSize:0];
}

- (id)initWithIdentity:(NSInteger)identity
		  downloadInfo:(DownloadInfo *)downloadInfo
		  isDownloaded:(BOOL)isDownloaded
		   isUnpacking:(BOOL)isUnpacking
			  fileType:(HolyFileType)fileType
		  pagePosition:(double)pagePosition
			  fontName:(NSString *)fontName
			  fontSize:(int)fontSize
{
	if ((self = [super init]))
	{
		self.identity = identity;
		self.downloadInfo = downloadInfo;
		self.isDownloaded = isDownloaded;
		self.isUnpacking = isUnpacking;
		self.fileType = fileType;
		self.pagePosition = pagePosition;
		self.fontName = fontName;
		self.fontSize = fontSize;
	}
	
	return self;
}

- (void)dealloc
{
	[_downloadInfo release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"ID: %ld, DownloadInfo: %@, IsDownloaded: %@, IsUnpacking: %@, ShouldDownload: %@, FileType: %ld, PagePosition: %f",
			(long)_identity,
			_downloadInfo,
			_isDownloaded ? @"YES" : @"NO",
			_isUnpacking ? @"YES" : @"NO",
			_shouldDownload ? @"YES" : @"NO",
			(long)_fileType,
			_pagePosition
			];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self == nil)
	{
		return nil;
	}

	NSInteger version = kVersion_1;
	if ([aDecoder containsValueForKey:@"version"])
	{
		version = [aDecoder decodeIntegerForKey:@"version"];
	}
	
	self.identity = [aDecoder decodeIntegerForKey:@"identity"];
	self.downloadInfo = [aDecoder decodeObjectForKey:@"downloadInfo"];
	self.isDownloaded = [aDecoder decodeBoolForKey:@"isDownloaded"];
	self.isUnpacking = [aDecoder decodeBoolForKey:@"isUnpacking"];
	self.shouldDownload = [aDecoder decodeBoolForKey:@"shouldDownload"];
	self.fileType = (HolyFileType)[aDecoder decodeIntegerForKey:@"fileType"];
	
	if (version >= kVersion_1)
	{
		self.pagePosition = [aDecoder decodeDoubleForKey:@"pagePosition"];
	}
	
	if (version >= kVersion_2)
	{
		self.fontName = [aDecoder decodeObjectForKey:@"fontName"];
		self.fontSize = (int)[aDecoder decodeIntegerForKey:@"fontSize"];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInteger:kVersion forKey:@"version"];
	[aCoder encodeInteger:self.identity forKey:@"identity"];
	[aCoder encodeObject:self.downloadInfo forKey:@"downloadInfo"];
	[aCoder encodeBool:self.isDownloaded forKey:@"isDownloaded"];
	[aCoder encodeBool:self.isUnpacking forKey:@"isUnpacking"];
	[aCoder encodeBool:self.shouldDownload forKey:@"shouldDownload"];
	[aCoder encodeInteger:self.fileType forKey:@"fileType"];
	[aCoder encodeDouble:self.pagePosition forKey:@"pagePosition"];
	
	if (self.fontName != nil)
	{
		[aCoder encodeObject:self.fontName forKey:@"fontName"];
		[aCoder encodeInteger:self.fontSize forKey:@"fontSize"];
	}
}


#pragma mark - Functionality
- (void)save
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	//Book state
	[userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:[NSString stringWithFormat:@"%@-%ld", kBookStateKey, (long)self.identity]];
	[userDefaults synchronize];
}

- (void)clear
{
	self.downloadInfo = nil;
	self.isDownloaded = NO;
	[self save];
}

+ (BookState *)getByID: (NSInteger)bookID
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *bookData = [userDefaults objectForKey:[NSString stringWithFormat:@"%@-%ld", kBookStateKey, (long)bookID]];
	BookState *bookState = (bookData == nil) ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:bookData];
	if (bookState == nil)
	{
		bookState = [[[BookState alloc] initWithIdentity:bookID downloadInfo:nil isDownloaded:NO isUnpacking:NO fileType:HolyFileTypeText pagePosition:kPagePositionNotSelected fontName:nil fontSize:0] autorelease];
	}
	
	return bookState;
}

@end