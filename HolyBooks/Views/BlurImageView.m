//
//  BlurImageView.m
//  HolyBooks
//
//  Created by Roman Developer on 11/25/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import "BlurImageView.h"

@interface BlurImageView ()

@property (nonatomic, retain) CIFilter *clampFilter;
@property (nonatomic, retain) CIFilter *blurFilter;
@property (nonatomic, retain) CIContext *ciContext;
@property (nonatomic, retain) CIImage *inputCIImage;

@end

@implementation BlurImageView

- (id)initWithFrame:(CGRect)frame
{
	self.clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
	self.blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	
	EAGLContext *glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	self.ciContext = [CIContext contextWithEAGLContext:glContext options: @{ kCIContextWorkingColorSpace : [NSNull null] }];

	self = [super initWithFrame:frame context:glContext];
	self.enableSetNeedsDisplay = YES;
	
	[glContext release];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
	self.blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
	
	EAGLContext *glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	self.ciContext = [CIContext contextWithEAGLContext:glContext options: @{ kCIContextWorkingColorSpace : [NSNull null] }];
	
	self = [super initWithCoder:aDecoder];
	self.context = glContext;
	self.enableSetNeedsDisplay = YES;
	
	[glContext release];
	
	return self;
}

- (void)dealloc
{
	[_clampFilter release];
	[_blurFilter release];
	//[_ciContext release];	//Commented because of crashes on iPad
	[_inputCIImage release];
	
	[_inputImage release];
	
	[super dealloc];
}

#pragma mark - Properties
- (void)setInputImage:(UIImage *)inputImage
{
	if (_inputImage != inputImage)
	{
		[_inputImage release];
		_inputImage = inputImage;
		[_inputImage retain];
		
		self.inputCIImage = [CIImage imageWithCGImage:[inputImage CGImage]];
	}
}

- (void)setBlurRadius:(CGFloat)blurRadius
{
	_blurRadius = blurRadius;
	
	[_blurFilter setValue:@(blurRadius) forKey:@"inputRadius"];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	if (_inputCIImage != nil)
	{
		[_clampFilter setValue:_inputCIImage forKey:kCIInputImageKey];
		[_blurFilter setValue:_clampFilter.outputImage forKey:kCIInputImageKey];
		CGRect rect = CGRectMake(0, 0, self.drawableWidth, self.drawableHeight);
		[_ciContext drawImage:_blurFilter.outputImage inRect:rect fromRect:_inputCIImage.extent];
	}
}

@end
