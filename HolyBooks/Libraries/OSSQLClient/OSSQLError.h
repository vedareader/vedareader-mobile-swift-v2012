//
//  OSSQLError.h
//  Keyboard
//
//  Created by Roman Developer on 3/6/14.
//  Copyright (c) 2014 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	OSSQLErrorExecuteReader,
	OSSQLErrorPrepareCommand,
	OSSQLErrorExecuteNonQuery
} OSSQLErrorType;

@interface OSSQLError : NSObject

+ (NSString *)infoForErrorOfType: (OSSQLErrorType)errorType errorCode: (NSInteger)errorCode commandText: (NSString *)commandText;

@end
