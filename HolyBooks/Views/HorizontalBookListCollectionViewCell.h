//
//  HorizontalBookListCollectionViewCell.h
//  HolyBooks
//
//  Created by Roman Developer on 10/28/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyBook.h"

#define kHorizontalBookListCellCompactSize CGSizeMake(77, 162)
#define kHorizontalBookListCellRegularSize CGSizeMake(140, 270)

@interface HorizontalBookListCollectionViewCell : UICollectionViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imgBookCover;
@property (retain, nonatomic) IBOutlet UILabel *lblBookName;
@property (retain, nonatomic) IBOutlet UILabel *lblBookAuthor;

- (void)fillDataWithBook: (HolyBook *)book horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass;

@end
