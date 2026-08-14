//
//  HolyLanguage.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyLanguage.h"
#import "OSSQLClient.h"
#import "AppHelper.h"

@implementation HolyLanguage

- (id)init
{
	return [self initWithIdentity:0 name:nil];
}

- (id)initWithIdentity:(NSInteger)identity
				name:(NSString *)name
{
    if ((self = [super init]))
    {
		self.identity = identity;
		self.name = name;
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
    return [NSString stringWithFormat:@"Identity: %ld, Name: %@",
			(long)_identity,
			_name
			];
}

#pragma mark - Functionality
+ (HolyLanguage *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
    //Create HolyLanguage object
    HolyLanguage *item = [[HolyLanguage alloc] initWithIdentity:[[jsonData objectForKey:@"id"] integerValue] 
														 name:[jsonData objectForKey:@"name"]
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
+ (NSArray *)getAll
{
	NSMutableArray *objects = [NSMutableArray array];
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT ID, Name FROM Languages";
	[conn open];
	
	OSSQLDataReader *reader = [cmd executeReader];
	while ([reader read])
	{
		HolyLanguage *language = [[HolyLanguage alloc] initWithIdentity:[reader getInteger:0]
																   name:[reader getString:1]];
		[objects addObject:language];
		[language release];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return objects;
}

+ (HolyLanguage *)getByID: (NSInteger)identity
{
	HolyLanguage *language = nil;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT ID, Name FROM Languages WHERE ID = :ID";
	[conn open];
	
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(identity)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
	{
		language = [[HolyLanguage alloc] initWithIdentity:[reader getInteger:0]
											   name:[reader getString:1]];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return [language autorelease];
}

+ (BOOL)existsWithID: (NSInteger)identity
{
	BOOL exists = NO;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM Languages WHERE ID = :ID";
	[conn open];
	
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(identity)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
		exists = ([reader getInteger:0] > 0);
	
	[reader close];
	[cmd release];
	[conn release];
	
	return exists;
}

- (void)insert
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"INSERT INTO Languages (ID, Name) VALUES (:ID, :Name)";
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(_identity)];
	[cmd addParameterWithName:@":Name" type:OSSQLParameterString value:_name];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

@end