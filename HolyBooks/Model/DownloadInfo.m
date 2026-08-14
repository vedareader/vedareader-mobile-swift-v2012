//
//  DownloadInfo.m
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 1/12/2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "DownloadInfo.h"

@implementation DownloadInfo

- (id)init
{
	return [self initWithBytesReceived:0 bytesTotal:0];
}

- (id)initWithBytesReceived:(int64_t)bytesReceived 
				 bytesTotal:(int64_t)bytesTotal
{
	if ((self = [super init]))
	{
		self.bytesReceived = bytesReceived;
		self.bytesTotal = bytesTotal;
	}	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"BytesReceived: %ld, BytesTotal: %ld",
			(long)_bytesReceived, 
			(long)_bytesTotal
			];
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if (self)
	{
		self.bytesReceived = [aDecoder decodeInt64ForKey:@"bytesReceived"];
		self.bytesTotal = [aDecoder decodeInt64ForKey:@"bytesTotal"];
	}
	return self;
};

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[aCoder encodeInt64:self.bytesReceived forKey:@"bytesReceived"];
	[aCoder encodeInt64:self.bytesTotal forKey:@"bytesTotal"];
}


@end