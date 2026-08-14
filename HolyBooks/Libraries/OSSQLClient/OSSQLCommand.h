//
//  OSSQLCommand.h
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/22/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSQLConnection.h"
#import "OSSQLDataReader.h"
#import "OSSQLParameter.h"


@interface OSSQLCommand : NSObject
{
	OSSQLConnection *connection;
	NSString *commandText;
	NSMutableArray *parameters;
}

@property (nonatomic, retain) OSSQLConnection *connection;
@property (nonatomic, retain) NSString *commandText;
@property (nonatomic, retain) NSMutableArray *parameters;

- (id)initWithSQLConnection: (OSSQLConnection *)conn;

- (OSSQLDataReader *)executeReader;
- (void)executeNonQuery;
- (NSInteger)lastInsertedID;

- (void)addParameterWithName: (NSString *)parameterName type: (OSParameterType)parameterType value: (NSObject *)parameterValue;
- (void)clearParameters;
- (void)bindParameters: (sqlite3_stmt *)statement;

@end
