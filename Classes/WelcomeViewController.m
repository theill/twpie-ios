//
//  WelcomeViewController.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "WelcomeViewController.h"
#import "TwitterSettings.h"

@implementation WelcomeViewController

@synthesize usernameTextField, passwordTextField, introduction, activity;
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[usernameTextField becomeFirstResponder];
	
	defaults = [NSUserDefaults standardUserDefaults];
	engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
	[engine setConsumerKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
	[engine setClientName:@"web" version:@"1.0" URL:@"" token:@""];
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
	NSLog(@"Settings done!");
	
	[defaults setBool:FALSE forKey:@"setupcomplete"];
	
//	[self hideKeyboard];
	[activity startAnimating];
//	[saveButton setEnabled:NO];

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
	NSLog(@"requestSucceeded : %@", requestIdentifier);
	if ([requestIdentifier isEqual:userTimelineToken]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings Saved" message:@"Your twitter details have been saved and tested" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[activity stopAnimating];
//		[saveButton setEnabled:YES];
		
		[engine closeAllConnections];
		
		[defaults setBool:TRUE forKey:@"setupcomplete"];
		[alert show];
		[alert release];
		
//		[self dismissModalViewControllerAnimated:YES];
		[self.delegate configurationDidComplete:self];
	}
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error{
	NSLog(@"requestFailed:%@withError%@", requestIdentifier, error );
	if ([requestIdentifier isEqual:xauthRequestToken]) {
		[activity stopAnimating];
		[introduction setText:@"Your username and password could not be verified. Try again!"];
		[usernameTextField becomeFirstResponder];
	} else if ([requestIdentifier isEqual:userTimelineToken]) {
		//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Your twitter details are either incorrect or Twitter is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[activity stopAnimating];
//		[saveButton setEnabled:YES];
		//[alert show];
		//[alert release];
		
		[introduction setText:@"Your username and password could not be verified. Try again!"];
		
		[usernameTextField becomeFirstResponder];
	}
}

- (void)accessTokenReceived:(OAToken *)token forRequest:(NSString *)connectionIdentifier {
	NSLog(@"got access token %@", token);

	if ([connectionIdentifier isEqual:xauthRequestToken]) {
		[engine setAccessToken:token];
		[token storeInUserDefaultsWithServiceProviderName:@"twpie" prefix:@""];
		
		[activity stopAnimating];
		[engine closeAllConnections];
		
		[defaults setBool:TRUE forKey:@"setupcomplete"];
		[self.delegate configurationDidComplete:self];
	}
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	// we don't need to use this information yet - in a future release it could make sense
	// to analyse a bulk of messsages and try to recognize any patterns
//	NSLog(@"statusesReceived: %d and %@", [statuses count], connectionIdentifier);
//	
//	if ([statuses count] > 0) {
//		NSEnumerator *enumerator = [statuses objectEnumerator];
//		NSDictionary *dict;
//		
//		while (dict = [enumerator nextObject]) {
//			NSString *txt = [dict objectForKey:@"text"];
//			NSLog(@"we got %@", txt);
//		}		
//	}
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
	[engine closeAllConnections];
	[engine release];
	
	[super dealloc];
}

@end