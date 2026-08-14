//
//  OSSQLTableInfo.m
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import "OSSQLTableInfo.h"


@implementation OSSQLTableInfo

@synthesize name;
@synthesize columns;

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
	[columns release];
	[name release];
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Name: %@, Columns: %@", name, columns];
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[OSSQLTableInfo class]])
		return NO;
	return [((OSSQLTableInfo *)object).name isEqualToString:self.name];
}

@end
