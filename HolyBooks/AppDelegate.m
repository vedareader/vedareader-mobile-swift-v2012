//
//  AppDelegate.m
//  HolyBooks
//
//  Created by Roman Developer on 9/17/15.
//  Copyright (c) 2015 Iron Water Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "AppHelper.h"
#import "MainMenuViewController.h"
#import "HolyContentManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <AVFoundation/AVFoundation.h>

#define kGATrackingId @"UA-91314625-1"

@interface AppDelegate ()

@property (assign, nonatomic) NSInteger lastBookID;
@property (assign, nonatomic) UIViewController *bookPresenter;

@end

@implementation AppDelegate

+ (instancetype)sharedInstance
{
	id result = [UIApplication sharedApplication].delegate;

	return result;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//FB
	[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
	[FBSDKAppEvents activateApp];
	
	//GA
	[GAHelper startTrackingWithId:kGATrackingId];
	
	id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
	tracker.allowIDFACollection = YES;
	
	self.lastBookID = -1;
	
	//Data
	[AppHelper initDB];
	
	//Init file system
	[HolyContentManager sharedManager];
	
	//Interface
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
	
	self.window.rootViewController = mainMenuViewController;
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
	[mainMenuViewController release];
	[_window release];
	
	[self applyDesign];
	
	NSError *error = nil;
	if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
	{
		NSLog(@"setting audio session category failed: %@", error);
	}

	//Setting up page transition type if it wasn't there before
	if ([[NSUserDefaults standardUserDefaults] stringForKey:@"PageTransitionType"].length == 0)
	{
		NSString *defaultTransitionType = @"1";
		[[NSUserDefaults standardUserDefaults] setObject:defaultTransitionType forKey:@"PageTransitionType"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	return YES;
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
			options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
	
	BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
																  openURL:url
														sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
															   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
					];
	// Add any custom logic here.
	return handled;
}

- (void)applyDesign
{
	//Navigation bar
	//	NSDictionary *navBarTextAttributes = @{
	//										   NSFontAttributeName: [UIFont systemFontOfSize:17],
	//										   NSForegroundColorAttributeName: kColorBlue
	//										   };
	//	[[UINavigationBar appearance] setTitleTextAttributes:navBarTextAttributes];
	//[[UINavigationBar appearance] set]
	[[UINavigationBar appearance] setTintColor:kColorBlue];
	[[UINavigationBar appearance] setBarTintColor:RGBA(255, 255, 255, 0.5)];
	[[UINavigationBar appearance] setTranslucent:NO];
	//[[UINavigationBar appearance] setAlpha:0.9f];
	//[[UINavigationBar appearance] setShadowImage:[]];
	[[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
	[[UISearchBar appearance] setTintColor:kColorBlue];
	[[UISearchBar appearance] setBarTintColor:[UIColor whiteColor]];
	
	[[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	if (IS_IPAD)
	{
		if (self.readerController == nil)
		{
			return;
		}
		
		self.lastBookID = self.readerController.bookID;
		self.bookPresenter = self.readerController.presentingViewController;
		[self.readerController dismiss];
	}
	
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (IS_IPAD)
	{
		if (self.lastBookID != -1)
		{
			BookReaderViewController *readerVC = [BookReaderViewController readerWithBookID:self.lastBookID];
			UINavigationController *vc = [[[UINavigationController alloc] initWithRootViewController:readerVC] autorelease];
			vc.navigationBarHidden = YES;

			[self.bookPresenter presentViewController:vc animated:YES completion:nil];
			
			self.lastBookID = -1;
			self.bookPresenter = nil;
		}
	}
	
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
