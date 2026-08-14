//
//  ReaderAdditionalSettingsViewController.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 16/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReaderSettings.h"

typedef void (^SettingsActionBlock)(NSString *selectedItem);
typedef void (^SettingsBackActionBlock)(ReaderSettings *settings);

@interface ReaderAdditionalSettingsViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *tblView;

- (instancetype)initWithType:(ReaderSettingType)type settings:(ReaderSettings *)settings actionBlock:(SettingsActionBlock)actionBlock backAction:(SettingsBackActionBlock)backAction;

@end
