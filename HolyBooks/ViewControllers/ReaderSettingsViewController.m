//
//  ReaderSettingsViewController.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "ReaderSettingsViewController.h"
#import "ReaderAdditionalSettingsViewController.h"

@interface ReaderSettingsViewController ()

@property (assign, nonatomic) IBOutlet UISlider *slBrightness;
//@property (retain, nonatomic) IBOutlet UILabel *lblTransitionStyle;
@property (retain, nonatomic) IBOutlet UILabel *lblFont;
@property (retain, nonatomic) ReaderSettings *settings;

@end

@implementation ReaderSettingsViewController

- (instancetype)initWithReaderSettings:(ReaderSettings *)settings
{
	if (self = [super init])
	{
		self.settings = settings;
	}
	
	return self;
}

- (void)dealloc
{
	[_lblFont release];
	//[_lblTransitionStyle release];
	[_settings release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.slBrightness.value = [UIScreen mainScreen].brightness;
	
	[self fillWithData:self.settings];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookReaderSettings];
}

- (void)fillWithData:(ReaderSettings *)settings
{
	//self.lblTransitionStyle.text = settings.transitionName;
	self.lblFont.text = settings.fontName;
}

#pragma mark - Handlers
- (IBAction)brightnessValueChanged:(UISlider *)sender
{
	[[UIScreen mainScreen] setBrightness:sender.value];
}

- (IBAction)btnFontDown_click:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(readerSettingsViewControllerDidDecreaseFontSize:)])
	{
		[self.delegate readerSettingsViewControllerDidDecreaseFontSize:self];
	}
}

- (IBAction)btnFontUp_click:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(readerSettingsViewControllerDidIncreaseFontSize:)])
	{
		[self.delegate readerSettingsViewControllerDidIncreaseFontSize:self];
	}
}

/*- (IBAction)btnTransition_click:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(readerSettingsViewControllerDidPressedTransitionStyleSelection:)])
	{
		[self.delegate readerSettingsViewControllerDidPressedTransitionStyleSelection:self];
	}
}*/

- (IBAction)btnFont_click:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(readerSettingsViewControllerDidPressedFontSelection:)])
	{
		[self.delegate readerSettingsViewControllerDidPressedFontSelection:self];
	}
}

@end
