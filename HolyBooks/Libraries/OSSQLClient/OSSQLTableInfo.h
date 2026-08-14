//
//  OSSQLTableInfo.h
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSSQLTableInfo : NSObject 
{
	NSString *name;
	NSArray *columns;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *columns;

- (id)initWithName: (NSString *)_name;

@end
