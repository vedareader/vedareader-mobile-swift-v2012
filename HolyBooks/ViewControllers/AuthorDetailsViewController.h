//
//  AuthorDetailsViewController.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 20/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurImageView.h"
#import "BaseBookViewController.h"

@interface AuthorDetailsViewController : BaseBookViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithAuthorID:(NSInteger)authorID shouldOpenMenu:(BOOL)shouldOpenMenu;
- (instancetype)initWithAuthorID:(NSInteger)authorID;

@property (retain, nonatomic) UIView *imgBackground;
@property (retain, nonatomic) UIScrollView *svScroll;

@end
