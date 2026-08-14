//
//  SelectPageTransitionView.m
//  HolyBooks
//
//  Created by Alexander Popov on 27/03/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "SelectPageTransitionView.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"

@implementation SelectPageTransitionView

+ (instancetype)createWithTransition: (NSString *)transitionName isOn: (BOOL)isOn
{
	SelectPageTransitionView *view = (SelectPageTransitionView *)[self createFromNib];
	
	view.imgStatus.hidden = !isOn;
	view.lblTransitionName.text = transitionName;
	
	[view innerInit];
	return view;
}

- (void)innerInit
{
	//Self
	[self constraintHeight:40];
	
	//Label
	[_lblTransitionName alignLeadingWithPadding:0];
	[_lblTransitionName alignCenterYWithPadding:0];
	
	//Switch
	[_imgStatus pinLeadingTo:_lblTransitionName withPadding:15];
	[_imgStatus alignCenterYWithPadding:0];
	[_imgStatus alignTrailingWithPadding:0];
	
	//Divider
	[_imgDivider dockBottom];
	[_imgDivider constraintHeight:1];
}

- (void)dealloc {
    [_lblTransitionName release];
	[_imgDivider release];
    [_imgStatus release];
    [super dealloc];
}

- (void)setSeparatorHidden:(BOOL)value
{
	_imgDivider.hidden = value;
}

- (IBAction)btnChangeStatus_Click:(id)sender
{
	NSInteger value;
	if (_imgStatus.hidden)
		value = 0;
	else
		value = 1;
	[self.delegate valueChanged:self.lblTransitionName.text isOn:value];
}

@end
