//
//  AuthorsCollectionViewLayout.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthorsCollectionViewLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width;

@end

@interface AuthorsCollectionViewLayout : UICollectionViewLayout

@property (assign, nonatomic) id<AuthorsCollectionViewLayoutDelegate> delegate;
@property (retain, nonatomic) NSMutableArray<UICollectionViewLayoutAttributes *> *cache;
@property (assign, nonatomic) CGFloat numberOfColumns;

@end
