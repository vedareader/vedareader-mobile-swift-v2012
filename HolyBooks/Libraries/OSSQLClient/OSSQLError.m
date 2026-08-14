//
//  OSSQLError.m
//  Keyboard
//
//  Created by Roman Developer on 3/6/14.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import "OSSQLError.h"

@implementation OSSQLError

+ (NSString *)infoForErrorOfType: (OSSQLErrorType)errorType errorCode: (NSInteger)errorCode commandText: (NSString *)commandText
{
	return [NSString stringWithFormat:@"%@\n%@\nSQL: %@", [self textForErrorType:errorType], [self textForErrorCode:errorCode], commandText];
}

+ (NSString *)textForErrorType: (OSSQLErrorType)errorType
{
	switch (errorType)
	{
		case OSSQLErrorExecuteReader:
			return @"Error executing reader";
		case OSSQLErrorPrepareCommand:
			return @"Error preparing command";
		case OSSQLErrorExecuteNonQuery:
			return @"Error executing non query";
			
		default:
			return @"Unknown error";
	}
}

+ (NSString *)textForErrorCode: (NSInteger)errorCode
{
	switch (errorCode)
	{
		case 1:
			return @"SQL error or missing database";
		case 2:
			return @"Internal logic error in SQLite";
		case 3:
			return @"Access permission denied";
		case 4:
			return @"Callback routine requested an abort";
		case 5:
			return @"The database file is locked";
		case 6:
			return @"A table in the database is locked";
		case 7:
			return @"A malloc() failed";
		case 8:
			return @"Attempt to write a readonly database";
		case 9:
			return @"Operation terminated by sqlite3_interrupt()";
		case 10:
			return @"Some kind of disk I/O error occurred";
		case 11:
			return @"The database disk image is malformed";
		case 12:
			return @"Unknown opcode in sqlite3_file_control()";
		case 13:
			return @"Insertion failed because database is full";
		case 14:
			return @"Unable to open the database file";
		case 15:
			return @"Database lock protocol error";
		case 16:
			return @"Database is empty";
		case 17:
			return @"The database schema changed";
		case 18:
			return @"String or BLOB exceeds size limit";
		case 19:
			return @"Abort due to constraint violation";
		case 20:
			return @"Data type mismatch";
		case 21:
			return @"Library used incorrectly";
		case 22:
			return @"Uses OS features not supported on host";
		case 23:
			return @"Authorization denied";
		case 24:
			return @"Auxiliary database format error";
		case 25:
			return @"2nd parameter to sqlite3_bind out of range";
		case 26:
			return @"File opened that is not a database file";
		case 27:
			return @"Notifications from sqlite3_log()";
		case 28:
			return @"Warnings from sqlite3_log()";
		case 100:
			return @"sqlite3_step() has another row ready";
		case 101:
			return @"sqlite3_step() has finished executing";
						
		default:
			return [NSString stringWithFormat:@"Unknown error code: %ld", (long)errorCode];
	}
}

@end
