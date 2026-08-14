//
//  DownloadInfo.h
//  HolyBooks
//
//  Created by Class Generator by Roman Leshukov on 1/12/2015.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadInfo : NSObject <NSCoding>

@property (nonatomic, assign) int64_t bytesReceived;
@property (nonatomic, assign) int64_t bytesTotal;

- (id)initWithBytesReceived:(int64_t)bytesReceived 
				 bytesTotal:(int64_t)bytesTotal;


@end