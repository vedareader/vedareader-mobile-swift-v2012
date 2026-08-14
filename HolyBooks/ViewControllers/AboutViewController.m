//
//  AboutViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 10/21/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "AboutViewController.h"
#import "UIViewController+CustomDraw.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if (@available(iOS 11, *))
	{
	}
	else
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	//Navigation buttons
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"icon_menu" action:@selector(btnMenu_Click:)];
	self.title = Local(@"About.Title");
	
	//About text
	NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:Local(@"About.Text")];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineSpacing = 4;
	[text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
	_lblText.attributedText = text;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenAbout];
}

- (void)dealloc
{
	[_lblText release];
	[super dealloc];
}

#pragma mark - Actions
- (void)btnMenu_Click: (id)sender
{
	[self.delegate mainMenuDidSelected];
}

@end
