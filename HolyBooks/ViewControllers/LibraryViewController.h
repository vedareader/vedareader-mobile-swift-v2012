//
//  LibraryViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyContentManager.h"
#import "BannerView.h"
#import "SelectLanguageViewController.h"

#import "BaseBookViewController.h"

@interface LibraryViewController : BaseBookViewController <UICollectionViewDataSource, UICollectionViewDelegate, BannerViewDelegate, SelectLanguageDelegate>

@property (retain, nonatomic) BannerView *bvBanners;
@property (retain, nonatomic) HorizontalBookList *hblRecommendations;
@property (retain, nonatomic) UIImageView *imgDivider;

@property (retain, nonatomic) IBOutlet UICollectionView *colBooks;

@end
