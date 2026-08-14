//
//  OSSQLConnection.m
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import "OSSQLConnection.h"

void myLike( sqlite3_context * ctx, int argc, sqlite3_value ** argv )
{
	//if( argc != 1 ) return;
	//wstring str;
	switch(sqlite3_value_type(argv[0]))
	{
		case SQLITE_NULL:
		{
			sqlite3_result_text( ctx, "NULL", 4, SQLITE_STATIC );
			break;
		}
		case SQLITE_TEXT:
		{
			NSString *s1 = [NSString stringWithCString:(char*)sqlite3_value_text(argv[0]) encoding:NSUTF8StringEncoding];
			NSString *s2 = [NSString stringWithCString:(char*)sqlite3_value_text(argv[1]) encoding:NSUTF8StringEncoding];
			
			int length = (int)[s1 length];
			
			/*
			if(length < 3)
			{				
				if([s2 length] >= length)
				{
					s2 = [s2 substringToIndex:length];
					int res = ([s1 localizedCaseInsensitiveCompare:s2] == NSOrderedSame) ? 1 : 0;
					sqlite3_result_int( ctx, res );
				}
				else
					sqlite3_result_int( ctx, 0 );
			}
			else
			{
			 */
				if([s2 length] >= length)
				{
					int res = ([s2 rangeOfString:s1 options:NSCaseInsensitiveSearch].location == NSNotFound) ? 0 : 1;
					sqlite3_result_int( ctx, res );

				}
				else
					sqlite3_result_int( ctx, 0 );			
			//}
			break;
		}
		default:
			sqlite3_result_text( ctx, "NULL", 4, SQLITE_STATIC );
			break;
	}
}

@interface OSSQLConnection()

- (void)setNocaseForUTF8;

@end

@implementation OSSQLConnection

@synthesize databasePath;
@synthesize database;

- (id)init
{
	return [self initWithDBPath:nil];
}

- (id)initWithDBPath: (NSString *)dbPath
{
	if (self = [super init])
	{
		self.databasePath = dbPath;
		database = nil;
	}
	
	return self;
}

- (void)dealloc
{
	if (database != nil)
		[self close];
	[self.databasePath release];
	[super dealloc];
}

- (void)open
{
	int result = sqlite3_open([databasePath UTF8String], &database);
	if (result != SQLITE_OK)
		NSLog(@"Error opening db: %d", result);
	else
		[self setNocaseForUTF8];
}

- (void)close
{
	int res = sqlite3_close(database);
	if (res != SQLITE_OK)
		NSLog(@"Error closing db: %d", res);
	database = nil;
}

/*
+ (void)enableSharedCache: (int)cache
{
	sqlite3_enable_shared_cache(cache);
}
*/

- (void)setNocaseForUTF8
{
	int res = 0;
	
	res = sqlite3_create_function( database, "LIKE", 3, SQLITE_ANY, NULL, myLike, NULL, NULL );
	if (res != SQLITE_OK)
		NSLog(@"Error opening db: %d", res);
	res = sqlite3_create_function( database, "LIKE", 2, SQLITE_ANY, NULL, myLike, NULL, NULL );
	if (res != SQLITE_OK)
		NSLog(@"Error opening db: %d", res);
}

@end
