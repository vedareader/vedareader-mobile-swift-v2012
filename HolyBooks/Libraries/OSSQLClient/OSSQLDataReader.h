//
//  OSSQLDataReader.h
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "OSGuid.h"


@interface OSSQLDataReader : NSObject {
	sqlite3_stmt *statement;
}

- (id)initWithStatement: (sqlite3_stmt *)state;

- (void)close;
- (BOOL)read;
- (NSInteger)getInteger: (NSInteger)column;
- (double)getDouble: (NSInteger)column;
- (NSString *)getString: (NSInteger)column;
- (NSDate *)getDate: (NSInteger)column;
- (OSGuid *)getGuid: (NSInteger)column;
- (NSData *)getBlob: (NSInteger)column;
- (BOOL)getBoolean: (NSInteger)column;

@end