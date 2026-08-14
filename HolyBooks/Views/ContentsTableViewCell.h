//
//  ContentsTableViewCell.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 11/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "ChapterDescription.h"

#import <UIKit/UIKit.h>

@class ContentsTableViewCell;

@protocol ContentsTableViewCellDelegate <NSObject>

@optional
- (void)contentsTableViewCellDidSelect:(ContentsTableViewCell *)cell;

@end

@interface ContentsTableViewCell : BaseTableViewCell

@property (assign, nonatomic) id<ContentsTableViewCellDelegate> delegate;

@property (retain, nonatomic, readonly) ChapterDescription *chapterDescription;

- (void)fillWithDescription:(ChapterDescription *)description;

@end
