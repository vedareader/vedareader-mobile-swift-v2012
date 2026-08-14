//
//  ShareData.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 27/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "ShareData.h"

@implementation ShareData

- (instancetype)initWithText:(NSString *)text
				  authorName:(NSString *)authorName
					 chapter:(NSString *)chapter
{
	if ((self = [super init]))
	{
		self.text = text;
		self.authorName = authorName;
		self.chapter = chapter;
	}
	
	return self;
}

- (void)dealloc
{
	[_text release];
	[_authorName release];
	[_chapter release];
	
	[super dealloc];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Text: %@, AuthorName: %@, Chapter: %@", _text, _authorName, _chapter];
}

@end
