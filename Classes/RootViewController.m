//
//  RootViewController.m
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright Commanigy 2010. All rights reserved.
//

#import "RootViewController.h"
#import "MessageViewController.h"
#import "WelcomeViewController.h"
#import "TweetCell.h"

@interface RootViewController ()
- (void)configureCell:(TweetCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RootViewController

@synthesize tweetRepository;
@synthesize messagesTableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

#if DEBUG
	[defaults setBool:TRUE forKey:@"setupcomplete"];
	[defaults setObject:@"theilltest" forKey:@"username"];
	[defaults setObject:@"653976" forKey:@"password"];
	if ([[[self tweetRepository] tweets] count] == 0) {
		[self setupSampleTweets];
	}
#endif
	if ([defaults boolForKey:@"setupcomplete"] == YES) {
		NSLog(@"Setup complete, just continue with normal work");
	}
	else {
		NSLog(@"We need to ask user for credentials");
		
		WelcomeViewController *welcome = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
		//[welcome setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		[welcome setDelegate:self];

		[self presentModalViewController:welcome animated:NO];
		[welcome release];
	}

	self.navigationItem.title = @"Tweets";
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
}

/*
// Implement viewWillAppear: to do additional setup before the view is presented.
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
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)configureCell:(TweetCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	TweetTemplate *tweet = [[[self tweetRepository] weighted] objectAtIndex:[indexPath row]];
	[cell configure:tweet];
}


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
	[self editMessage:nil];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"numberOfSectionsInTableView");
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"tableView:numberOfRowsInSection:");
	return [[[self tweetRepository] tweets] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil] objectAtIndex:0];
		UIView *selectedView = [[UIView alloc] init];
		selectedView.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:215/255.0 alpha:1.0];
		cell.selectedBackgroundView = selectedView;
		[selectedView release];
//		cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCellBackground.png"]] autorelease];
		
//		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//		[cell setSelectedBackgroundView:<#(UIView *)#>

		//		UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updates-bg.png"]];
		//		[cell setBackgroundView:bgView];
		
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// The table view should not be re-orderable.
	return NO;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"tableView:commitEditingStyle:");
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		TweetTemplate *doomed = [[[self tweetRepository] weighted] objectAtIndex:[indexPath row]];
		[[[self tweetRepository] tweets] removeObjectForKey:[doomed tweet]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Clicked row at %d", indexPath.row);
	
	TweetTemplate *tweet = [[[self tweetRepository] weighted] objectAtIndex:indexPath.row];
	[self editMessage:tweet];
}

- (void)editMessage:(TweetTemplate *)tweet {
	MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
	[messageViewController setTweet:tweet];
	[messageViewController setDelegate:self];
	[self.navigationController pushViewController:messageViewController animated:YES];
	[messageViewController release];
}

#pragma mark -
#pragma mark Configuration events

- (void)configurationDidComplete:(WelcomeViewController *)controller {
	NSLog(@"Configuration completed and user is successfully authenticated with Twitter");
	[self dismissModalViewControllerAnimated:YES];
	
	[self setupSampleTweets];
}

#pragma mark -
#pragma mark Tweet events

- (void)tweetSent:(UIViewController *)controller text:(NSString *)t {
	NSLog(@"tweetSent");
	
	TweetTemplate *tt = [[TweetTemplate alloc] initWithTweet:t];
	[[self tweetRepository] add:tt];
	[tt release];
	
	[[self messagesTableView] reloadData];
}

#pragma mark -

- (void)setupSampleTweets {
	TweetTemplate *tweet = [[TweetTemplate alloc] initWithTweet:@"@having coffee"];
	[[self tweetRepository] add:tweet];
	[tweet release];
	
	tweet = [[TweetTemplate alloc] initWithTweet:@"@having a beer"];
	[[self tweetRepository] add:tweet];
	[tweet release];
	
	tweet = [[TweetTemplate alloc] initWithTweet:@"d reporting w 85.4"];
	[[self tweetRepository] add:tweet];
	[tweet release];
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
}


- (void)dealloc {
	[super dealloc];
}


@end