//
//  HolyAuthor.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyAuthor.h"
#import "OSSQLClient.h"
#import "AppHelper.h"

@implementation HolyAuthor

- (id)init
{
	return [self initWithIdentity:0 languageID:0 name:nil image:nil desc:nil];
}

- (id)initWithIdentity:(NSInteger)identity
			languageID:(NSInteger)languageID
				  name:(NSString *)name
				 image:(NSString *)image
				  desc:(NSString *)desc
{
    if ((self = [super init]))
    {
		self.identity = identity;
		self.languageID = languageID;
		self.name = name;
		self.image = image;
		self.desc = desc;
	}
    return self;
}

- (void)dealloc
{
	[_name release];
	[_image release];
	[_desc release];
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Identity: %ld, LanguageID: %ld, Name: %@, Image: %@, Desc: %@",
			(long)_identity,
			(long)_languageID,
			_name,
			_image,
			_desc
			];
}

#pragma mark - Functionality
+ (HolyAuthor *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
    //Create HolyAuthor object
    HolyAuthor *item = [[HolyAuthor alloc] initWithIdentity:[[jsonData objectForKey:@"id"] integerValue]
												 languageID:[[jsonData objectForKey:@"language"] integerValue]
													   name:[jsonData objectForKey:@"name"]
													  image:[jsonData objectForKey:@"image"]
													   desc:[jsonData objectForKey:@"desc"]
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
	cmd.commandText = @"SELECT ID, LanguageID, Name, Image, Desc FROM Authors";
	[conn open];
	
	OSSQLDataReader *reader = [cmd executeReader];
	while ([reader read])
	{
		HolyAuthor *author = [[HolyAuthor alloc] initWithIdentity:[reader getInteger:0]
													   languageID:[reader getInteger:1]
															 name:[reader getString:2]
															image:[reader getString:3]
															 desc:[reader getString:4]];
		[objects addObject:author];
		[author release];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return objects;
}

+ (HolyAuthor *)getByID: (NSInteger)identity
{
	HolyAuthor *author = nil;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT ID, LanguageID, Name, Image, Desc FROM Authors WHERE ID = :ID";
	[conn open];
	
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(identity)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
	{
		author = [[HolyAuthor alloc] initWithIdentity:[reader getInteger:0]
										   languageID:[reader getInteger:1]
												 name:[reader getString:2]
												image:[reader getString:3]
												 desc:[reader getString:4]];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	return [author autorelease];
}

+ (BOOL)existsWithID: (NSInteger)identity
{
	BOOL exists = NO;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM Authors WHERE ID = :ID";
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
	cmd.commandText = @"INSERT INTO Authors (ID, LanguageID, Name, Image, Desc) VALUES (:ID, :LanguageID, :Name, :Image, :Desc)";
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(_identity)];
	[cmd addParameterWithName:@":LanguageID" type:OSSQLParameterInteger value:@(_languageID)];
	[cmd addParameterWithName:@":Name" type:OSSQLParameterString value:_name];
	[cmd addParameterWithName:@":Image" type:OSSQLParameterString value:_image];
	[cmd addParameterWithName:@":Desc" type:OSSQLParameterString value:_desc];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
}

@end
