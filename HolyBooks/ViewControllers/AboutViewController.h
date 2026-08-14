//
//  AboutViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 10/21/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuDelegate.h"

@interface AboutViewController : UIViewController

@property (nonatomic, assign) id <MainMenuDelegate> delegate;

@property (retain, nonatomic) IBOutlet UILabel *lblText;

@end
