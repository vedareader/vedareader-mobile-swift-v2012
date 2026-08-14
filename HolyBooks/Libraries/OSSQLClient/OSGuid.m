//
//  OSGuid.m
//  CMOCompliance
//
//  Created by Roman Leshukov on 12/2/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import "OSGuid.h"


@implementation OSGuid

- (id)initWithGuidInternal: (CFUUIDRef)_uuid
{
	if (self = [super init])
	{
		_stringValue = nil;
		guid = _uuid;
	}
	
	return self;
}

- (id)init
{
	return [self initWithGuidInternal:NULL];
}

- (NSString *)description
{
	return [self stringValue];
}

- (BOOL)isEqual:(id)object
{
	//return [[[self stringValue] uppercaseString] isEqual:[[(OSGuid *)object stringValue] uppercaseString]];
	
	return ([[self stringValue] compare :[(OSGuid *)object stringValue] options :NSCaseInsensitiveSearch] == NSOrderedSame);
}

- (void)dealloc
{
	if(guid)
		CFRelease(guid);
	if(_stringValue != nil)
		[_stringValue release];
	[super dealloc];
}

#pragma mark -
#pragma mark Public methods
+ (OSGuid *)newGuid;
{
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	return [[[OSGuid alloc] initWithGuidInternal:uuid] autorelease];
}

+ (OSGuid *)guidFromString: (NSString *)stringGuid
{
	CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)stringGuid);
	return [[[OSGuid alloc] initWithGuidInternal:uuid] autorelease];
}

+ (OSGuid *)Empty
{
	return [OSGuid guidFromString:@"00000000-0000-0000-0000-000000000000"];
}

- (NSString *)stringValue
{
	//NSString *string = (NSString *)CFUUIDCreateString(NULL, guid);
	//return [string autorelease];
	if(_stringValue == nil)
	{
		_stringValue = (NSString *)CFUUIDCreateString(NULL, guid);
	}
	return _stringValue;
}

@end
