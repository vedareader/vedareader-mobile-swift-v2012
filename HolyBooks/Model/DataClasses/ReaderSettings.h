//
//  ReaderSettings.h
//  HolyBooks
//
//  Created by Stanislav Grinberg on 17/01/17.
//  Copyright © 2017 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enums.h"

@interface ReaderSettings : NSObject <NSCoding>

@property (retain, nonatomic) NSString *fontName;
@property (retain, nonatomic) NSString *transitionName;

- (instancetype)initWithTransitionName:(NSString *)transitionName fontName:(NSString *)fontName;
+ (instancetype)createDefaultSettings;

- (int)getTransitionType;

@end
