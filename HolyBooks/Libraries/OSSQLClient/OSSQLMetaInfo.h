//
//  OSSQLMetaInfo.h
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSQLCommand.h"
#import "OSSQLTableInfo.h"
#import "OSSQLColumnInfo.h"


@interface OSSQLMetaInfo : NSObject 
{
	NSArray *tables;
}

@property (nonatomic, retain) NSArray *tables;

+ (OSSQLMetaInfo *)metaInfo;
+ (OSSQLMetaInfo *)metaInfoForConnection: (OSSQLConnection *)conn;

@end
