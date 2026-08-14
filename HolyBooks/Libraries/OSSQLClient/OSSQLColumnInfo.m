//
//  OSSQLColumnInfo.m
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import "OSSQLColumnInfo.h"


@implementation OSSQLColumnInfo

@synthesize name;

- (id)init
{
	return [self initWithName:@""];
}

- (id)initWithName: (NSString *)_name
{
	if (self = [super init])
	{
		self.name = _name;
	}
	
	return self;
}

- (void)dealloc
{
	[name release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Name: %@", name];
}

@end
