//
//  BlurImageView.h
//  HolyBooks
//
//  Created by Roman Developer on 11/25/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface BlurImageView : GLKView

@property (nonatomic, retain) UIImage *inputImage;
@property (nonatomic, assign) CGFloat blurRadius;

@end
