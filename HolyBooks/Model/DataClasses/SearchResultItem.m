//
//  SearchResultItem.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 04/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "SearchResultItem.h"

@implementation SearchResultItem

- (void)dealloc
{
	[_chapterTitle release];
	[_text release];
	
	[super dealloc];
}

@end
