//
//  Enums.h
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#ifndef HolyBooks_Enums_h
#define HolyBooks_Enums_h

typedef enum
{
	MainMenuItemMyBooks = 0,
	MainMenuItemAuthors = 1,
	MainMenuItemLibrary = 2,
	MainMenuItemSet = 3,
	MainMenuItemAbout = 4,
	MainMenuItemMAX = 5
} MainMenuItem;

typedef enum : NSUInteger {
	ReaderSettingTypeUnknown,
	ReaderSettingTypeTransition,
	ReaderSettingTypeFont
} ReaderSettingType;

#endif
