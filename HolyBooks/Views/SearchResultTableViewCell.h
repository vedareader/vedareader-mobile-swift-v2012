//
//  SearchResultTableViewCell.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 25/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "SearchResultItem.h"

#import <UIKit/UIKit.h>

@class SearchResultTableViewCell;

@protocol SearchResultTableViewCellDelegate <NSObject>

@optional
- (void)searchResultTableViewCellDidSelect:(nonnull SearchResultTableViewCell *)cell;

@end

@interface SearchResultTableViewCell : BaseTableViewCell

@property (assign, nonatomic, nullable) id<SearchResultTableViewCellDelegate> delegate;

@property (retain, nonatomic, nonnull, readonly) SearchResultItem *searchResult;

- (void)fillWithData:(nonnull SearchResultItem *)data;

@end
