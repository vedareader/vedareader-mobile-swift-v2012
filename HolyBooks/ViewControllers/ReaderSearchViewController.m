//
//  ReaderSearchViewController.m
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "ReaderSearchViewController.h"

#import "SearchResultTableViewCell.h"

#import "SearchResultItem.h"

#import "Localization.h"
#import "NSObject+NSNull.h"
#import "UIView+Autolayout.h"

@interface ReaderSearchViewController () <
	UISearchBarDelegate
	,UITableViewDataSource
	,UITableViewDelegate
	,SearchResultTableViewCellDelegate
>

@property (assign, nonatomic) IBOutlet UISearchBar *searchBar;

@property (assign, nonatomic) IBOutlet UIView *vStatus;
@property (assign, nonatomic) IBOutlet NSLayoutConstraint *cStatusHeight;

@property (assign, nonatomic) IBOutlet UILabel *lblSearchStatusTitle;

@property (assign, nonatomic) IBOutlet UILabel *lblSearchStatus;

@property (assign, nonatomic) IBOutlet UITableView *tblSearchResults;

@property (retain, nonatomic) NSMutableArray *searchResults;

@end

@implementation ReaderSearchViewController

- (void)dealloc
{
	[_searchResults release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.vStatus.hidden = YES;
	self.tblSearchResults.hidden = YES;
	
	if (IS_IPAD)
	{
		self.cStatusHeight.constant = 10.0;
	}
	else
	{
		self.cStatusHeight.constant = 18.0;
		self.lblSearchStatusTitle.font = [UIFont systemFontOfSize:14.0];
		self.lblSearchStatus.font = [UIFont systemFontOfSize:14.0];
	}
	
	self.searchResults = [NSMutableArray array];
	
	[SearchResultTableViewCell registerFor:self.tblSearchResults];
	
	self.lblSearchStatusTitle.text = Local(@"SearchResult.StatusTitle");
	self.lblSearchStatus.text = @"";

	self.tblSearchResults.dataSource = self;
	self.tblSearchResults.delegate = self;
	self.tblSearchResults.rowHeight = UITableViewAutomaticDimension;
	self.tblSearchResults.estimatedRowHeight = 50.0;
	
	[self.searchBar becomeFirstResponder];
	self.searchBar.delegate = self;
	
	[self.tblSearchResults reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookReaderSearch];
}

#pragma mark - public
- (void)addSearchResult:(SearchResultItem *)item
{
	NSInteger const count = self.searchResults.count;
	NSInteger insertionIndex = count;
	for (NSInteger i = 0; i < count; ++i)
	{
		SearchResultItem * const currentItem = [self.searchResults objectAtIndex:i];
		if (item.chapterIndex > currentItem.chapterIndex)
		{
			continue;
		}
		
		if (item.pageIndex >= currentItem.pageIndex)
		{
			continue;
		}
		
		insertionIndex = i;
		break;
	}
	
	[self.searchResults insertObject:item atIndex:insertionIndex];
	
	NSString *statusFormat = [Localization textForKey:@"SearchResult.StatusFormat" number:self.searchResults.count];
	self.lblSearchStatus.text = [NSString stringWithFormat:statusFormat, (long)self.searchResults.count];

	[self.tblSearchResults reloadData];
}

- (void)finishSearch
{
	NSString *statusFormat = [Localization textForKey:@"SearchResult.StatusFormat" number:self.searchResults.count];
	self.lblSearchStatus.text = [NSString stringWithFormat:statusFormat, (long)self.searchResults.count];
}

- (void)clearAll
{
	[self.searchResults removeAllObjects];
	[self.tblSearchResults reloadData];
	
	[self finishSearch];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if ([NSObject isEmptyString:searchText])
	{
		return;
	}

	[self clearAll];

	NSLog(@"searchText: %@", searchText);
	
	self.vStatus.hidden = NO;
	self.tblSearchResults.hidden = NO;
	
	self.lblSearchStatus.text = Local(@"SearchResult.StatusSearching");
	
	[self.delegate readerSearchViewController:self searchWithText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self.delegate readerSearchViewControllerCancelSearch:self];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger const result = self.searchResults.count;

	return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SearchResultTableViewCell * const cell = [tableView dequeueReusableCellWithIdentifier:[SearchResultTableViewCell reuseID] forIndexPath:indexPath];
	
	SearchResultItem *item = [self.searchResults objectAtIndex:indexPath.row];
	[cell fillWithData:item];
	
	cell.delegate = self;
	
	return cell;
}

#pragma mark - SearchResultTableViewCellDelegate
- (void)searchResultTableViewCellDidSelect:(SearchResultTableViewCell *)cell
{
	[self.delegate readerSearchViewController:self didSelectSearchResult:cell.searchResult];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
