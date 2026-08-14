//
//  SelectLanguageView.m
//  HolyBooks
//
//  Created by Roman Developer on 1/21/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "SelectLanguageView.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"
#import "HolyLanguage.h"
#import "HolyContentManager.h"
#import "Settings.h"

@interface SelectLanguageView ()

@property (nonatomic, retain) HolyLanguage *language;

@end

@implementation SelectLanguageView

+ (instancetype)createWithLanguage:(HolyLanguage *)language isOn:(BOOL)isOn
{
	SelectLanguageView *view = (SelectLanguageView *)[self createFromNib];
	
	view.language = language;
	[view.swSwitch setOn:isOn];
	view.lblText.text = language.name;
	
	[view innerInit];
	return view;
}

- (void)innerInit
{
	//Self
	[self constraintHeight:40];
	
	//Label
	[_lblText alignLeadingWithPadding:0];
	[_lblText alignCenterYWithPadding:0];
	
	//Switch
	[_swSwitch pinLeadingTo:_lblText withPadding:15];
	[_swSwitch alignCenterYWithPadding:0];
	[_swSwitch alignTrailingWithPadding:0];
	
	//Divider
	[_imgDivider dockBottom];
	[_imgDivider constraintHeight:1];
}

- (void)dealloc
{
	[_language release];
	
    [_lblText release];
    [_imgDivider release];
    [_swSwitch release];
	
    [super dealloc];
}

- (void)setSeparatorHidden:(BOOL)value
{
	_imgDivider.hidden = value;
}

#pragma mark - Actions
- (IBAction)swSwitch_ValueChanged:(id)sender
{
	if (!_swSwitch.isOn)
	{
		//First we need to check if this is last language being deselected
		NSMutableArray <NSNumber *> *selectedLanguages = [NSMutableArray array];
		for (HolyLanguage *language in [HolyContentManager sharedManager].languages)
		{
			if ([[Settings sharedSettings] languageOnWithID:language.identity])
				[selectedLanguages addObject:@(language.identity)];
		}
		
		if (selectedLanguages.count <= 1)
		{
			[_swSwitch setOn:YES];
			[self.delegate displayLanguageSelectionError];
			return;
		}
	}
	
	[self.delegate valueSelectedWithLanguageID:_language.identity isOn:_swSwitch.isOn];
	
}

@end
