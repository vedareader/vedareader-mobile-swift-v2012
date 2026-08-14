//
//  OSSQLParameter.h
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/24/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _OSParameterType
{
	OSSQLParameterInteger = 1,
	OSSQLParameterDouble = 2,
	OSSQLParameterString = 3,
	OSSQLParameterBlob = 4,
	OSSQLParameterNull = 5,
	OSSQLParameterDateTime = 6,
	OSSQLParameterGuid = 7,
	OSSQLParameterBoolean = 8
} OSParameterType;

@interface OSSQLParameter : NSObject {
	NSString *name;
	OSParameterType type;
	NSObject *value;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic) OSParameterType type;
@property (nonatomic, retain) NSObject *value;

- (id)initWithName: (NSString *)_name type: (OSParameterType)_type value: (NSObject *)_value;

@end
