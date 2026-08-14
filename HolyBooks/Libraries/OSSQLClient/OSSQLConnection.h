//
//  OSSQLConnection.h
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface OSSQLConnection : NSObject 
{
	NSString *databasePath;
	sqlite3 *database;
}

@property (nonatomic, retain) NSString *databasePath;
@property (nonatomic, readonly) sqlite3 *database;

- (id)initWithDBPath: (NSString *)dbPath;
- (void)open;
- (void)close;
//+ (void)enableSharedCache: (int)cache;

@end
