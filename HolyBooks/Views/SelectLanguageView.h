//
//  SelectLanguageView.h
//  HolyBooks
//
//  Created by Roman Developer on 1/21/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyLanguage.h"

@protocol SelectLanguageViewDelegate <NSObject>

- (void)valueSelectedWithLanguageID: (NSInteger)languageID isOn: (BOOL)isOn;
- (void)displayLanguageSelectionError;

@end

@interface SelectLanguageView : UIView

@property (nonatomic, assign) id <SelectLanguageViewDelegate> delegate;

@property (retain, nonatomic) IBOutlet UILabel *lblText;
@property (retain, nonatomic) IBOutlet UIImageView *imgDivider;
@property (retain, nonatomic) IBOutlet UISwitch *swSwitch;

+ (instancetype)createWithLanguage: (HolyLanguage *)language isOn: (BOOL)isOn;

- (IBAction)swSwitch_ValueChanged:(id)sender;
- (void)setSeparatorHidden:(BOOL)value;

@end
