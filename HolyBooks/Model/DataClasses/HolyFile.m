//
//  HolyFile.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyFile.h"
#import "OSSQLClient.h"
#import "AppHelper.h"

@implementation HolyFile

- (id)init
{
    return [self initWithType:0 name:nil size:0];
}

- (id)initWithType:(HolyFileType)type
			  name:(NSString *)name
			  size:(NSInteger)size
{
    if ((self = [super init]))
    {
		self.type = type;
		self.name = name;
		self.size = size;
	}
    return self;
}

- (void)dealloc
{
	[_name release];
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Type: %ld, Name: %@, Size: %ld",
			(long)_type,
			_name,
			(long)_size
			];
}

#pragma mark - Functionality
+ (HolyFile *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
    //Create HolyFile object
    HolyFile *item = [[HolyFile alloc] initWithType:(HolyFileType)[[jsonData objectForKey:@"type"] integerValue]
											   name:[jsonData objectForKey:@"name"]
											   size:[[jsonData objectForKey:@"size"] integerValue]
					  ];
    return [item autorelease];
}

+ (NSMutableArray *)getFromDataArray:(NSArray *)jsonData
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSDictionary *jsonDataItem in jsonData)
    {
        NSObject *item = [self getFromDictionary:jsonDataItem];
        if (item)
            [items addObject:item];
    }
    return [items autorelease];
}

#pragma mark - Database
+ (HolyFile *)getByBookID: (NSInteger)bookID
{
	HolyFile *file = nil;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT Type, Name, Size FROM BookFiles WHERE BookID = :BookID";
	[conn open];
	
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
	{
		file = [[HolyFile alloc] initWithType:(HolyFileType)[reader getInteger:0]
										   name:[reader getString:1]
										 size:[reader getInteger:2]];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return [file autorelease];
}

+ (BOOL)existsWithBookID: (NSInteger)bookID
{
	BOOL exists = NO;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM BookFiles WHERE BookID = :BookID";
	[conn open];
	
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
		exists = ([reader getInteger:0] > 0);
	
	[reader close];
	[cmd release];
	[conn release];
	
	return exists;
}

+ (NSArray *)getAllByBookID: (NSInteger)bookID
{
	NSMutableArray *objects = [NSMutableArray array];
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT Type, Name, Size FROM BookFiles WHERE BookID = :BookID";
	[conn open];
	
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	OSSQLDataReader *reader = [cmd executeReader];
	while ([reader read])
	{
		HolyFile *file = [[HolyFile alloc] initWithType:(HolyFileType)[reader getInteger:0]
												   name:[reader getString:1]
												   size:[reader getInteger:2]];
		
		[objects addObject:file];
		[file release];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return objects;
}

- (void)insertWithBookID: (NSInteger)bookID
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"INSERT INTO BookFiles (BookID, Type, Name, Size) VALUES (:BookID, :Type, :Name, :Size)";
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	[cmd addParameterWithName:@":Type" type:OSSQLParameterInteger value:@(_type)];
	[cmd addParameterWithName:@":Name" type:OSSQLParameterString value:_name];
	[cmd addParameterWithName:@":Size" type:OSSQLParameterInteger value:@(_size)];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

- (void)removeWithBookID: (NSInteger)bookID
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"DELETE FROM BookFiles WHERE BookID = :BookID AND Type = :Type";
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	[cmd addParameterWithName:@":Type" type:OSSQLParameterInteger value:@(_type)];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

+ (void)removeAllWithBookID: (NSInteger)bookID
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"DELETE FROM BookFiles WHERE BookID = :BookID";
	[cmd addParameterWithName:@":BookID" type:OSSQLParameterInteger value:@(bookID)];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

+ (void)removeAll
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"DELETE FROM BookFiles";
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

@end