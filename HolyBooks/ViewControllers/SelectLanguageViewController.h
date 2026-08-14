//
//  SelectLanguageViewController.h
//  HolyBooks
//
//  Created by Roman Developer on 11/30/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectLanguageView.h"
#import "SelectPageTransitionView.h"

@protocol SelectLanguageDelegate <NSObject>

- (void)selectLanguageCloseSelected;

@end

@interface SelectLanguageViewController : UIViewController <SelectLanguageViewDelegate, SelectPageViewDelegate>

@property (nonatomic, assign) id <SelectLanguageDelegate> delegate;

@property (nonatomic, assign) UIUserInterfaceSizeClass horizontalSizeClass;

//Custom property to get height of navigation bar
@property (nonatomic, retain) UIViewController *parent;

@property (retain, nonatomic) IBOutlet UIView *vContent;
@property (retain, nonatomic) IBOutlet UIImageView *imgTriangle;
@property (retain, nonatomic) IBOutlet UIView *vOptions;
@property (retain, nonatomic) IBOutlet UILabel *lblDescription;
@property (retain, nonatomic) IBOutlet UIView *vPageTransitions;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstLanguagesHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstTransitionsHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cnstLeadingContent;
@property (retain, nonatomic) IBOutlet UILabel *lblPageTransitionDescription;

@property (strong, nonatomic) SelectPageTransitionView *firstTransitionView;
@property (strong, nonatomic) SelectPageTransitionView *secondTransitionView;

- (instancetype)initWithSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass parent:(UIViewController *)parentVC;

- (void)animateIn;
- (void)animateOut:(void (^)())completion;

//- (void)horizontalSizeClassDidSet;

@end
