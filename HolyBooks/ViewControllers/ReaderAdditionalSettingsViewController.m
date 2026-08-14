//
//  ReaderAdditionalSettingsViewController.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 16/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "ReaderAdditionalSettingsViewController.h"
#import "ReaderAdditionalSettingsTableViewCell.h"
#import "BookReaderViewController.h"
#import "UIViewController+CustomDraw.h"
#import "Enums.h"

@interface ReaderAdditionalSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) ReaderSettings *settings;
@property (assign, nonatomic) ReaderSettingType type;
//@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) NSArray *dataArr;
@property (copy, nonatomic) SettingsActionBlock actionBlock;
@property (copy, nonatomic) SettingsBackActionBlock backAction;

@end

@implementation ReaderAdditionalSettingsViewController

- (instancetype)initWithType:(ReaderSettingType)type settings:(ReaderSettings *)settings actionBlock:(SettingsActionBlock)actionBlock backAction:(SettingsBackActionBlock)backAction
{
	if (self = [super init])
	{
		self.settings = settings;
		self.type = type;
		self.actionBlock = actionBlock;
		self.backAction = backAction;
		if (type == ReaderSettingTypeFont)
		{
			self.dataArr = @[
							 @"Arial",
							 @"Verdana",
							 @"HelveticaNeue",
							 @"Baskerville",
							 @"Georgia",
							 @"TimesNewRomanPSMT"];
		}
		else
		{
			self.dataArr = @[
							 Local(@"BookReader.TransitionStyle.Flipping"),
							 Local(@"BookReader.TransitionStyle.Shift")
							 ];
		}
	}
	
	return self;
}

- (void)dealloc
{
	[_settings release];
	[_tblView release];
	[_dataArr release];
	[_actionBlock release];
	[_backAction release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationController.navigationBar setTitleTextAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium],
																	   }];
	
	self.title = self.type == ReaderSettingTypeFont ? Local(@"ReaderSettings.Fonts.Title") : Local(@"ReaderSettings.TransitionStyle.Title");
	
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"arrow_back" action:@selector(btnBack_click:)];
	
	[ReaderAdditionalSettingsTableViewCell registerFor:self.tblView];
	
	//Don't show default separator in not filled cells
	self.tblView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookReaderAdditionalSettings];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ReaderAdditionalSettingsTableViewCell *cell = (ReaderAdditionalSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[ReaderAdditionalSettingsTableViewCell reuseID] forIndexPath:indexPath];
	
	if (!cell)
		cell = [[[ReaderAdditionalSettingsTableViewCell alloc] init] autorelease];
	
	if ([self.dataArr[indexPath.row] isEqualToString:self.settings.transitionName] ||
		[self.dataArr[indexPath.row] isEqualToString:self.settings.fontName])
	{
		[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	}
	
	[cell fillWithTitle:self.dataArr[indexPath.row] type:self.type];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *selectedItem = self.dataArr[indexPath.row];
	
	if (self.type == ReaderSettingTypeFont)
		self.settings.fontName = selectedItem;
	else
		self.settings.transitionName = selectedItem;
	
	if (self.actionBlock)
		self.actionBlock(selectedItem);
}

#pragma mark - Handlers
- (IBAction)btnBack_click:(id)sender
{
	[self.navigationController setNavigationBarHidden:YES];
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	self.backAction(self.settings);
}

@end
