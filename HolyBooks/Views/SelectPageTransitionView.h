//
//  SelectPageTransitionView.h
//  HolyBooks
//
//  Created by Alexander Popov on 27/03/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPageViewDelegate <NSObject>
	
- (void)valueChanged:(NSString *)transitionName isOn:(NSInteger)isOn;
	
@end

@interface SelectPageTransitionView : UIView
	
@property (nonatomic, assign) id <SelectPageViewDelegate> delegate;
	
@property (retain, nonatomic) IBOutlet UILabel *lblTransitionName;
@property (retain, nonatomic) IBOutlet UIImageView *imgDivider;
@property (retain, nonatomic) IBOutlet UIImageView *imgStatus;

- (IBAction)btnChangeStatus_Click:(id)sender;
+ (instancetype)createWithTransition: (NSString *)transitionName isOn: (BOOL)isOn;
- (void)setSeparatorHidden:(BOOL)value;

@end
