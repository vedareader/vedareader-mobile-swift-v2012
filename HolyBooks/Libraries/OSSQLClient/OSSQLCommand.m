//
//  OSSQLCommand.m
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import "OSSQLCommand.h"
#import "OSSQLError.h"


@implementation OSSQLCommand

@synthesize connection;
@synthesize commandText;
@synthesize parameters;

- (id)init
{
	return [self initWithSQLConnection:nil];
}

- (id)initWithSQLConnection: (OSSQLConnection *)conn
{
	if (self = [super init])
	{
		self.connection = conn;
		self.parameters = [NSMutableArray array];
	}
	
	return self;
}

- (void)dealloc
{
	[self.parameters release];
	[self.connection release];
	[super dealloc];
}

- (OSSQLDataReader *)executeReader
{
	//Prepare statement
	sqlite3_stmt *statement;
	int res = sqlite3_prepare_v2(connection.database, [commandText UTF8String], -1, &statement, nil);
	if (res != SQLITE_OK)
	{
		NSLog(@"%@", [OSSQLError infoForErrorOfType:OSSQLErrorExecuteReader errorCode:res commandText:commandText]);
	}
	
	//Bind parameters
	[self bindParameters:statement];
	
	//Proceed to execution
	return [[[OSSQLDataReader alloc] initWithStatement:statement] autorelease];
}

- (void)executeNonQuery
{
	//Prepare statement
	sqlite3_stmt *statement;
	const char *tail = [commandText UTF8String];
	while (*tail != '\0')
	{
		int res = sqlite3_prepare_v2(connection.database, tail, -1, &statement, &tail);
		if (res != SQLITE_OK)
			NSLog(@"%@", [OSSQLError infoForErrorOfType:OSSQLErrorPrepareCommand errorCode:res commandText:commandText]);
	
		//Bind parameters
		[self bindParameters:statement];
	
		//Execute
		res = sqlite3_step(statement);
		if (res != SQLITE_DONE)
			NSLog(@"%@", [OSSQLError infoForErrorOfType:OSSQLErrorExecuteNonQuery errorCode:res commandText:commandText]);
		sqlite3_finalize(statement);
	}
}

- (NSInteger)lastInsertedID
{
	return (NSInteger)sqlite3_last_insert_rowid(connection.database);
}

- (void)addParameterWithName: (NSString *)parameterName type: (OSParameterType)parameterType value: (NSObject *)parameterValue
{
	OSSQLParameter *parameter = [[OSSQLParameter alloc] initWithName:parameterName type:parameterType value:parameterValue];
	[self.parameters addObject:parameter];
	[parameter release];
}

- (void)clearParameters
{
	[self.parameters removeAllObjects];
}

- (void)bindParameters: (sqlite3_stmt *)statement
{
	for (OSSQLParameter *param in parameters)
	{
		int parameterIndex = sqlite3_bind_parameter_index(statement, [[param name] UTF8String]);
		switch (param.type) 
		{
			case OSSQLParameterInteger:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex); 
				else
					sqlite3_bind_int(statement, parameterIndex, (int)[((NSNumber *)param.value) integerValue]);
				break;
			case OSSQLParameterDouble:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex); 
				else
					sqlite3_bind_double(statement, parameterIndex, [((NSNumber *)param.value) doubleValue]);
				break;			
			case OSSQLParameterString:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex);
				else
                    sqlite3_bind_text(statement, parameterIndex, [(NSString *)param.value UTF8String], -1, nil);
				break;
			case OSSQLParameterBlob:
				sqlite3_bind_blob(statement, parameterIndex, [(NSData *)param.value bytes] , (int)[(NSData *)param.value length], nil);
				break;
			case OSSQLParameterNull:
				sqlite3_bind_null(statement, parameterIndex);
				break;
			case OSSQLParameterDateTime:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex);
				else
					sqlite3_bind_double(statement, parameterIndex, [((NSDate *)param.value) timeIntervalSince1970]);
				break;
			case OSSQLParameterGuid:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex);
				else
					sqlite3_bind_text(statement, parameterIndex, [[(OSGuid *)param.value stringValue] UTF8String], -1, nil);
				break;
			case OSSQLParameterBoolean:
				if (param.value == nil || [param.value isKindOfClass:[NSNull class]])
					sqlite3_bind_null(statement, parameterIndex); 
				else
					sqlite3_bind_int(statement, parameterIndex, (int)[((NSNumber *)param.value) integerValue]);
				break;
			default:
				break;
		}		
	}
}

@end
