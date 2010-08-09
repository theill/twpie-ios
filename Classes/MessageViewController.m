//
//  MessageViewController.m
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "MessageViewController.h"
#import "TwitterSettings.h"

@implementation MessageViewController

@synthesize delegate, tweet, activity;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[message setText:[[self tweet] tweet]];
	[message becomeFirstResponder];
	
	self.navigationItem.title = @"New Tweet";

	engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
	[engine setConsumerKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
	
#if ENABLE_OAUTH
	OAToken *token = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:@"twpie" prefix:@""];
	[engine setAccessToken:token];
	[token release];
#else
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[engine setUsername:[defaults stringForKey:@"username"] password:[defaults stringForKey:@"password"]];
#endif
	
//	UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
//	self.navigationItem.rightBarButtonItem = sendButton;
//	[sendButton release];
}

/*
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// select 'text' part of tweet
	if (self.tweet) {
		message.selectedRange = [message.text rangeOfString:self.tweet.text];
	}
}

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

- (void)sendTweet {
	NSLog(@"Sending %@ update message to twitter", [message	text]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activity startAnimating];
	[engine sendUpdate:[message text]];
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activity stopAnimating];
	
	[self.delegate tweetSent:self text:[message text]];

	// pop controller once message has been successfully sent
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	NSLog(@"Failed to send tweet for identifier %@. Got error %@", connectionIdentifier, error);

	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activity stopAnimating];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet not sent" message:@"Unable to tweet at the moment. Twitter might be down. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[message becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[message resignFirstResponder];
		[self sendTweet];
		return NO;
	}

	return YES;
}

- (void)dealloc {
	[engine closeAllConnections];
	[engine release];
	
	[super dealloc];
}

@end