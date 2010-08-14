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
	
	[status setText:@"Authenticating with Twitter"];

	if (!defaults) {
		defaults = [NSUserDefaults standardUserDefaults];
		[defaults setBool:FALSE forKey:@"setupcomplete"];
	}
	
	if (!engine) {
		engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
		[engine setConsumerKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
	}
	
	// get oauth token for this user
	xauthRequestToken = [engine getXAuthAccessTokenForUsername:usernameTextField.text password:passwordTextField.text];
}

#pragma mark -
#pragma mark Twitter authentication

- (void)requestSucceeded:(NSString *)requestIdentifier{
	NSLog(@"requestSucceeded:%@", requestIdentifier);
//	if ([requestIdentifier isEqual:userTimelineToken]) {
//		[defaults setBool:TRUE forKey:@"setupcomplete"];
//		
//		[activity stopAnimating];
//		[engine closeAllConnections];
//
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings Saved" message:@"Your twitter details have been saved and tested" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[alert release];
//		
//		[self.delegate configurationDidComplete:self];
//	}
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error{
	NSLog(@"requestFailed:%@ withError%@", requestIdentifier, error);
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
		
		[status setText:@"Retrieving previously sent tweets"];
		
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

		NSMutableDictionary *tweets = [[NSMutableDictionary alloc] init];

		if ([statuses count] > 0) {
			NSEnumerator *enumerator = [statuses objectEnumerator];
			NSDictionary *dict;
			
			while (dict = [enumerator nextObject]) {
				NSString *txt = [dict objectForKey:@"text"];
				NSDate *createdAt = [dict objectForKey:@"created_at"];

				TweetTemplate *x = [[TweetTemplate alloc] initWithTweet:txt];
				[x setUpdatedAt:createdAt];

				TweetTemplate *tweet = [tweets objectForKey:[x tweet]];
				if (tweet) {
					[tweet increase];
				}
				else {
					[tweets setObject:x forKey:[x tweet]];
				}
				
				[x release];
			}
			
			NSMutableArray *doomedKeys = [[NSMutableArray alloc] init];
			enumerator = [tweets objectEnumerator];
			TweetTemplate *t;
			while (t = [enumerator nextObject]) {
				if (t.usageCount < 3) {
					[doomedKeys addObject:[t tweet]];
				}
			}
			[tweets removeObjectsForKeys:doomedKeys];
			[doomedKeys release];
		}
		
		[activity stopAnimating];
		[engine closeAllConnections];
		
		[self.delegate configurationDidComplete:self with:tweets];
		[tweets release];
	}
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