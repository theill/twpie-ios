//
//  WelcomeViewController.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "WelcomeViewController.h"

@implementation WelcomeViewController

NSUserDefaults *defaults;
NSString *followersToken;

@synthesize usernameTextField, passwordTextField;
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[usernameTextField becomeFirstResponder];
	
	defaults = [NSUserDefaults standardUserDefaults];
	engine = [[MGTwitterEngine twitterEngineWithDelegate:self] retain];
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
	
	[defaults setObject:usernameTextField.text forKey:@"username"];
	[defaults setObject:passwordTextField.text forKey:@"password"];
//	[self hideKeyboard];
//	[saveProgress startAnimating];
//	[saveButton setEnabled:NO];
	
	[engine setUsername:[defaults stringForKey:@"username"] password:[defaults stringForKey:@"password"]];
	[engine setClientName:@"web" version:@"1.0" URL:@"" token:@""];
	
	followersToken = [engine getFollowersIncludingCurrentStatus:YES]; 
}

#pragma mark -
#pragma mark Twitter authentication

- (void)requestSucceeded:(NSString *)requestIdentifier{
	NSLog(@"requestSucceeded : %@", requestIdentifier);
	if ([requestIdentifier isEqual:followersToken]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings Saved" message:@"Your twitter details have been saved and tested" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[saveProgress stopAnimating];
//		[saveButton setEnabled:YES];
		
		[engine closeAllConnections];
		
		[defaults setBool:TRUE forKey:@"setupcomplete"];
		[alert show];
		[alert release];
		
//		[self dismissModalViewControllerAnimated:YES];
		[self.delegate configurationDidChange:self];
	}
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error{
	NSLog(@"requestFailed:%@withError%@", requestIdentifier, error );
	if ([requestIdentifier isEqual:followersToken]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Your twitter details are either incorrect or Twitter is down." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[saveProgress stopAnimating];
//		[saveButton setEnabled:YES];
		[alert show];
		[alert release];
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
    [super dealloc];
	
	[engine closeAllConnections];
	[engine release];
}


@end

