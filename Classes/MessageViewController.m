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

@synthesize delegate, tweet, activity, characterCount;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[message setDelegate:self];
	[message setText:[[self tweet] tweet]];
	[message becomeFirstResponder];
	
	[self updateCharacterCount];
	
	self.navigationItem.title = @"New Tweet";

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
	
	// select 'text' part of tweet but only if it will not select entire message
	if (self.tweet && ![message.text isEqualToString:self.tweet.text]) {
		message.selectedRange = [message.text rangeOfString:self.tweet.text];
	}
}

- (MGTwitterEngine *)engine {
	if (_engine) {
		return _engine;
	}
	
	_engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
	[_engine setConsumerKey:TWITTER_CONSUMER_KEY secret:TWITTER_CONSUMER_SECRET];
	
#if ENABLE_OAUTH
	OAToken *token = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:@"twpie" prefix:@""];
	[_engine setAccessToken:token];
	[token release];
#else
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[_engine setUsername:[defaults stringForKey:@"username"] password:[defaults stringForKey:@"password"]];
#endif
	
	return _engine;
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
	[_engine release]; _engine = nil;
}

- (void)sendTweet {
	NSLog(@"Sending %@ update message to twitter", [message	text]);
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activity startAnimating];
	[[self engine] sendUpdate:[message text]];
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

- (void)updateCharacterCount {
	int charactersLeft = 140 - [[message text] length];
	[characterCount setText:[NSString stringWithFormat:@"%d", charactersLeft]];
	if (charactersLeft >= 0) {
		[characterCount setTextColor:[UIColor darkGrayColor]];
	}
	else {
		[characterCount setTextColor:[UIColor redColor]];
	}

}

#pragma mark -
#pragma mark UITextViewDelegate events

- (void)textViewDidChange:(UITextView *)textView {
	[self updateCharacterCount];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[message resignFirstResponder];
		[self sendTweet];
		return NO;
	}

	return YES;
}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//	if (event.type == UIEventSubtypeMotionShake) {
//		[message setText:@""];
//	}
//}

- (void)dealloc {
	if (_engine) {
		[_engine closeAllConnections];
		[_engine release];
		_engine = nil;
	}
	
	[super dealloc];
}

@end