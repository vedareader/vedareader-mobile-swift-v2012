//
//  ReaderAdditionalSettingsTableViewCell.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 16/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "ReaderSettings.h"

@interface ReaderAdditionalSettingsTableViewCell : BaseTableViewCell

- (void)fillWithTitle:(NSString *)title type:(ReaderSettingType)type;

@end
