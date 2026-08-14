//
//  Settings.m
//  Psycho
//
//  Created by RomanMac on 1/19/13.
//  Copyright (c) 2013 ironwaterstudio. All rights reserved.
//

#import "Settings.h"

#define kLanguageKey @"Language"

@implementation Settings

+ (Settings *)sharedSettings
{
	static Settings *settings;
	if (settings == nil)
	{
		settings = [[Settings alloc] init];
	
		//Init settings
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		if ([userDefaults objectForKey:@"settingsInitialized"] == nil)
		{
			[userDefaults setBool:YES forKey:@"settingsInitialized"];
			[userDefaults synchronize];
		}
	}
	
	return settings;
}

- (Localisation)localization
{
	NSArray <NSString *> *localizations = [[NSBundle mainBundle] preferredLocalizations];
	if ([localizations[0] isEqualToString:@"ru"])
		return LocalizationRussian;
	else
		return LocalizationEnglish;
}

#pragma mark - Functionality
- (BOOL)languageOnWithID: (NSInteger)languageID
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *languageKey = [NSString stringWithFormat:@"%@-%ld", kLanguageKey, (long)languageID];

	//Language is ON by default
	if ([userDefaults objectForKey:languageKey] == nil)
		return YES;
	else
		return [userDefaults boolForKey:languageKey];
}

- (void)setLanguageOnWithID: (NSInteger)languageID isOn: (BOOL)isOn
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *languageKey = [NSString stringWithFormat:@"%@-%ld", kLanguageKey, (long)languageID];
	[userDefaults setBool:isOn forKey:languageKey];
	[userDefaults synchronize];
}

@end
