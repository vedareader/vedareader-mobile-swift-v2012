//
//  ReaderSettingsViewController.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderSettings.h"

@class ReaderSettingsViewController;

@protocol ReaderSettingsViewControllerDelegate <NSObject>

@optional
- (void)readerSettingsViewControllerDidIncreaseFontSize:(ReaderSettingsViewController *)controller;

- (void)readerSettingsViewControllerDidDecreaseFontSize:(ReaderSettingsViewController *)controller;

- (void)readerSettingsViewControllerDidPressedFontSelection:(ReaderSettingsViewController *)controller;
- (void)readerSettingsViewControllerDidPressedTransitionStyleSelection:(ReaderSettingsViewController *)controller;

@end

@interface ReaderSettingsViewController : UIViewController

@property (assign, nonatomic) id<ReaderSettingsViewControllerDelegate> delegate;

- (instancetype)initWithReaderSettings:(ReaderSettings *)settings;
- (void)fillWithData:(ReaderSettings *)settings;

@end
