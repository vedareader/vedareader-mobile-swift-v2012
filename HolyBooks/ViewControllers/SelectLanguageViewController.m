//
//  SelectLanguageViewController.m
//  HolyBooks
//
//  Created by Roman Developer on 11/30/15.
//  Copyright © 2015 Iron Water Studio. All rights reserved.
//

#import "SelectLanguageViewController.h"
#import "Settings.h"
#import "HolyContentManager.h"

#import "UIView+Autolayout.h"

#define kAnimationDuration 0.3

@interface SelectLanguageViewController ()

@property (nonatomic, retain) NSLayoutConstraint *constraint;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cContentTop;
//@property (retain, nonatomic) IBOutlet NSLayoutConstraint *cContentSafeTop;


@end

@implementation SelectLanguageViewController

- (instancetype)initWithSizeClass: (UIUserInterfaceSizeClass)horizontalSizeClass parent:(UIViewController *)parentVC
{
	if ((self = [super initWithNibName:@"SelectLanguageViewController" bundle:nil]))
	{
		self.horizontalSizeClass = horizontalSizeClass;
		self.parent = parentVC;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	CGFloat navBarHeight = [_parent isKindOfClass:[UINavigationController class]] ?
		((UINavigationController*)_parent).navigationBar.frame.size.height :
		_parent.navigationController.navigationBar.frame.size.height;
	CGFloat top = UIApplication.sharedApplication.statusBarFrame.size.height + navBarHeight + 4;
	_cContentTop.constant = top;
	
	//Top constraint for iOS 11
	if (@available(iOS 11.0, *))
	{
		_cContentTop.constant = top + self.view.safeAreaInsets.top;
	}
	
	//Tap recognizer
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer_DidTap:)];
	[self.view addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];

	//Exclude vContent
	UITapGestureRecognizer *tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
	[self.vContent addGestureRecognizer:tapRecognizer2];
	[tapRecognizer2 release];
	
	//Round corners
	_vContent.layer.cornerRadius = 6;
	_vContent.layer.masksToBounds = YES;
	
	//Titles
	_lblDescription.text = Local(@"SelectLanguage.Description");
	_lblPageTransitionDescription.text = Local(@"PageTransition.Description");
	
	[self fillViews];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//GA
	[GAHelper logScreen:kScreenBookReaderSelectLanguage];
}

- (void)fillViews
{
	//Triangle
	[_imgTriangle alignAttribute:NSLayoutAttributeTrailing to:_vContent withPadding:-10];
	[_vContent pinTopTo:_imgTriangle withPadding:-1];

	//Need to disable height constraints first otherwise there will be bunch of constraints errors
	_cnstLanguagesHeight.active = NO;
	_cnstTransitionsHeight.active = NO;
	
	//Languages block
	NSArray *languages = [HolyContentManager sharedManager].languages;
	SelectLanguageView *previousView = nil;
	int curIndex = 1;
	for (HolyLanguage *language in languages)
	{
		SelectLanguageView *selectLanguageView = [SelectLanguageView createWithLanguage:language isOn:[[Settings sharedSettings] languageOnWithID:language.identity]];
		selectLanguageView.translatesAutoresizingMaskIntoConstraints = NO;
		selectLanguageView.delegate = self;
		[_vOptions addSubview:selectLanguageView];

		[selectLanguageView alignLeadingWithPadding:0];
		[selectLanguageView alignTrailingWithPadding:0];
		
		if (previousView == nil)
			[selectLanguageView alignTopWithPadding:0];
		else
			[selectLanguageView pinTopTo:previousView withPadding:0];
		
		if (language == [languages lastObject])
			[selectLanguageView alignBottomWithPadding:0];
		
		previousView = selectLanguageView;
		
		if (curIndex == languages.count)
			[previousView setSeparatorHidden:YES];
		curIndex++;
	}
	
	//Page transitions block
	BOOL isFlippingOn;
	BOOL isSlideOn;
	
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"PageTransitionType"].length == 0)// isEqual: @""])
	{
		NSString *defaultTransitionType = @"1";
		[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		isFlippingOn = NO;
		isSlideOn = YES;
	}
	else
	{
		if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"PageTransitionType"] integerValue] == 1)
		{
			isFlippingOn = NO;
			isSlideOn = YES;
		}
		else
		{
			isFlippingOn = YES;
			isSlideOn = NO;
		}
	}
	
	/*SelectPageTransitionView *firstView*/
	self.firstTransitionView = [SelectPageTransitionView createWithTransition:Local(@"BookReader.TransitionStyle.Flipping") isOn:isFlippingOn];
	self.firstTransitionView.delegate = self;
	self.firstTransitionView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[_vPageTransitions addSubview:self.firstTransitionView];
	
	[self.firstTransitionView alignLeadingWithPadding:0];
	[self.firstTransitionView alignTrailingWithPadding:0];
	
	[self.firstTransitionView alignTopWithPadding:0];
	
	/*SelectPageTransitionView *secondView*/
	self.secondTransitionView = [SelectPageTransitionView createWithTransition:Local(@"BookReader.TransitionStyle.Shift") isOn:isSlideOn];
	self.secondTransitionView.delegate = self;
	self.secondTransitionView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[_vPageTransitions addSubview:self.secondTransitionView];
	
	[self.secondTransitionView alignLeadingWithPadding:0];
	[self.secondTransitionView alignTrailingWithPadding:0];
	
	[self.secondTransitionView pinTopTo:self.firstTransitionView withPadding:0];
	[self.secondTransitionView alignBottomWithPadding:0];
	[self.secondTransitionView setSeparatorHidden:YES];
	
	_cnstTransitionsHeight.constant = 40 * 2;
	_cnstLanguagesHeight.constant = 40 * languages.count;
	
	if (IS_IPAD)
	{
		[NSLayoutConstraint deactivateConstraints:@[self.cnstLeadingContent]];
		[_vContent constraintWidth:384];
	}
	
	//Don't forget to enable them back!
	_cnstLanguagesHeight.active = YES;
	_cnstTransitionsHeight.active = YES;
}

- (void)dealloc
{
	[_vContent release];
	[_lblDescription release];
	[_vOptions release];
	[_imgTriangle release];
	[_vPageTransitions release];
	[_cnstLanguagesHeight release];
	[_cnstTransitionsHeight release];
	[_cnstLeadingContent release];
	[_lblPageTransitionDescription release];
	[_cContentTop release];
	[super dealloc];
}

#pragma mark - Functionality
- (void)animateIn
{
	self.view.alpha = 0;
	[UIView animateWithDuration:kAnimationDuration animations:^{
		self.view.alpha = 1;
	}];
}

- (void)animateOut:(void (^)())completion;
{
	[UIView animateWithDuration:kAnimationDuration animations:^{
		self.view.alpha = 0;
	} completion:^(BOOL finished) {
		completion();
	}];
}

/*- (void)horizontalSizeClassDidSet
{
	if (self.constraint != nil)
	{
		[self.view removeConstraint:self.constraint];
		[_vContent removeConstraint:self.constraint];
		
		self.constraint = nil;
	}
	
	if (self.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
		self.constraint = [_vContent alignLeadingWithPadding:10];
	else
		self.constraint = [_vContent constraintWidth:384];
}*/

#pragma mark - Recognizer
- (void)tapGestureRecognizer_DidTap: (UITapGestureRecognizer *)gestureRecognizer
{
	[_delegate selectLanguageCloseSelected];
}

#pragma mark - SelectLanguageViewDelegate
- (void)valueSelectedWithLanguageID: (NSInteger)languageID isOn: (BOOL)isOn
{
	[[Settings sharedSettings] setLanguageOnWithID:languageID isOn:isOn];
}

- (void)displayLanguageSelectionError
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:Local(@"SelectLanguage.LastLanguageSelected") preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
	
	[alert addAction:defaultAction];
	[self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)valueChanged:(NSString *)transitionName isOn:(NSInteger)isOn
{
	if ([transitionName isEqualToString:Local(@"BookReader.TransitionStyle.Shift")])
	{
		if (isOn == 1)
		{
			NSString *defaultTransitionType = @"2";
			[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			self.firstTransitionView.imgStatus.hidden = NO;
			self.secondTransitionView.imgStatus.hidden = YES;
		}
		else
		{
			NSString *defaultTransitionType = @"1";
			[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			self.firstTransitionView.imgStatus.hidden = YES;
			self.secondTransitionView.imgStatus.hidden = NO;
		}
	}
	else
	{
		if (isOn == 1)
		{
			NSString *defaultTransitionType = @"1";
			[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			self.secondTransitionView.imgStatus.hidden = NO;
			self.firstTransitionView.imgStatus.hidden = YES;
		}
		else
		{
			NSString *defaultTransitionType = @"2";
			[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			self.secondTransitionView.imgStatus.hidden = YES;
			self.firstTransitionView.imgStatus.hidden = NO;
		}
	}
}

@end
