//
//  MainMenuTableViewCell.m
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "MainMenuTableViewCell.h"
#import "UIView+Create.h"
#import "UIView+Autolayout.h"

@interface MainMenuTableViewCell ()

@property (nonatomic, retain) NSLayoutConstraint *cLeading;

@end

@implementation MainMenuTableViewCell

+ (instancetype)create
{
	MainMenuTableViewCell *cell = (MainMenuTableViewCell *)[self createFromNib];
	cell.backgroundColor = [UIColor clearColor];	//iPad fix
	[cell innerInit];
	return cell;
}

- (void)innerInit
{
	[_lblTitle alignCenterYWithPadding:0];
	self.cLeading = [_lblTitle alignLeadingWithPadding:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	if (selected)
		self.backgroundColor = kColorLightGrey;
	else
		self.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
	[_cLeading release];
    [_lblTitle release];
    [super dealloc];
}

#pragma mark - Functionality
- (void)fillDataWithMainMenuItem: (MainMenuItem)mainMenuItem horizontalSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass
{
	switch (mainMenuItem)
	{
		case MainMenuItemLibrary:
			_lblTitle.text = Local(@"MainMenu.Library");
			break;
		case MainMenuItemMyBooks:
			_lblTitle.text = Local(@"MainMenu.MyBooks");
			break;
		case MainMenuItemAbout:
			_lblTitle.text = Local(@"MainMenu.About");
			break;
		case MainMenuItemAuthors:
			_lblTitle.text = Local(@"MainMenu.Authors");
			break;
		case MainMenuItemSet:
			_lblTitle.text = Local(@"MainMenu.Set");
			break;
		default:
			NSLog(@"Main menu item not defined: %u", mainMenuItem);
			break;
	}
	
	if (horizontalSizeClass == UIUserInterfaceSizeClassRegular)
		_cLeading.constant = 24; //10;
	else
		_cLeading.constant = 24;
}

@end
