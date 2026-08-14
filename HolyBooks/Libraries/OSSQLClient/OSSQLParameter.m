//
//  OSSQLParameter.m
//  CaucasianCuisine
//
//  Created by Roman Leshukov on 9/24/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import "OSSQLParameter.h"


@implementation OSSQLParameter

@synthesize name, type, value;

- (id)init
{
	return [self initWithName:nil type:OSSQLParameterNull value:nil];
}

- (id)initWithName: (NSString *)_name type: (OSParameterType)_type value: (NSObject *)_value
{
	if (self = [super init])
	{
		self.name = _name;
		self.type = _type;
		self.value = _value;
	}
	
	return self;
}

- (void)dealloc
{
	[self.name release];
	[self.value release];
	[super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@, Type: %d, Value: %@", self.name, self.type, self.value];
}

@end
