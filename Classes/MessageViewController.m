//
//  MessageViewController.m
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "MessageViewController.h"


@implementation MessageViewController

@synthesize selectedObject;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	TweetTemplate *tweet = selectedObject;
	
	NSLog(@"Loading tweet %@", tweet);
	
	[message setText:[tweet text]];
	[message becomeFirstResponder];
	
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendTweet)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [sendButton release];
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
	[[self selectedObject] setText:[message text]];
	
	engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
	[engine setClientName:@"web" version:nil URL:nil token:nil];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[engine setUsername:[defaults stringForKey:@"username"] password:[defaults stringForKey:@"password"]];
		
	NSLog(@"Sending %@ update message to twitter", [message	text]);
	[engine sendUpdate:[message text]];	
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	NSLog(@"Got back response for identifier %@", connectionIdentifier);
	
	// pop controller once message has been successfully sent
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	NSLog(@"Failed to send tweet for identifier %@. Got error %@", connectionIdentifier, error);
	
	// we might pop up welcome screen here?
}

- (void)dealloc {
    [super dealloc];
}


@end

