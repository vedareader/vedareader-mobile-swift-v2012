//
//  SetMainMenuViewController.m
//  HolyBooks
//
//  Created by Alexander Popov on 22/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "SetMainMenuViewController.h"
#import "HolySet.h"
#import "SetTableViewCell.h"
#import "HolyContentManager.h"
#import "SetDetailsViewController.h"
#import "Settings.h"

#import "UIView+Autolayout.h"
#import "NSArray+LINQ.h"
#import "NSObject+NSNull.h"
#import "AppHelper.h"
#import "UIViewController+CustomDraw.h"
#import "NSString+SizeWithFont.h"
#import "Localization.h"
#import "UIImage+Background.h"

@interface SetMainMenuViewController ()
@property (nonatomic, retain) SelectLanguageViewController *selectLanguageViewController;
@end

@implementation SetMainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"icon_menu" action:@selector(btnMenu_Click:)];
	self.title = Local(@"Sets.Title");
	
	UIImage *icon = [UIImage imageNamed:@"icon_settings_main"];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStylePlain target:self action:@selector(btnLanguage_Click:)];
	
	self.dataSets = [HolyContentManager sharedManager].sets;
	
	[self filterBooks];
	
	[self.tblSets registerClass:[SetTableViewCell class] forCellReuseIdentifier:@"SetTableViewCell"];
	
	self.tblSets.dataSource = self;
	self.tblSets.delegate = self;
	self.tblSets.rowHeight = UITableViewAutomaticDimension;
	self.tblSets.estimatedRowHeight = 320.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_tblSets release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
	[self.tblSets beginUpdates];
	[self.tblSets reloadData];
	//[self.tblSets layoutIfNeeded];
	[self.tblSets endUpdates];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataSets.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SetTableViewCell *cell = /*(SetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell"];*/ [SetTableViewCell create];
	/*if (cell == nil)
	{
		cell = [SetTableViewCell create];
	}*/
	
	//Fill data
	HolySet *curSet = [self.dataSets objectAtIndex:indexPath.row];
	[cell fillWithData:curSet];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SetDetailsViewController *vc = [[SetDetailsViewController alloc] init];//initWithSet:self.dataSets[indexPath.row]];
	//[vc loadViewIfNeeded];
	//Cheat to make outlets to load
	vc.view;
	[vc fillWithSet:self.dataSets[indexPath.row]];
	[self.navigationController pushViewController:vc animated:true];
}

/*#pragma mark - MainMenuDelegate
- (void)selectLanguageCloseSelected
{
	//Start main menu
	[self.delegate mainMenuResumeInteracting];
	
	//Hide language controller
	[_selectLanguageViewController animateOut:^{
		[_selectLanguageViewController.view removeFromSuperview];
		self.selectLanguageViewController = nil;
		
		[self filterBooks];
		
		[_hblRecommendations fillWithType:HorizontalBookListTypeRecommendation horizontalSizeClass:self.traitCollection.horizontalSizeClass];
		[_colBooks reloadData];
	}];
}*/

#pragma mark - MainMenuDelegate
- (void)selectLanguageCloseSelected
{
	//Start main menu
	[self.delegate mainMenuResumeInteracting];
	
	//Hide language controller
	[_selectLanguageViewController animateOut:^{
		[_selectLanguageViewController.view removeFromSuperview];
		self.selectLanguageViewController = nil;
		
		[self filterBooks];
		
		[_tblSets reloadData];
	}];
}

- (void)filterBooks
{
	//Original version
	NSMutableArray <NSNumber *> *selectedLanguages = [NSMutableArray array];
	for (HolyLanguage *language in [HolyContentManager sharedManager].languages)
	{
		if ([[Settings sharedSettings] languageOnWithID:language.identity])
			[selectedLanguages addObject:@(language.identity)];
	}
	
	self.dataSets = [NSMutableArray arrayWithArray:[[HolyContentManager sharedManager].sets where:@"languageID IN (%@)", selectedLanguages]];
}

#pragma mark - Actions
- (void)btnMenu_Click: (id)sender
{
	[self.delegate mainMenuDidSelected];
}

- (void)btnLanguage_Click: (id)sender
{
	//Stop main menu
	[self.delegate mainMenuStopInteracting];
	
	//Show language controller
	if (_selectLanguageViewController == nil)
	{
		_selectLanguageViewController = [[SelectLanguageViewController alloc] initWithSizeClass:self.traitCollection.horizontalSizeClass parent:self.navigationController];
		_selectLanguageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
		_selectLanguageViewController.delegate = self;
	}
	else
		//Custom property to get height of navigation bar
		_selectLanguageViewController.parent = self.navigationController;

	[self.navigationController.view addSubview:_selectLanguageViewController.view];
	[_selectLanguageViewController.view dockAll];
	[_selectLanguageViewController animateIn];
}

@end
