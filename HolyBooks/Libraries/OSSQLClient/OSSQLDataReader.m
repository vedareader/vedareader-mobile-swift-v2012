//
//  OSSQLDataReader.m
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import "OSSQLDataReader.h"


@implementation OSSQLDataReader

- (id)init
{
	return [self initWithStatement:nil];
}

- (id)initWithStatement: (sqlite3_stmt *)state
{
	if (self = [super init])
	{
		statement = state;
	}
	
	return self;
}

- (void)dealloc
{
	if (statement != nil)
		NSLog(@"Warning: Data Reader not closed");
	
	[super dealloc];
}

- (void)close
{
	sqlite3_finalize(statement);
	statement = nil;
}

- (BOOL)read
{
	return (sqlite3_step(statement) == SQLITE_ROW);
}

- (NSInteger)getInteger: (NSInteger)column
{
	return sqlite3_column_int(statement, (int)column);
}

- (double)getDouble: (NSInteger)column
{
	return sqlite3_column_double(statement, (int)column);
}

- (NSString *)getString: (NSInteger)column
{
	if (sqlite3_column_text(statement, (int)column) == NULL)
		return nil;
	return [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, (int)column)];
}

- (NSDate *)getDate: (NSInteger)column
{
	
	if (sqlite3_column_text(statement, (int)column) == NULL)
		return nil;
	NSTimeInterval timeInterval = sqlite3_column_double(statement, (int)column);
	return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

- (OSGuid *)getGuid: (NSInteger)column
{
	if (sqlite3_column_text(statement, (int)column) == NULL)
		return nil;
	NSString *guidString = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, (int)column)];
	return [OSGuid guidFromString:guidString];
}

- (NSData *)getBlob: (NSInteger)column
{
	if (sqlite3_column_blob(statement, (int)column) == NULL)
		return nil;
	return [NSData dataWithBytes:sqlite3_column_blob(statement, (int)column)
						  length:sqlite3_column_bytes(statement, (int)column)];
}

- (BOOL)getBoolean: (NSInteger)column
{
	return (sqlite3_column_int(statement, (int)column) == 1);
}

@end

