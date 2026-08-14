//
//  ChapterDescription.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 11/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "ChapterDescription.h"

@implementation ChapterDescription

- (void)dealloc
{
	[_title release];
	
	[super dealloc];
}

@end
