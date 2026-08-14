//
//  MainMenuTableViewCell.h
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Enums.h"

@interface MainMenuTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;

+ (instancetype)create;

- (void)fillDataWithMainMenuItem: (MainMenuItem)mainMenuItem horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass;

@end
