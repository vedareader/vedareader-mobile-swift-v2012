//
//  HolyBook.m
//  HolyBooks
//
//  Created by Class Generator by romandeveloper on 2015-10-20.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "HolyBook.h"
#import "HolyFile.h"
#import "OSSQLClient.h"
#import "AppHelper.h"
#import "HolySet.h"
#import "HolyContentManager.h"

#import "NSObject+NSNull.h"

@implementation HolyBook

- (id)init
{
	return [self initWithIdentity:0 languageID:0 name:nil authorID:0 image:nil desc:nil set:0 setOrder:0 files:nil position:0.0];
}

- (id)initWithIdentity:(NSInteger)identity
			languageID:(NSInteger)languageID
				  name:(NSString *)name
			  authorID:(NSInteger)authorID
				 image:(NSString *)image
				  desc:(NSString *)desc
				   set:(NSInteger)setID
			  setOrder:(NSInteger)setOrder
				 files:(NSArray *)files
			  position:(double)position
{
    if ((self = [super init]))
    {
		self.identity = identity;
		self.languageID = languageID;
		self.name = name;
		self.authorID = authorID;
		self.image = image;
		self.desc = desc;
		self.files = files;
		self.package = setID;
		self.packageOrder = setOrder;
		self.position = position;
	}
    return self;
}

- (void)dealloc
{
	[_name release];
	[_image release];
	[_desc release];
	[_files release];
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Identity: %ld, Language: %ld, Name: %@, AuthorID: %ld, Image: %@, Desc: %@, Package: %ld, PackageOrder: %ld Files: %@, Position: %f",
			(long)_identity,
			(long)_languageID,
			_name,
			(long)_authorID,
			_image,
			_desc,
			(long)_package,
			(long)_packageOrder,
			_files,
			_position
			];
}

#pragma mark - Functionality
+ (HolyBook *)getFromDictionary:(NSDictionary *)jsonData
{
    if(![jsonData isKindOfClass:[NSDictionary class]])
        return nil;
	
	NSArray *files = [HolyFile getFromDataArray:[jsonData objectForKey:@"files"]];
	
	double position = 0.0;
	NSNumber *positionObj = [jsonData objectForKey:@"position"];
	if (![NSObject isNullObject:positionObj])
	{
		position = [positionObj doubleValue];
	}
	
    //Create HolyBook object
    HolyBook *item = [[HolyBook alloc] initWithIdentity:[[jsonData objectForKey:@"id"] integerValue]
											 languageID:[[jsonData objectForKey:@"language"] integerValue]
												 name:[jsonData objectForKey:@"name"]
											   authorID:[[jsonData objectForKey:@"authorID"] integerValue] 
												image:[jsonData objectForKey:@"image"]
												desc:[jsonData objectForKey:@"desc"]
													set:[[jsonData objectForKey:@"set"] integerValue]
											   setOrder:[[jsonData objectForKey:@"setOrder"] integerValue]
												  files:files
											   position:position
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
	cmd.commandText = @"SELECT ID, LanguageID, Name, AuthorID, Image, Desc, Package, PackageOrder FROM Books ORDER BY Name ASC";
	[conn open];
	
	OSSQLDataReader *reader = [cmd executeReader];
	while ([reader read])
	{
		HolyBook *book = [[HolyBook alloc] initWithIdentity:[reader getInteger:0]
												 languageID:[reader getInteger:1]
													   name:[reader getString:2]
												   authorID:[reader getInteger:3]
													image:[reader getString:4]
													 desc:[reader getString:5]
														set:[reader getInteger:6]
												   setOrder:[reader getInteger:7]
													  files:nil
												   position:0.0];
		[objects addObject:book];
		[book release];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	//Load files
	for (HolyBook *book in objects)
		book.files = [HolyFile getAllByBookID:book.identity];
	
	return objects;
}

+ (NSArray *)getByPackageID: (NSInteger)identity
{
	NSMutableArray *objects = [NSMutableArray array];
	NSArray *totalBooks = [[HolyContentManager sharedManager] books];
	
	for (HolyBook *curBook in totalBooks)
	{
		if (curBook.package == identity)
		{
			[objects addObject:curBook];
		}
	}
	
	return objects;
}

+ (HolyBook *)getByID: (NSInteger)identity
{
	HolyBook *book = nil;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT ID, LanguageID, Name, AuthorID, Image, Desc, Package, PackageOrder FROM Books WHERE ID = :ID";
	[conn open];
	
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(identity)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
	{
		book = [[HolyBook alloc] initWithIdentity:[reader getInteger:0]
									   languageID:[reader getInteger:1]
											 name:[reader getString:2]
										 authorID:[reader getInteger:3]
											image:[reader getString:4]
											 desc:[reader getString:5]
											  set:[reader getInteger:6]
										 setOrder:[reader getInteger:7]
											files:nil
										 position:0.0];
	}
	
	[reader close];
	[cmd release];
	[conn release];
	
	//Load files
	book.files = [HolyFile getAllByBookID:book.identity];
	
	return [book autorelease];
}

+ (BOOL)existsWithID: (NSInteger)identity
{
	BOOL exists = NO;
	
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM Books WHERE ID = :ID";
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

+ (NSInteger)booksQuantityWithAuthorID:(NSInteger)authorID
{
	NSInteger booksCount = 0;
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM Books WHERE AuthorID = :AuthorID";
	[conn open];
	
	[cmd addParameterWithName:@":AuthorID" type:OSSQLParameterInteger value:@(authorID)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
		booksCount = [reader getInteger:0];
	
	[reader close];
	[cmd release];
	[conn release];
	
	return booksCount;
}

+ (NSInteger)booksQuantityWithSetID:(NSInteger)setID
{
	NSInteger booksCount = 0;
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	cmd.commandText = @"SELECT COUNT(*) FROM Books WHERE Package = :Package";
	[conn open];
	
	[cmd addParameterWithName:@":Package" type:OSSQLParameterInteger value:@(setID)];
	OSSQLDataReader *reader = [cmd executeReader];
	if ([reader read])
		booksCount = [reader getInteger:0];
	
	[reader close];
	[cmd release];
	[conn release];
	
	return booksCount;
}

- (void)update
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"UPDATE Books SET LanguageID = :LanguageID, Name = :Name, AuthorID = :AuthorID, Image = :Image, Desc = :Desc WHERE ID = :ID";
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(_identity)];
	[cmd addParameterWithName:@":LanguageID" type:OSSQLParameterInteger value:@(_languageID)];
	[cmd addParameterWithName:@":Name" type:OSSQLParameterString value:_name];
	[cmd addParameterWithName:@":AuthorID" type:OSSQLParameterInteger value:@(_authorID)];
	[cmd addParameterWithName:@":Image" type:OSSQLParameterString value:_image];
	[cmd addParameterWithName:@":Desc" type:OSSQLParameterString value:_desc];
	
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
	
	//Update files
//	NSArray *files = [HolyFile getAllByBookID:_identity];
//	[files makeObjectsPerformSelector:@selector(removeWithBookID:) withObject:@(_identity)];
//	[_files makeObjectsPerformSelector:@selector(insertWithBookID:) withObject:@(_identity)];
}

- (void)insert
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	NSString *command = [NSString stringWithFormat:@"INSERT INTO Books (ID, LanguageID, Name, AuthorID, Image, Desc, Package, PackageOrder) VALUES (%ld, %ld, \"%@\", %ld, \"%@\", \"%@\", %ld, %ld)", (long)_identity, (long)_languageID, _name, (long)_authorID, _image, _desc, (long)_package, (long)_packageOrder];
	cmd.commandText = command;/*@"INSERT INTO Books (ID, LanguageID, Name, AuthorID, Image, Desc, Set, SetOrder) VALUES (:ID, :LanguageID, :Name, :AuthorID, :Image, :Desc :Set :SetOrder)";*/
	/*[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(_identity)];
	[cmd addParameterWithName:@":LanguageID" type:OSSQLParameterInteger value:@(_languageID)];
	[cmd addParameterWithName:@":Name" type:OSSQLParameterString value:_name];
	[cmd addParameterWithName:@":AuthorID" type:OSSQLParameterInteger value:@(_authorID)];
	[cmd addParameterWithName:@":Image" type:OSSQLParameterString value:_image];
	[cmd addParameterWithName:@":Desc" type:OSSQLParameterString value:_desc];
	[cmd addParameterWithName:@":Set" type:OSSQLParameterInteger value:@(_set)];
	[cmd addParameterWithName:@":SetOrder" type:OSSQLParameterInteger value:@(_setOrder)];*/
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
	
	//Insert files
	//[_files makeObjectsPerformSelector:@selector(insertWithBookID:) withObject:@(_identity)];
}

- (void)remove
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"DELETE FROM Books WHERE ID = :ID";
	[cmd addParameterWithName:@":ID" type:OSSQLParameterInteger value:@(_identity)];
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
	
	//Remove files
	NSArray *files = [HolyFile getAllByBookID:_identity];
	[files makeObjectsPerformSelector:@selector(removeWithBookID:) withObject:@(_identity)];
}

+ (void)removeAll
{
	OSSQLConnection *conn = [[OSSQLConnection alloc] initWithDBPath:[AppHelper databasePath]];
	OSSQLCommand *cmd = [[OSSQLCommand alloc] initWithSQLConnection:conn];
	[conn open];
	cmd.commandText = @"DELETE FROM Books";
	[cmd executeNonQuery];
	
	[cmd release];
	[conn release];
	
	//Remove files
	[HolyFile removeAll];
}

@end
