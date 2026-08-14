//
//  BookDetailsViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 11/20/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurImageView.h"
#import "BaseBookViewController.h"

@interface BookDetailsViewController : BaseBookViewController <UIScrollViewDelegate>
{
	UIVisualEffectView *visualEffectView;
}
- (instancetype)initWithBookID:(NSInteger)bookID shouldOpenMenu:(BOOL)shouldOpenMenu;
- (instancetype)initWithBookID: (NSInteger)bookID;

//@property (retain, nonatomic) IBOutlet BlurImageView *imgBackground;
@property (retain, nonatomic) IBOutlet UIScrollView *svScroll;
@property (retain, nonatomic) IBOutlet UIImageView *imgBkgr;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstBckgrWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstBckgrHeight;

@end
