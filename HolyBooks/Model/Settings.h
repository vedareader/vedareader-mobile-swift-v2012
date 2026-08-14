//
//  Settings.h
//  Psycho
//
//  Created by RomanMac on 1/19/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	LocalizationEnglish,
	LocalizationRussian
} Localisation; //Localization; <-- original; causes issues if we use it in same files with #import Localization.h

@interface Settings : NSObject

+ (Settings *)sharedSettings;

@property (nonatomic, readonly) Localisation localization;

- (BOOL)languageOnWithID: (NSInteger)languageID;
- (void)setLanguageOnWithID: (NSInteger)languageID isOn: (BOOL)isOn;

@end
