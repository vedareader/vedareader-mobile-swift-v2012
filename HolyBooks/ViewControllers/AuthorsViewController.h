//
//  AuthorsViewController.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "MainMenuDelegate.h"

@interface AuthorsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) id <MainMenuDelegate> delegate;

@end
