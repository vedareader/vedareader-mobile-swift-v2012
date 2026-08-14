//
//  MyBooksViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 9/17/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseBookViewController.h"

@interface MyBooksViewController : BaseBookViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (retain, nonatomic) IBOutlet UICollectionView *colBooks;

@property (retain, nonatomic) HorizontalBookList *hblRecommendations;
@property (retain, nonatomic) UIImageView *imgDivider;

@property (retain, nonatomic) IBOutlet UIView *vEmpty;
@property (retain, nonatomic) IBOutlet UILabel *lblEmpty1;
@property (retain, nonatomic) IBOutlet UILabel *lblEmpty2;

@end
