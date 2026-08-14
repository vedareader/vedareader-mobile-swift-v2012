//
//  OSSQLMetaInfo.m
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import "OSSQLMetaInfo.h"
#import "AppHelper.h"

@implementation OSSQLMetaInfo

@synthesize tables;

- (void)dealloc
{
	[tables release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Tables: %@", tables];
}

#pragma mark -
#pragma mark Working with Data
+ (OSSQLMetaInfo *)metaInfoForConnection: (OSSQLConnection *)conn
{
	OSSQLMetaInfo *metaInfo = [[OSSQLMetaInfo alloc] init];
	
	//Get tables
	NSMutableArray *tableInfos = [[NSMutableArray alloc] init];
	
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
	
	OSSQLDataReader *reader = [cmd executeReader]; [cmd clearParameters];
	while ([reader read])
	{
		OSSQLTableInfo *tableInfo = [[OSSQLTableInfo alloc] initWithName:[reader getString:0]];
		[tableInfos addObject:tableInfo];
		[tableInfo release];
	}
	
	[reader close];
	[cmd release];
	
	//Get columns
	OSSQLCommand *pragmaComm = nil;
	NSMutableArray *columnInfos = nil;
	for (OSSQLTableInfo *tableInfo in tableInfos)
	{
		columnInfos = [[NSMutableArray alloc] init];
		
		pragmaComm = [[OSSQLCommand alloc] initWithSQLConnection:conn];
		pragmaComm.commandText = [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableInfo.name];
		
		OSSQLDataReader *reader = [pragmaComm executeReader];
		while ([reader read])
		{
			OSSQLColumnInfo *columnInfo = [[OSSQLColumnInfo alloc] initWithName:[reader getString:1]];
			[columnInfos addObject:columnInfo];
			[columnInfo release];
		}
		
		[reader close];
		[pragmaComm release];	
		
		tableInfo.columns = columnInfos;
		[columnInfos release];
	}
	
	metaInfo.tables = tableInfos;
	return [metaInfo autorelease];
}

+ (OSSQLMetaInfo *)metaInfo
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	[conn open];
	
	OSSQLMetaInfo *metaInfo = [OSSQLMetaInfo metaInfoForConnection:conn];
	
	[conn release];
	return metaInfo;
}

@end
