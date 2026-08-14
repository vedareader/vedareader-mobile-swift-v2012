//
//  MainMenuViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuDelegate.h"

@interface MainMenuViewController : UIViewController <MainMenuDelegate>
{
	NSInteger curSelection;
}

@property (retain, nonatomic) IBOutlet UITableView *tblMenu;

@end
