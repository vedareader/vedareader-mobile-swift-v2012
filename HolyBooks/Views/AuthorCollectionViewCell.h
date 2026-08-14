//
//  AuthorCollectionViewCell.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HolyAuthor.h"

@interface AuthorCollectionViewCell : UICollectionViewCell

- (void)fillWithAuthor:(HolyAuthor *)author;

+ (NSString *)reuseID;
+ (void)registerFor:(UICollectionView *)collectionView;
- (NSString *)reuseIdentifier;

@end
