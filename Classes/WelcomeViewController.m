//
//  WelcomeViewController.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "WelcomeViewController.h"
#import "TwitterSettings.h"
#import "TweetTemplate.h"

@implementation WelcomeViewController

@synthesize usernameTextField, passwordTextField, introduction, activity;
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[usernameTextField becomeFirstResponder];
}

/*
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)settingsDone:(id)sender {
	[activity startAnimating];
	
	if (!defaults) {
		defaults = [NSUserDefaults standardUserDefaults];
		[defaults setBool:FALSE forKey:@"setupcomplete"];
	}
	
	if (!engine) {
		engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
		[engine setConsumerKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
	}
	
#if ENABLE_OAUTH
	// get oauth token for this user
	xauthRequestToken = [engine getXAuthAccessTokenForUsername:usernameTextField.text password:passwordTextField.text];
#else
	[defaults setObject:usernameTextField.text forKey:@"username"];
	[defaults setObject:passwordTextField.text forKey:@"password"];
	[engine setUsername:[defaults stringForKey:@"username"] password:[defaults stringForKey:@"password"]];
	
	userTimelineToken = [engine getUserTimelineFor:usernameTextField.text sinceID:0 startingAtPage:0 count:10];
#endif
}

#pragma mark -
#pragma mark Twitter authentication

- (void)requestSucceeded:(NSString *)requestIdentifier{
	if ([requestIdentifier isEqual:userTimelineToken]) {
		[defaults setBool:TRUE forKey:@"setupcomplete"];
		
		[activity stopAnimating];
		[engine closeAllConnections];

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings Saved" message:@"Your twitter details have been saved and tested" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[self.delegate configurationDidComplete:self];
	}
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error{
	NSLog(@"requestFailed:%@withError%@", requestIdentifier, error );
	if ([requestIdentifier isEqual:xauthRequestToken] || [requestIdentifier isEqual:userTimelineToken]) {
		[activity stopAnimating];
		[engine closeAllConnections];
		
		[introduction setText:@"Your username and password could not be verified. Try again!"];
		[usernameTextField becomeFirstResponder];
	}
}

- (void)accessTokenReceived:(OAToken *)token forRequest:(NSString *)connectionIdentifier {
	if ([connectionIdentifier isEqual:xauthRequestToken]) {
		[engine setAccessToken:token];
		[token storeInUserDefaultsWithServiceProviderName:@"twpie" prefix:@""];
		[defaults setBool:TRUE forKey:@"setupcomplete"];
		
//		NSString *directMessagesToken;
//		directMessagesToken = [engine getDirectMessagesSinceID:0 withMaximumID:0 startingAtPage:0 count:200];
		userTimelineToken = [engine getUserTimelineFor:usernameTextField.text sinceID:0 startingAtPage:0 count:200];
		
//		[activity stopAnimating];
//		[engine closeAllConnections];
//		
//		[self.delegate configurationDidComplete:self];
	}
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
	NSLog(@"directMessagesReceived: %d and %@", [messages count], connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	// analyse recent messsages and try to recognize any patterns
	NSLog(@"statusesReceived: %d and %@", [statuses count], connectionIdentifier);
	
	if ([connectionIdentifier isEqual:userTimelineToken]) {
		// read all status messages
		// read all direct messages
		// count number of occurances of each message
		// filter out messages which has been sent only once
		
		if ([statuses count] > 0) {
			NSEnumerator *enumerator = [statuses objectEnumerator];
			NSDictionary *dict;
			
//			while (dict = [enumerator nextObject]) {
//				NSString *txt = [dict objectForKey:@"text"];
//				NSLog(@"we got %@", txt);
//			}
			
			NSMutableDictionary *tweets = [[NSMutableDictionary alloc] init];
			while (dict = [enumerator nextObject]) {
				NSString *txt = [dict objectForKey:@"text"];
				NSLog(@"we got %@", txt);
				
				TweetTemplate *tweet = [[TweetTemplate alloc] initWithTweet:txt];
				[tweets setObject:tweet forKey:[tweet tweet]];
				[tweet release];
			}
			
			NSLog(@"in total we now have %d tweets", [tweets count]);
			
			[tweets release];
		}
	}
	
	[activity stopAnimating];
	[engine closeAllConnections];
	
	[self.delegate configurationDidComplete:self];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
	[engine release]; engine = nil;
}


- (void)dealloc {
	if (engine) {
		[engine closeAllConnections];
		[engine release];
		engine = nil;
	}
	
	[super dealloc];
}

@end