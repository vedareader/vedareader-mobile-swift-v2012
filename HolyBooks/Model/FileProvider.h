//
//  FileProvider.h
//  HolyBooks
//
//  Created by Roman Developer on 9/17/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentProvider.h"

@interface FileProvider : NSObject <ContentProvider>
{
	long long contentLength;
	NSFileHandle *fileHandle;
}

@end
