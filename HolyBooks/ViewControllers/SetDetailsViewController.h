//
//  SetDetailsViewController.h
//  HolyBooks
//
//  Created by Alexander Popov on 23/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolySet.h"
#import "VerticalBookListCollectionViewCell.h"
#import "BaseBookViewController.h"

@interface SetDetailsViewController : BaseBookViewController <UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *vContentView;
@property (retain, nonatomic) IBOutlet UILabel *lblSetDescription;
@property (retain, nonatomic) IBOutlet UIImageView *imgBackgorund;
@property (retain, nonatomic) IBOutlet UITableView *tblBooks;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstTableHeight;

@property (retain, nonatomic) NSArray *books;
@property (retain, nonatomic) HolySet *curSet;

- (instancetype)initWithSet:(HolySet *)newSet;
- (void)fillWithSet:(HolySet *)newSet;

@end
