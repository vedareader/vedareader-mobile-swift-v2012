//
//  SetMainMenuViewController.h
//  HolyBooks
//
//  Created by Alexander Popov on 22/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectLanguageViewController.h"
#import "MainMenuDelegate.h"

@interface SetMainMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SelectLanguageDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tblSets;
@property (nonatomic, strong) NSArray *dataSets;
@property (nonatomic, assign) id <MainMenuDelegate> delegate;

@end
