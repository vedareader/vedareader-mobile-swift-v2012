//
//  BaseBookViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 1/19/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HorizontalBookList.h"
#import "VerticalBookListCollectionViewCell.h"
#import "MainMenuDelegate.h"

@interface BaseBookViewController : UIViewController <HorizontalBookListDelegate, VerticalBookListCellDelegate>

@property (nonatomic, assign) id <MainMenuDelegate> delegate;

@property (nonatomic, assign) UICollectionView *colCollection;

- (void)openBookDetailsForBookID: (NSInteger)bookID;
- (void)makeBookViewerWithBookID: (NSInteger)bookID;

@end
