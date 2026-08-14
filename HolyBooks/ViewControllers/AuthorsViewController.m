//
//  AuthorsViewController.m
//  HolyBooks
//
//  Created by Stanislav Grinberg on 19/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import "AuthorsViewController.h"
#import "AuthorCollectionViewCell.h"
#import "AuthorsCollectionViewLayout.h"
#import "AuthorDetailsViewController.h"

#import "HolyContentManager.h"

#import "UIViewController+CustomDraw.h"
#import "NSString+SizeWithFont.h"
#import "Localization.h"
#import "UIImage+Background.h"

#import "HolyContentManager.h"

#define kiPhoneInsets UIEdgeInsetsZero
#define kiPadInsets UIEdgeInsetsMake(14.0, 14.0, 14.0, 14.0)

@interface AuthorsViewController () <AuthorsCollectionViewLayoutDelegate>

@property (retain, nonatomic) IBOutlet UICollectionView *cvAuthors;
@property (retain, nonatomic) NSArray *authors;

@end

@implementation AuthorsViewController

- (void)dealloc
{
	[_cvAuthors release];
	
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//Navigation buttons
	self.navigationItem.leftBarButtonItem = [self barButtonWithImage:@"icon_menu" action:@selector(btnMenu_Click:)];
	self.title = Local(@"Authors.Title");
	
	self.authors = [self filterAuthors:[HolyContentManager sharedManager].authors];
	
	// Collection setup
	self.cvAuthors.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage backgroundImage]] autorelease];
	self.cvAuthors.contentInset = IS_IPHONE ? kiPhoneInsets : kiPadInsets;
	
	[AuthorCollectionViewCell registerFor:self.cvAuthors];
	
	AuthorsCollectionViewLayout *layout = [[[AuthorsCollectionViewLayout alloc] init] autorelease];
	layout.delegate = self;
	self.cvAuthors.collectionViewLayout = layout;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Navigation
	self.navigationController.navigationBarHidden = NO;
	
	//GA
	[GAHelper logScreen:kScreenAuthors];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	//NSLog(@"size: %@", NSStringFromCGSize(size));
	AuthorsCollectionViewLayout *layout = (AuthorsCollectionViewLayout *)self.cvAuthors.collectionViewLayout;
	[layout.cache removeAllObjects];
	
	if (size.width > size.height)
		layout.numberOfColumns = IS_IPHONE ? 2 : 4;
	else
		layout.numberOfColumns = IS_IPHONE ? 2 : 3;
	
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		[self.cvAuthors.collectionViewLayout invalidateLayout];
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		
	}];
}

- (NSArray *)filterAuthors:(NSArray *)defaultAuthors
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	
	NSMutableArray <NSNumber *> *selectedLanguages = [NSMutableArray array];
	for (HolyLanguage *language in [HolyContentManager sharedManager].languages)
	{
		if ([[Settings sharedSettings] languageOnWithID:language.identity])
			[selectedLanguages addObject:@(language.identity)];
	}
	
	for (HolyAuthor *author in defaultAuthors)
	{
		BOOL authorGoesIn = NO;
		for (int i = 0; i < selectedLanguages.count; i++)
		{
			//TODO: In the future change this to check if we're using file or DB and use method according to check result.
			NSInteger booksQuantity = [[[HolyContentManager sharedManager].booksForAuthorId objectForKey:@(author.identity)] integerValue];
			
			if (author.languageID == selectedLanguages[i].integerValue && booksQuantity > 0)
			{
				authorGoesIn = YES;
				break;
			}
		}
		
		if (authorGoesIn)
		{
			[result addObject:author];
		}
	}
	
	return result;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.authors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	AuthorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[AuthorCollectionViewCell reuseID] forIndexPath:indexPath];

	HolyAuthor *author = self.authors[indexPath.row];
	
	[cell fillWithAuthor:author];
	
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate mainMenuStopInteracting];
	
	HolyAuthor *author = self.authors[indexPath.row];
	AuthorDetailsViewController *authorsDetailsVC = [[AuthorDetailsViewController alloc] initWithAuthorID:author.identity];
	[self.navigationController pushViewController:authorsDetailsVC animated:YES];
	
	//GA
	[GAHelper logEventWithCategory:kCategoryAuthors action:kActionAuthorClick value:@(author.identity)];
}

#pragma mark - AuthorsCollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath withWidth:(CGFloat)width
{
	HolyAuthor *author = self.authors[indexPath.row];
	CGFloat textWidth = width - 2 * 12.0;
	
	// Start calculate height with init value equals width because cell contains square image
	CGFloat height = width;
	
	//Calculate heigth of labels
	CGSize nameTextSize = [author.name textSizeWithFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] width:textWidth];
	
	NSInteger booksQuantity = [HolyContentManager booksAmountForAuthorId:author.identity];
	NSString *booksQuantityFormat = [Localization textForKey:@"Authors.BooksQuantity" number:booksQuantity];
	NSString *booksQuantityString = [NSString stringWithFormat:booksQuantityFormat, (long)booksQuantity];
	
	CGSize booksQuantityTextSize = [booksQuantityString textSizeWithFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightRegular] width:textWidth];
	
	CGFloat sumOfAllVerticalGaps = 16.0 + 4.0 + 19.0;
	
	height += nameTextSize.height + booksQuantityTextSize.height + sumOfAllVerticalGaps;

	//NSLog(@"height: %.2f", height);
	
	return height;
}

#pragma mark - Actions
- (void)btnMenu_Click: (id)sender
{
	[self.delegate mainMenuDidSelected];
}

@end
