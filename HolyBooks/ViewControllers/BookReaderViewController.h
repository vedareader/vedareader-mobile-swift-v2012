//
//  BookReaderViewController.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 04/02/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookReaderViewController : UIViewController

+ (nullable instancetype)readerWithBookID:(NSInteger)bookID;

- (nullable instancetype)initWithBookID:(NSInteger)bookID;

@property (assign, nonatomic, readonly) NSInteger bookID;

- (void)dismiss;

@end
