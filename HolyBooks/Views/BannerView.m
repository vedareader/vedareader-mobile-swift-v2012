//
//  BannerView.m
//  HolyBooks
//
//  Created by Roman Developer on 10/21/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "BannerView.h"
#import "UIView+Autolayout.h"

#define kTimerDuration 3
#define kAnimationDuration 0.5

#define kVelocitySensivity 200

typedef enum
{
	ImageSwapDirectionForward = 1,
	ImageSwapDirectionZero = 0,
	ImageSwapDirectionBackward = -1,
} ImageSwapDirection;

@interface BannerView ()
{
	BOOL _heightSet;
	NSInteger _cycleCount;
	
	CGPoint _beforePan;
	
	BOOL _isSwaping;
}

@property (nonatomic, retain) NSArray *imageViews;
@property (nonatomic, retain) NSTimer *changeTimer;

@property (nonatomic, retain) NSLayoutConstraint *hConstraint;
@property (nonatomic, retain) NSLayoutConstraint *wConstraint;

@end

@implementation BannerView

- (void)prepareForInterfaceBuilder
{
	//Build views hierarchy
	[self init];
	
	//Load resources
//	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//	_leftTrackImage = [UIImage imageNamed:@"player_slider_line.png" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
//	_rightTrackImage = [UIImage imageNamed:@"player_slider_line.png" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
//	_thumbImage = [UIImage imageNamed:@"player_slider.png" inBundle:bundle compatibleWithTraitCollection:self.traitCollection];
}

- (instancetype)init
{
	if (self = [super init])
	{
		[self innerInit];
	}
	
	return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	[self innerInit];
}

- (void)innerInit
{
	self.backgroundColor = [UIColor redColor];
	
	//Create 3 image views
	self.imageViews = @[ [[[UIImageView alloc] init] autorelease], [[[UIImageView alloc] init] autorelease], [[[UIImageView alloc] init] autorelease] ];

	UIImageView *leftImageView = _imageViews[0];
	UIImageView *centerImageView = _imageViews[1];
	UIImageView *rightImageView = _imageViews[2];

	leftImageView.translatesAutoresizingMaskIntoConstraints = NO;
	centerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	rightImageView.translatesAutoresizingMaskIntoConstraints = NO;
	
	leftImageView.contentMode = UIViewContentModeScaleAspectFit;
	centerImageView.contentMode = UIViewContentModeScaleAspectFit;
	rightImageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[self addSubview:leftImageView];
	[self addSubview:centerImageView];
	[self addSubview:rightImageView];
	
	//Constraints for them
	[centerImageView alignLeadingWithPadding:0];
	[centerImageView alignTopWithPadding:0];
	[centerImageView alignBottomWithPadding:0];
	
	[centerImageView pinLeadingTo:leftImageView withPadding:0];
	[leftImageView alignTopWithPadding:0];
	[leftImageView alignBottomWithPadding:0];
	[leftImageView alignAttribute:NSLayoutAttributeWidth to:centerImageView withPadding:0];
	[leftImageView alignAttribute:NSLayoutAttributeHeight to:centerImageView withPadding:0];
	
	[rightImageView pinLeadingTo:centerImageView withPadding:0];
	[rightImageView alignTopWithPadding:0];
	[rightImageView alignBottomWithPadding:0];
	[rightImageView alignAttribute:NSLayoutAttributeWidth to:centerImageView withPadding:0];
	[rightImageView alignAttribute:NSLayoutAttributeHeight to:centerImageView withPadding:0];
	
	//Pan gesture recognizer
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer_DidPan:)];
	[self addGestureRecognizer:panGestureRecognizer];
	[panGestureRecognizer release];
	
	//Tap gesture recognizer
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer_DidTap:)];
	[self addGestureRecognizer:tapGestureRecognizer];
	[tapGestureRecognizer release];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//NSLog(@"Banners layout subviews");
	
	if (!_heightSet)
	{
		_cycleCount = _images.count * _imageViews.count * 100;
		
		//Calculate height
		UIImage *image = [UIImage imageWithContentsOfFile:_images[0]];
		if (image == nil)
			return;
		
		CGFloat ratio = image.size.width / self.frame.size.width;
		CGFloat height = image.size.height / ratio;
		
		//Set constraints
		UIImageView *centerImageView = _imageViews[1];
		
		self.hConstraint = [centerImageView constraintHeight:height];
		self.wConstraint = [centerImageView constraintWidth:self.frame.size.width];
		
		[self fillImages];
		
		[self startTimer];
		
		_heightSet = YES;
	}
	else
	{
		//Calculate height
		UIImage *image = [UIImage imageWithContentsOfFile:_images[0]];
		if (image == nil)
			return;
		
		CGFloat ratio = image.size.width / self.frame.size.width;
		CGFloat height = image.size.height / ratio;
		
		//Set constraints
		self.hConstraint.constant = height;
		self.wConstraint.constant = self.frame.size.width;
//		NSLog(@"Height constraint: %@", centerImageView.heightConstraint);
//		NSLog(@"Width constraint: %@", centerImageView.widthConstraint);
		//NSLog(@"Desc: %@", [self recursiveDescription]);

	}
}

- (void)dealloc
{
	[_images release];
	[_imageViews release];
	
	[_changeTimer invalidate];
	[_changeTimer release];
	
	[super dealloc];
}

#pragma mark - Timer
- (void)startTimer
{
	self.changeTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerDuration target:self selector:@selector(changeTimer_Tick:) userInfo:nil repeats:YES];
}

#pragma mark - Private
- (void)swapImages: (ImageSwapDirection)direction withVelocity: (CGFloat)velocity
{
	if (_isSwaping)
		return;
	
	//NSLog(@"Swap started");
	
	_isSwaping = YES;
	
	//Animate
	UIImageView *centerImageView = _imageViews[(_cycleCount + 1) % 3];
	UIImageView *leftImageView = _imageViews[_cycleCount % 3];
	UIImageView *rightImageView = _imageViews[(_cycleCount + 2) % 3];
	
	NSLayoutConstraint *centerLeadingConstraint = [self leadingForSubview:centerImageView];
	if (direction == ImageSwapDirectionForward)
		centerLeadingConstraint.constant = -self.frame.size.width;
	else if (direction == ImageSwapDirectionBackward)
		centerLeadingConstraint.constant = self.frame.size.width;
	else
		centerLeadingConstraint.constant = 0;
	
	[UIView animateWithDuration:(velocity == 0 ? kAnimationDuration : MIN(kAnimationDuration, kAnimationDuration / fabs(velocity))) delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
	
		//NSLog(@"Swap finished: %d", finished);
		
		if (finished)
		{
			//New center leading
			NSLayoutConstraint *centerLeadingConstraint = [self leadingForSubview:centerImageView];
			if (direction == ImageSwapDirectionForward)
			{
				[self removeConstraint:centerLeadingConstraint];
				[rightImageView alignLeadingWithPadding:0];	//!!!!!!!
			}
			else if (direction == ImageSwapDirectionBackward)
			{
				[self removeConstraint:centerLeadingConstraint];
				[leftImageView alignLeadingWithPadding:0];
			}
			else
				centerLeadingConstraint.constant = 0;
			
			//Swap sides
			if (direction == ImageSwapDirectionForward)
			{
				NSLayoutConstraint *leftCenterConstraint = [self leadingTrailingBetweenSubview1:leftImageView andSubview2:centerImageView];
				[self removeConstraint:leftCenterConstraint];
				[leftImageView pinLeadingTo:rightImageView withPadding:0];
				
				_cycleCount++;
			}
			else if (direction == ImageSwapDirectionBackward)
			{
				NSLayoutConstraint *rightCenterConstraint = [self leadingTrailingBetweenSubview1:rightImageView andSubview2:centerImageView];
				[self removeConstraint:rightCenterConstraint];
				[leftImageView pinLeadingTo:rightImageView withPadding:0];
				
				_cycleCount--;
			}
			
			[self fillImages];
		}
		else
			centerLeadingConstraint.constant = 0;
		
		_isSwaping = NO;
	}];
}

- (void)fillImages
{
	NSString *leftImage = _images[_cycleCount % _images.count];
	NSString *centerImage = _images[(_cycleCount + 1) % _images.count];
	NSString *rightImage = _images[(_cycleCount + 2) % _images.count];
	
	UIImageView *leftImageView = _imageViews[_cycleCount % 3];
	UIImageView *centerImageView = _imageViews[(_cycleCount + 1) % 3];
	UIImageView *rightImageView = _imageViews[(_cycleCount + 2) % 3];
	
	leftImageView.image = [UIImage imageWithContentsOfFile:leftImage];
	centerImageView.image = [UIImage imageWithContentsOfFile:centerImage];
	rightImageView.image = [UIImage imageWithContentsOfFile:rightImage];
}

- (void)changeTimer_Tick: (id)sender
{
	[self swapImages:ImageSwapDirectionForward withVelocity:0];
}

#pragma mark - Public
+ (CGFloat)heightForWidth: (CGFloat)width
{
	CGFloat ratio = kImageSize.width / width;
	return kImageSize.height / ratio;
}

#pragma mark - Pan
- (void)panGestureRecognizer_DidPan: (UIPanGestureRecognizer *)gestureRecognizer
{
	switch (gestureRecognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			NSLog(@"Began");

			//Stop animations
			[self.layer removeAllAnimations];
			for (UIImageView *iv in _imageViews)
				[iv.layer removeAllAnimations];
			
			[_changeTimer invalidate];
			
			UIImageView *centerImageView = _imageViews[(_cycleCount + 1) % 3];
			CALayer *presentationLayer = centerImageView.layer.presentationLayer;
			NSLayoutConstraint *centerLeadingConstraint = [self leadingForSubview:centerImageView];
			centerLeadingConstraint.constant = presentationLayer.frame.origin.x;
			
			_beforePan = [gestureRecognizer locationInView:self];
			NSLogPoint(_beforePan);
			_beforePan.x -= centerLeadingConstraint.constant;
			NSLogPoint(_beforePan);
			
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			//NSLog(@"Changed");
			CGPoint currentPan = [gestureRecognizer locationInView:self];
			
			CGFloat delta = currentPan.x - _beforePan.x;
			
			UIImageView *centerImageView = _imageViews[(_cycleCount + 1) % 3];
			NSLayoutConstraint *centerLeadingConstraint = [self leadingForSubview:centerImageView];
			
			//Prevent scroll to the end
			if (delta > self.frame.size.width)
				delta = self.frame.size.width;
			else if (delta < -self.frame.size.width)
				delta = -self.frame.size.width;
			
			centerLeadingConstraint.constant = delta;
			
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			NSLog(@"Ended");
			[self startTimer];
			
			CGPoint velocity = [gestureRecognizer velocityInView:self];
			NSLogPoint(velocity);
			
			ImageSwapDirection direction = ImageSwapDirectionZero;
			
			//Analyze velocity first
			if (fabs(velocity.x) > kVelocitySensivity)
			{
				direction = (velocity.x > 0) ? ImageSwapDirectionBackward : ImageSwapDirectionForward;
			}
			else	//Then proximity
			{
				UIImageView *centerImageView = _imageViews[(_cycleCount + 1) % 3];
				NSLayoutConstraint *centerLeadingConstraint = [self leadingForSubview:centerImageView];
				
				CGFloat minusProximity = fabs(-self.frame.size.width - centerLeadingConstraint.constant);
				CGFloat zeroProximity = fabs(0 - centerLeadingConstraint.constant);
				CGFloat plusProximity = fabs(self.frame.size.width - centerLeadingConstraint.constant);
				
				if (minusProximity < zeroProximity && minusProximity < plusProximity)
					direction = ImageSwapDirectionForward;
				else if (plusProximity < zeroProximity)
					direction = ImageSwapDirectionBackward;
			}
			
			//Move to
			[self swapImages:direction withVelocity:(velocity.x / 200.0f)];
			
			break;
		}
		case UIGestureRecognizerStateCancelled:
		{
			NSLog(@"Cancelled");
			
			[self startTimer];
			
			break;
		}
		default:
			NSLog(@"Not implemented");
			break;
	}
}

#pragma mark - Tap
- (void)tapGestureRecognizer_DidTap: (UITapGestureRecognizer *)gestureRecognizer
{
	NSInteger centerImageIndex = (_cycleCount + 1) % _images.count;
	[self.delegate bannerDidSelected:centerImageIndex];
}

@end
