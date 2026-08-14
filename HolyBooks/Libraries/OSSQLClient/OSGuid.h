//
//  OSGuid.h
//  CMOCompliance
//
//  Created by Roman Leshukov on 12/2/10.
//  Copyright 2010 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSGuid : NSObject 
{
	CFUUIDRef guid;
	NSString* _stringValue;
}

- (id)initWithGuidInternal: (CFUUIDRef)_uuid;

+ (OSGuid *)newGuid;
+ (OSGuid *)guidFromString: (NSString *)stringGuid;
+ (OSGuid *)Empty;

- (NSString *)stringValue;


@end
