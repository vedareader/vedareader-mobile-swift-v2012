//
//  ReaderSearchViewController.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "SearchResultItem.h"

#import <UIKit/UIKit.h>

@class ReaderSearchViewController;

@protocol ReaderSearchViewControllerDelegate <NSObject>

- (void)readerSearchViewController:(ReaderSearchViewController *)controller searchWithText:(NSString *)text;

- (void)readerSearchViewControllerCancelSearch:(ReaderSearchViewController *)controller;

- (void)readerSearchViewController:(ReaderSearchViewController *)controller didSelectSearchResult:(SearchResultItem *)searchResult;

@end

@interface ReaderSearchViewController : UIViewController

@property (assign, nonatomic) id<ReaderSearchViewControllerDelegate> delegate;

- (void)addSearchResult:(SearchResultItem *)item;

- (void)finishSearch;

- (void)clearAll;

@end
