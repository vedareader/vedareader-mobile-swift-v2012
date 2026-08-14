//
//  MainMenuViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 10/20/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuTableViewCell.h"
#import "LibraryViewController.h"
#import "MyBooksViewController.h"
#import "AuthorsViewController.h"
#import "AboutViewController.h"
#import "MenuSearchResultTableViewCell.h"
#import "UIView+Autolayout.h"
#import "UIImage+Background.h"
#import "NSArray+LINQ.h"

#import "AuthorDetailsViewController.h"
#import "BookDetailsViewController.h"
#import "SetMainMenuViewController.h"
#import "HolyBook.h"
#import "HolyAuthor.h"

#define kMenuDuration 0.3
#define kVelocitySensivity 200
#define kPanelOpenX ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) ? (self.view.bounds.size.width - 70) : 300)
#define kPanelOpenY (54 * 3)

@interface MainMenuViewController () <UISearchBarDelegate>
{
	CGPoint _beforePan;
	BOOL _searchIsActive;
}

@property (nonatomic, retain) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UIViewController *activeViewController;
@property (nonatomic, retain) NSLayoutConstraint *cTop;
@property (nonatomic, retain) NSLayoutConstraint *cLeading;
@property (nonatomic, strong) UIButton *largeButton;

@property (nonatomic, assign) BOOL isInteracting;

@property (nonatomic, retain) NSLayoutConstraint *cSearchViewWidth;
@property (nonatomic, retain) NSArray *foundItems;
@property (nonatomic, retain) UISearchBar *searchBar;

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_isInteracting = YES;
	
	_tblMenu.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);

	//Background
	_tblMenu.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage menuBackgroundImage]] autorelease];
	
	_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer_DidPan:)];
	[self.view addGestureRecognizer:_panGestureRecognizer];
	[_panGestureRecognizer release];
	
	//NSLog(@"Main menu viewDidLoad");
	self.tblMenu.tableHeaderView = [self setupSearchView];
	
	[MenuSearchResultTableViewCell registerFor:self.tblMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.activeViewController == nil)
	{
		//Default controller
		[_tblMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:MainMenuItemLibrary inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		[self showViewControllerForMainMenuItem:MainMenuItemLibrary];
		curSelection = 2;
	}
	
	//NSLog(@"Main menu viewWillAppear");
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.activeViewController.view.widthConstraint.constant = self.view.bounds.size.width;
	self.activeViewController.view.heightConstraint.constant = self.view.bounds.size.height;
	
	[_tblMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:curSelection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[self moveToX:0 withVelocity:0];
	
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
//{
//	[super traitCollectionDidChange:previousTraitCollection];
//	
//	[self.view layoutIfNeeded];
//
//	NSLog(@"traitCollectionDidChange");
//}

- (void)dealloc
{
	[_tblMenu release];
	[_cSearchViewWidth release];
	[_foundItems release];
	[_searchBar release];
	
	[super dealloc];
}

#pragma mark - Functionality
- (void)showViewControllerForMainMenuItem: (MainMenuItem)mainMenuItem
{
	//Remove old
	if (self.activeViewController != nil)
	{
		[self.activeViewController.view removeFromSuperview];
		[self.activeViewController removeFromParentViewController];
		self.activeViewController = nil;
	}
	
	//Show new
	switch (mainMenuItem)
	{
		case MainMenuItemLibrary:
		{
			[self switchToController:[LibraryViewController class]];
			break;
		}
		case MainMenuItemMyBooks:
		{
			[self switchToController:[MyBooksViewController class]];
			break;
		}
		case MainMenuItemAbout:
		{
			[self switchToController:[AboutViewController class]];
			break;
		}
		case MainMenuItemAuthors:
		{
			[self switchToController:[AuthorsViewController class]];
			break;
		}
		case MainMenuItemSet:
		{
			[self switchToController:[SetMainMenuViewController class]];
			break;
		}
			
		default:
			NSLog(@"Main menu item not defined: %u", mainMenuItem);
			break;
	}
}

- (void)switchToController: (Class)controllerClass
{
	UIViewController *viewController = [[controllerClass alloc] init];
	[viewController performSelector:@selector(setDelegate:) withObject:self afterDelay:0];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

	[self.view addSubview:navigationController.view];
	[self addChildViewController:navigationController];
	self.activeViewController = navigationController;
	
	//Dirty fix, as nav controller doesn't add 20 pixels if not near status bar
//	if (_cTop.constant == kPanelOpenY)
//	{
//		viewController.view.frame = CGRectSetY(viewController.view.frame, 200);
//	}
	
	[self configureConstraintsForActiveView:navigationController.view];
	[self addShadowForView:navigationController.view];
	
//	if ([viewController conformsToProtocol:@protocol(UIGestureRecognizerDelegate)])
//		_panGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)viewController;
	
	[viewController release];
	[navigationController release];
}

- (void)configureConstraintsForActiveView: (UIView *)activeView
{
	activeView.translatesAutoresizingMaskIntoConstraints = NO;
	self.cTop = [activeView alignTopWithPadding:self.cTop.constant];
	self.cLeading = [activeView alignLeadingWithPadding:self.cLeading.constant];
	//[activeView alignTrailingWithPadding:0];
	[activeView constraintWidth:self.view.frame.size.width];
	//[activeView alignBottomWithPadding:0];
	[activeView constraintHeight:self.view.frame.size.height];
}

- (void)addShadowForView: (UIView *)view
{
	UIImageView *imgShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_shadow.png"]];
	imgShadow.translatesAutoresizingMaskIntoConstraints = NO;
	[view addSubview:imgShadow];
	[imgShadow alignLeadingWithPadding:-3];
	[imgShadow alignTopWithPadding:0];
	[imgShadow alignBottomWithPadding:0];
	[imgShadow release];
}

- (UIView *)setupSearchView
{
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kPanelOpenX, 53.0)] autorelease];
	
	//Search bar
	[[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:RGB(3, 3, 3)];
	[[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setBackgroundColor:RGB(88, 87, 87)];
	[[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:16] } forState:UIControlStateNormal];
	
	UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
	searchBar.translatesAutoresizingMaskIntoConstraints = NO;
	searchBar.backgroundImage = [UIImage new];
	searchBar.placeholder = Local(@"MainMenu.Search.Placeholder");
	
	UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
	txfSearchField.backgroundColor = RGBA(255, 255, 255, 0.2);
	
	searchBar.delegate = self;
	
	[view addSubview:searchBar];
	
	[searchBar alignTopWithPadding:0.0];
	[searchBar alignLeadingWithPadding:14.0];
	[searchBar alignBottomWithPadding:0.0];
	self.cSearchViewWidth = [searchBar constraintWidth:kPanelOpenX - 28.0];
	
	self.searchBar = searchBar;
	
	return view;
}

- (void)trackGAForClass:(MainMenuItem)menuItem
{
	switch (menuItem)
	{
		case MainMenuItemLibrary:
		{
			[GAHelper logEventWithCategory:kCategoryMenu action:kActionLibrary];
			break;
		}
		case MainMenuItemMyBooks:
		{
			[GAHelper logEventWithCategory:kCategoryMenu action:kActionMyBooks];
			break;
		}
		case MainMenuItemAbout:
		{
			[GAHelper logEventWithCategory:kCategoryMenu action:kActionAbout];
			break;
		}
		case MainMenuItemAuthors:
		{
			[GAHelper logEventWithCategory:kCategoryMenu action:kActionAuthors];
			break;
		}
		case MainMenuItemSet:
		{
			[GAHelper logEventWithCategory:kCategoryMenu action:kActionSets];
			break;
		}
		default:
			break;
	}
}

#pragma mark - Search
- (void)switchOffSearch
{
	[self mainMenuResumeInteracting];
	
	[self.searchBar endEditing:YES];
	
	_searchIsActive = NO;
	
	UITextField *txfSearchField = [self.searchBar valueForKey:@"_searchField"];
	txfSearchField.backgroundColor = RGBA(255, 255, 255, 0.2);
	
	[self.searchBar setShowsCancelButton:NO animated:NO];
	[self moveToX:kPanelOpenX withVelocity:0];
	
	self.cSearchViewWidth.constant = kPanelOpenX - 28.0;
	[UIView animateWithDuration:kMenuDuration animations:^{
		[self.tblMenu layoutIfNeeded];
	}];
	
	_searchIsActive = NO;
	self.searchBar.text = @"";
	[self.tblMenu reloadData];
	[_tblMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:curSelection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)showViewControllerForSearchItem:(id)searchItem
{
	//Remove old
	if (self.activeViewController != nil)
	{
		[self.activeViewController.view removeFromSuperview];
		[self.activeViewController removeFromParentViewController];
		self.activeViewController = nil;
	}
	
	UIViewController *vc = nil;
	if ([searchItem isKindOfClass:[HolyBook class]])
		vc = [[[BookDetailsViewController alloc] initWithBookID:((HolyBook *)searchItem).identity shouldOpenMenu:YES] autorelease];
	else
		vc = [[[AuthorDetailsViewController alloc] initWithAuthorID:((HolyAuthor *)searchItem).identity shouldOpenMenu:YES] autorelease];
	
	[vc performSelector:@selector(setDelegate:) withObject:self afterDelay:0];
	
	UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	[self.view addSubview:navigationController.view];
	[self addChildViewController:navigationController];
	self.activeViewController = navigationController;
	
	[self configureConstraintsForActiveView:navigationController.view];
	[self addShadowForView:navigationController.view];
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[self mainMenuStopInteracting];
	
	UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
	txfSearchField.backgroundColor = [UIColor whiteColor];
	
	[self moveToX:self.view.bounds.size.width withVelocity:0];
	
	[searchBar setShowsCancelButton:YES animated:YES];
	
	self.cSearchViewWidth.constant = self.view.bounds.size.width - 28.0;
	[UIView animateWithDuration:kMenuDuration animations:^{
		[self.tblMenu layoutIfNeeded];
	}];
	
	return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	//[self mainMenuResumeInteracting];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self switchOffSearch];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
	if (searchText.length < 3)
	{
		self.foundItems = [NSArray array];
		[self.tblMenu reloadData];
		
		return;
	}
	_searchIsActive = YES;
	
	NSArray *books = [[HolyContentManager sharedManager] books];
	NSArray *authors = [[HolyContentManager sharedManager] authors];
	NSMutableArray *searchData = [NSMutableArray arrayWithArray:books];
	[searchData addObjectsFromArray:authors];
	
	self.foundItems = [searchData where:@"name contains[c] %@", searchText];
	
	//NSLog(@"foundItems: %@", self.foundItems);
	
	[self.tblMenu reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar endEditing:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_searchIsActive)
		return self.foundItems.count;
	else
		return MainMenuItemMAX;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	if (!_searchIsActive)
	{
		static NSString *CellIdentifier = @"MainMenuTableViewCell";
		
		cell = (MainMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
		{
			cell = [MainMenuTableViewCell create];
		}
		
		//Fill data
		[(MainMenuTableViewCell *)cell fillDataWithMainMenuItem:(MainMenuItem)indexPath.row horizontalSizeClass:self.traitCollection.horizontalSizeClass];
	}
	else
	{
		cell = (MenuSearchResultTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[MenuSearchResultTableViewCell reuseID] forIndexPath:indexPath];
		id item = self.foundItems[indexPath.row];
		
		[(MenuSearchResultTableViewCell *)cell fillWithItem:item];
		
		cell.backgroundColor = [UIColor clearColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_searchIsActive)
	{
		[self.searchBar endEditing:YES];
		id item = self.foundItems[indexPath.row];
		[self showViewControllerForSearchItem:item];
		[self moveToX:0 withVelocity:0];
	}
	else
	{
		[self switchOffSearch];
		[self showViewControllerForMainMenuItem:(MainMenuItem)indexPath.row];
		[self performSelector:@selector(mainMenuDidSelected) withObject:nil afterDelay:0.01];
		
		curSelection = indexPath.row;
		[_tblMenu selectRowAtIndexPath:[NSIndexPath indexPathForRow:curSelection inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		//GA
		[self trackGAForClass:(MainMenuItem)indexPath.row];
	}
}

#pragma mark - MainMenuDelegate
- (void)mainMenuDidSelected
{
//	if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular)
//		[self moveToY:(kPanelOpenY - _cTop.constant) withVelocity:0];
//	else
		[self moveToX:(kPanelOpenX - _cLeading.constant) withVelocity:0];
		
	self.cSearchViewWidth.constant = kPanelOpenX - 28.0;
	[UIView animateWithDuration:kMenuDuration animations:^{
		[self.tblMenu layoutIfNeeded];
	}];
}

- (void)mainMenuStopInteracting
{
	self.isInteracting = NO;
}

- (void)mainMenuResumeInteracting
{
	self.isInteracting = YES;
}

- (void)mainMenuOpenSearchResults
{
	[self moveToX:self.view.bounds.size.width withVelocity:0];
	
	self.cSearchViewWidth.constant = self.view.bounds.size.width - 28.0;
	[UIView animateWithDuration:kMenuDuration animations:^{
		[self.tblMenu layoutIfNeeded];
	}];
}

#pragma mark - Pan
- (void)panGestureRecognizer_DidPan: (UIPanGestureRecognizer *)gestureRecognizer
{
	if (!_isInteracting)
		return;
	
	switch (gestureRecognizer.state)
	{
		case UIGestureRecognizerStateBegan:
			_beforePan = [gestureRecognizer locationInView:self.view];
			_beforePan.x -= _cLeading.constant;
			_beforePan.y -= _cTop.constant;
			//NSLog(@"Began");
			break;
		case UIGestureRecognizerStateChanged:
		{
			//NSLog(@"Changed");
			CGPoint currentPan = [gestureRecognizer locationInView:self.view];
			
			//if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
			{
				CGFloat delta = currentPan.x - _beforePan.x;
				_cLeading.constant = delta;
				if (_cLeading.constant < 0)
					_cLeading.constant = 0;
			}
//			else
//			{
//				CGFloat delta = currentPan.y - _beforePan.y;
//				_cTop.constant = delta;
//				if (_cTop.constant < 0)
//					_cTop.constant = 0;
//				if (_cTop.constant > kPanelOpenY * 2)
//					_cTop.constant = kPanelOpenY * 2;
//			}
			
			break;
		}
		case UIGestureRecognizerStateEnded:
			//NSLog(@"Ended");
		{
			CGPoint velocity = [gestureRecognizer velocityInView:self.view];
			NSLogPoint(velocity);
			
			//if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
			{
				CGFloat shouldX = 0;
				
				//Analyze velocity first
				if (fabs(velocity.x) > kVelocitySensivity)
					shouldX = (velocity.x > 0) ? kPanelOpenX : 0;
				else	//Then proximity
					shouldX = (_cLeading.constant < kPanelOpenX - _cLeading.constant) ? 0 : kPanelOpenX;
				
				//Move to
				[self moveToX:shouldX withVelocity:(velocity.x / 50.0f)];
			}
//			else
//			{
//				CGFloat shouldY = 0;
//				
//				//Analyze velocity first
//				if (fabs(velocity.y) > kVelocitySensivity)
//					shouldY = (velocity.y > 0) ? kPanelOpenY : 0;
//				else	//Then proximity
//					shouldY = (_cTop.constant < kPanelOpenY - _cTop.constant) ? 0 : kPanelOpenY;
//				
//				//Move to
//				[self moveToY:shouldY withVelocity:(velocity.y / 50.0f)];
//			}
			
			break;
		}
		case UIGestureRecognizerStateCancelled:
			NSLog(@"Cancelled");
			
			break;
			
		default:
			NSLog(@"Not implemented");
			break;
	}
}

- (void)moveToX: (CGFloat)x withVelocity: (CGFloat)velocity
{
	//Large button
	if (x == kPanelOpenX)
		[self addLargeButton];
	else
		[self removeLargeButton];
	
	//Move
	[UIView animateWithDuration:kMenuDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseIn animations:^{
		_cLeading.constant = x;
		[self.view layoutIfNeeded];
	} completion:^(BOOL finished) {
		
	}];
}

- (void)addLargeButton
{
	if (self.largeButton != nil)
		return;
	
	self.largeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.largeButton.translatesAutoresizingMaskIntoConstraints = NO;
	[self.activeViewController.view addSubview:self.largeButton];
	[self.largeButton dockAll];
	[self.largeButton addTarget:self action:@selector(btnLargeButton_Click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeLargeButton
{
	[self.largeButton removeFromSuperview];
	self.largeButton = nil;
}

- (void)btnLargeButton_Click: (id)sender
{
	[self moveToX:0 withVelocity:0];
}

//- (void)moveToY: (CGFloat)y withVelocity: (CGFloat)velocity
//{
//	[UIView animateWithDuration:kMenuDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseIn animations:^{
//		_cTop.constant = y;
//		[self.view layoutIfNeeded];
//	} completion:^(BOOL finished) {
//		
//	}];
//}

@end
