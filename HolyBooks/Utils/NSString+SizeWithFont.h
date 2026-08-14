//
//  NSString+SizeWithFont.h
//  
//  IOS version compatible text sizing
//  Created by Olga on 2/18/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (SizeWithFont)

//One string text size; unlike boundingRectWithSize, returns size rounded to screen pixels
- (CGSize)lineSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

//Multiline text size; unlike boundingRectWithSize, returns size rounded to screen pixels
- (CGSize)textSizeWithFont:(UIFont *)font width:(CGFloat)width;
- (CGSize)textSizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

//Round float to screen pixels (on Retina: 0.3-> 0.0, 0.5 -> 0.5, 0.7 -> 0.5, on usual screen: 0.5 -> 0.0)
+ (CGFloat)roundToScreenPixels:(CGFloat)number more:(BOOL)more776;

@end
