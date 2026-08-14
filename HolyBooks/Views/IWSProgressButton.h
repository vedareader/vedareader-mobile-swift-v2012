//
//  IWSProgressButton.h
//  HolyBooks
//
//  Created by Roman Developer on 2/1/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookState.h"

@interface IWSProgressButton : UIButton

- (void)configureForState: (BookState *)bookState;

- (void)setProgress: (CGFloat)progress;

@end
