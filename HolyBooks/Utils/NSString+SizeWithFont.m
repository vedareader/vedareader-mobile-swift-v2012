//
//  NSString+SizeWithFont.m
//  
//
//  Created by Olga on 2/18/14.
//
//

#import "NSString+SizeWithFont.h"

@interface TextSizeCache : NSObject

+ (instancetype)sharedInstance;

- (NSValue *)sizeForText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width;

- (void)setSize:(CGSize)size forText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width;

@end

@interface TextSizeCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation TextSizeCache

- (instancetype)init
{
	self = [super init];
	if (self == nil)
	{
		return nil;
	}
	
	self.cache = [[NSCache alloc] init];
	self.cache.countLimit = 50;
	
	return self;
}

+ (instancetype)sharedInstance
{
	static id instance = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class instanceType = [self class];
		instance = [[instanceType alloc] init];
	});
	
	return instance;
}

- (NSValue *)sizeForText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width
{
	id key = @[font, @(width), text];
	NSValue * const result = [self.cache objectForKey:key];
	
	return result;
}

- (void)setSize:(CGSize)size forText:(NSString *)text withFont:(UIFont *)font width:(CGFloat)width
{
	id key = @[font, @(width), text];
	[self.cache setObject:[NSValue valueWithCGSize:size] forKey:key];
}

@end

@implementation NSString (SizeWithFont)

#pragma mark - IOS version compatible text sizing
//One string text size
- (CGSize)lineSizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName :font}
                                     context:nil];
    
    rect.size = CGSizeMake([NSString roundToScreenPixels:rect.size.width more:YES], [NSString roundToScreenPixels:rect.size.height more:NO]);
    
    return rect.size;
}

//Multiline text size
- (CGSize)textSizeWithFont:(UIFont *)font width:(CGFloat)width
{
	TextSizeCache * const cache = [TextSizeCache sharedInstance];
	NSValue * const size = [cache sizeForText:self withFont:font width:width];
	if (size != nil)
	{
		return [size CGSizeValue];
	}
	
	CGSize const newSize = [self textSizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	[cache setSize:newSize forText:self withFont:font width:width];
	
	return newSize;
}

- (CGSize)textSizeWithFont:(UIFont *)font width:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	return [self textSizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
	return [self textSizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName :font}
                                     context:nil];
    
    return rect.size;
}

//Round float to screen pixels (on Retina: 0.3-> 0.0, 0.5 -> 0.5, 0.7 -> 0.5, on usual screen: 0.5 -> 0.0)
+ (CGFloat)roundToScreenPixels:(CGFloat)number more:(BOOL)more
{
	CGFloat scale = [UIScreen mainScreen].scale;
	return more ? ceilf(ceilf(number * scale)/ scale) : floorf(floorf(number * scale)/ scale);
}

@end
