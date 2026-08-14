//
//  OSSQLColumnInfo.h
//  ACData
//
//  Created by Roman Developer on 3/26/11.
//  Copyright 2011 OctoberSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSSQLColumnInfo : NSObject 
{
	NSString *name;
}

@property (nonatomic, retain) NSString *name;

- (id)initWithName: (NSString *)_name;

@end
