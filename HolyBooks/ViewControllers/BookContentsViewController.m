//
//  BookContentsViewController.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 05/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "BookContentsViewController.h"

#import "ContentsTableViewCell.h"

#import "ChapterDescription.h"

#import "UIViewController+CustomDraw.h"

@interface BookContentsViewController () <UITableViewDataSource, UITableViewDelegate, ContentsTableViewCellDelegate>

@property (retain, nonatomic) ReflowableViewController *rv;
@property (retain, nonatomic) NSArray *chapters;
@property (assign, nonatomic) IBOutlet UILabel *lblTitle;
@property (assign, nonatomic) IBOutlet UITableView *tblContents;

@end

@implementation BookContentsViewController

- (instancetype)initWithBookViewController:(ReflowableViewController *)controller chapters:(NSArray *)chapters
{
	self = [super init];
	if (self == nil)
	{
		return nil;
	}
	
	self.rv = controller;
	self.chapters = chapters;
	
	return self;
}

- (void)dealloc
{
	[_rv release];
	[_chapters release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.title = Local(@"BookContents.Title");
	
	if (@available(iOS 11, *))
	{
	}
	else
		self.edgesForExtendedLayout = UIRectEdgeNone;
	
	self.lblTitle.text = self.rv.book.title;
	
	[ContentsTableViewCell registerFor:self.tblContents];
	
	self.tblContents.dataSource = self;
	self.tblContents.delegate = self;
	self.tblContents.rowHeight = UITableViewAutomaticDimension;
	self.tblContents.estimatedRowHeight = 36.0;
	
	//Back button
	__block typeof(self) _self = self;
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"arrow_back" actionBlock:^{
		[_self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookContents];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger const result = self.chapters.count;
	
	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ContentsTableViewCell * const cell = [tableView dequeueReusableCellWithIdentifier:[ContentsTableViewCell reuseID] forIndexPath:indexPath];
	ChapterDescription * const chapterDescription = [self.chapters objectAtIndex:indexPath.row];
	[cell fillWithDescription:chapterDescription];
	
	cell.delegate = self;
	
	return cell;
}

#pragma mark - ContentsTableViewCellDelegate
- (void)contentsTableViewCellDidSelect:(ContentsTableViewCell *)cell
{
	if ([self.delegate respondsToSelector:@selector(bookContentsViewController:didSelectChapter:)])
	{
		ChapterDescription * const chapterDescription = cell.chapterDescription;
		[self.delegate bookContentsViewController:self didSelectChapter:chapterDescription.index];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
