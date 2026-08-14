//
//  Localization.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 16/03/16.
//  Copyright © 2016 Iron Water Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Localization : NSObject

+ (NSString *)textForKey:(NSString *)key number:(NSInteger)number;

@end
