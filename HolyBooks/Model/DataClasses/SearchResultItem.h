//
//  SearchResultItem.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 04/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchResultItem : NSObject

@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, retain, nullable) NSString *chapterTitle;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, retain, nullable) NSString *text;

@end
