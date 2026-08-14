//
//  BookContentsViewController.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 05/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import "ReflowableViewController.h"

#import <UIKit/UIKit.h>

@class BookContentsViewController;

@protocol BookContentsViewControllerDelegate <NSObject>

@optional
- (void)bookContentsViewController:(BookContentsViewController *)controller didSelectChapter:(NSInteger)chapterIndex;

@end

@interface BookContentsViewController : UIViewController

@property (assign, nonatomic) id<BookContentsViewControllerDelegate> delegate;

- (instancetype)initWithBookViewController:(ReflowableViewController *)controller chapters:(NSArray *)chapters;

@end
