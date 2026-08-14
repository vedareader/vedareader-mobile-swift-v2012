//
//  ShareData.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 27/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareData : NSObject

@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSString *authorName;
@property (retain, nonatomic) NSString *chapter;

- (instancetype)initWithText:(NSString *)text
				  authorName:(NSString *)authorName
					 chapter:(NSString *)chapter;

@end
