//
//  SetDetailsViewController.m
//  HolyBooks
//
//  Created by Alexander Popov on 23/06/2017.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "SetDetailsViewController.h"
#import "VerticalBookListCollectionViewCell.h"
#import "HolyBook.h"
#import "HolyContentManager.h"
#import "BookInfoTableViewCell.h"

#import "UIViewController+CustomDraw.h"
#import "UIView+Autolayout.h"
#import "UIImage+Background.h"
#import "NSArray+LINQ.h"
#import "NSObject+NSNull.h"
#import "AppHelper.h"

@interface SetDetailsViewController ()

@end

@implementation SetDetailsViewController

- (instancetype)initWithSet:(HolySet *)newSet
{
	if ((self = [super init]))
	{
		self.curSet = newSet;
		self.books = [HolyBook getByPackageID:newSet.identity];
	}
	
	return self;
}

- (void)fillWithSet:(HolySet *)newSet
{
	self.curSet = newSet;
	self.books = [HolyBook getByPackageID:newSet.identity];
	
	self.title = self.curSet.name;
	self.lblSetDescription.text = self.curSet.desc;
	
	self.tblBooks.delegate = self;
	self.tblBooks.dataSource = self;
	
	self.cnstTableHeight.constant = 155.0 * self.books.count;
	
	[self.tblBooks reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.imgBackgorund.image = [UIImage backgroundImage];
	
	__block typeof(self) _self = self;
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"arrow_back" actionBlock:^{
		[_self.navigationController popViewControllerAnimated:YES];
	}];
	
	self.tblBooks.dataSource = self;
	self.tblBooks.delegate = self;
}

- (void)dealloc
{
    [_vContentView release];
    [_lblSetDescription release];
	[_imgBackgorund release];
    //[_colBooks release];
	[_tblBooks release];
	[_cnstTableHeight release];
    [super dealloc];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
	[self.tblBooks reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.books.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BookInfoTableViewCell *cell = /*(SetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell"];*/ [BookInfoTableViewCell create];
	cell.delegate = self;
	/*if (cell == nil)
	 {
		cell = [SetTableViewCell create];
	 }*/
	
	//Fill data
	[cell fillWithData:self.books[indexPath.row] position:(indexPath.row + 1)];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*SetDetailsViewController *vc = [[SetDetailsViewController alloc] init];//initWithSet:self.dataSets[indexPath.row]];
	[vc loadViewIfNeeded];
	[vc fillWithSet:self.books[indexPath.row]];
	[self.navigationController pushViewController:vc animated:true];*/
}

#pragma mark - Download updates
- (void)updateForDownloadCompletedWithBookID: (NSInteger)bookID
{
	for (BookInfoTableViewCell *cell in _tblBooks.visibleCells)
	{
		if (cell.curBook.identity == bookID)
		{
			[_tblBooks beginUpdates];
			[_tblBooks reloadData];
			[_tblBooks endUpdates];
			//[_tblBooks reloadItemsAtIndexPaths:@[ [_tblBooks indexPathForCell:cell] ]];
		}
	}
}

- (void)updateForDownloadProgressWithBookID: (NSInteger)bookID
{
	for (BookInfoTableViewCell *cell in _tblBooks.visibleCells)
	{
		if (cell.curBook.identity == bookID)
		{
			[_tblBooks beginUpdates];
			[cell updateDownloadState];
			[_tblBooks endUpdates];
		}
	}
}

@end
