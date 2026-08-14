//
//  HolyDownloadManager.h
//  HolyBooks
//
//  Created by Roman Developer on 2/19/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HolyClasses.h"
#import "DownloadCompletedMessage.h"
#import "DownloadProgressMessage.h"

@interface HolyDownloadManager : NSObject

+ (HolyDownloadManager *)sharedManager;

- (void)rejoinToDownloadSession;
- (void)downloadBook: (HolyBook *)book bookFile: (HolyFile *)bookFile;

@end