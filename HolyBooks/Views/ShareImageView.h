//
//  ShareImageView.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 27/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareData.h"

@interface ShareImageView : UIView

- (instancetype)initWithShareData:(ShareData *)shareData;
- (UIImage *)renderedImage;

@end
