//
//  FileProvider.m
//  HolyBooks
//
//  Created by Roman Developer on 9/17/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "FileProvider.h"

@implementation FileProvider

-(void)setContentPath:(NSString *)path
{
	fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
	contentLength = [fileHandle seekToEndOfFile];
	[fileHandle seekToFileOffset:0];
}

//  you should return the length of content(file)
-(long long)lengthOfContent
{
	return contentLength;
}

//  should return the offset of content
-(long long)offsetOfContent
{
	return [fileHandle offsetInFile];
}

//  offset will be set by skyepub engine
-(void)setOffsetOfContent:(long long)offset
{
	[fileHandle seekToFileOffset:offset];
}

// should return the NSData for the content of given path with the size of given length.
// this can be invoked times depends the size of content and the size of buffer.
-(NSData*)dataForContent:(long long)length
{
	long long lengthLeft = contentLength - [fileHandle offsetInFile];
	long long lengthToRead = MIN(length,lengthLeft);
	NSData *data = [fileHandle readDataOfLength:(NSUInteger)lengthToRead];
	if ([data length]==0 || data==nil) {
		return nil;
	}
	else {
		return data;
	}
}

//  should return whether reading content is finished or not.
-(BOOL)isFinished
{
	if ([fileHandle offsetInFile]>=contentLength) {
		return YES;
	}else {
		return NO;
	}
}

-(void)destroy {
	
}

-(void)dealloc {
	//    NSLog(@"dealloc in FileProvider");
	[super dealloc];
}

@end
