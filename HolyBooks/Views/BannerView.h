//
//  BannerView.h
//  HolyBooks
//
//  Created by Roman Developer on 10/21/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
//439
//#define kBannerHeight ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? (IS_IPHONE_5 ? 137 : (IS_IPHONE_6 ? 160 : 177)) : 329)

#define kImageSize CGSizeMake(1242, 532)

@protocol BannerViewDelegate <NSObject>

- (void)bannerDidSelected: (NSInteger)index;

@end

IB_DESIGNABLE
@interface BannerView : UIView

@property (nonatomic, retain) NSArray *images;

@property (nonatomic, assign) id <BannerViewDelegate> delegate;

+ (CGFloat)heightForWidth: (CGFloat)width;

@end
