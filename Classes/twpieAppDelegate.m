//
//  twpieAppDelegate.m
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright Commanigy 2010. All rights reserved.
//

#import "twpieAppDelegate.h"
#import "RootViewController.h"

@implementation twpieAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)awakeFromNib {
	
//	navigationController.navigationBar.barStyle = UIBarStyleBlack;
//	navigationController.navigationBar.translucent = NO;
//	navigationController.navigationBar.tintColor = [UIColor colorWithRed:242/255.0 green:193.0/255.0 blue:74.0/255.0 alpha:1];
	//navigationController.navigationBar.tintColor = [UIColor colorWithRed:.75 green:.75 blue:.25 alpha:1];
	
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	TweetRepository *tweetRepository = [[TweetRepository alloc] init];
	rootViewController.tweetRepository = tweetRepository;
	[tweetRepository release];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Override point for customization after application launch.

    // Add the navigation controller's view to the window and display.
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[[rootViewController tweetRepository] weighted]];
	[defaults setObject:myEncodedObject forKey:@"tweets"];
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end