//
//  CustomViewBase.h
//  HolyBooks
//
//  Created by Konstantin Oznobikhin on 08/10/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Base class for custom views.
 *
 * Provides facilities for view creation and loading it from xib.
 */
@interface CustomViewBase : UIView

/**
 * Creates a new instance of the CustomViewBase class.
 *
 * The message is intended to be used for creating instances of derived classes only.
 */
+ (instancetype)create;

/**
 * Gets view object loaded from xib.
 */
@property (retain, nonatomic, readonly) UIView *contentView;

- (void)postInit;

@end
