//
//  HorizontalBookList.h
//  HolyBooks
//
//  Created by Roman Developer on 10/29/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHorizontalBookListHeight ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? kHorizontalBookListCompactHeight : kHorizontalBookListRegularHeight)
#define kHorizontalBookListCompactHeight 202
#define kHorizontalBookListRegularHeight 310

typedef enum
{
	HorizontalBookListTypeRecommendation,
	HorizontalBookListTypeAuthor,
	HorizontalBookListTypeMyLatest
} HorizontalBookListType;

@protocol HorizontalBookListDelegate <NSObject>

- (void)bookDidSelected: (NSInteger)bookID;

@end

@interface HorizontalBookList : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) id <HorizontalBookListDelegate> delegate;
@property (nonatomic, assign) NSInteger authorID;
@property (nonatomic, assign) NSInteger excludeBookID;

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UICollectionView *colBooks;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cCollectionViewHeight;

@property (nonatomic, assign) UIUserInterfaceSizeClass horizontalSizeClass;

+ (instancetype)create;
- (void)fillWithType: (HorizontalBookListType)type horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass;

@end
