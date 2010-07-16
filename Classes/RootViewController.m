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

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RootViewController

@synthesize messagesTableView;
@synthesize tweets;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

#if DEBUG
	[defaults setBool:TRUE forKey:@"setupcomplete"];
	[defaults setObject:@"asdf" forKey:@"username"];
	[defaults setObject:@"asdf" forKey:@"password"];
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

	self.navigationItem.title = @"Messages";
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	TweetTemplate *tweet = [self.tweets objectAtIndex:[indexPath row]];
	cell.textLabel.text = [tweet text];
}


#pragma mark -
#pragma mark Add a new object

- (void)insertNewObject {
	TweetTemplate *tweet = [[TweetTemplate alloc] initWithText:@""];
	[[self tweets] addObject:tweet];
	[tweet release];
	
	[self editMessage:[[self tweets] lastObject]];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"numberOfSectionsInTableView");
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"tableView:numberOfRowsInSection:");
	return [tweets count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"tableView:cellForRowAtIndexPath:");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"tableView:commitEditingStyle:");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[self tweets] removeObjectAtIndex:[indexPath row]];
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Clicked row at %d", indexPath.row);
	
	TweetTemplate *tweet = [[self tweets] objectAtIndex:[indexPath row]];
	[self editMessage:tweet];
}

- (void)editMessage:(TweetTemplate *)selectedObject {
	MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
	[messageViewController setSelectedObject:selectedObject];
	[self.navigationController pushViewController:messageViewController animated:YES];
	[messageViewController release];
}

#pragma mark -
#pragma mark Configuration events

- (void)configurationDidChange:(WelcomeViewController *)controller {
	NSLog(@"Configuration has changed");
	[self dismissModalViewControllerAnimated:YES];
	
	[self setupSampleTweets];
}

- (void)setupSampleTweets {
	TweetTemplate *tweet = [[TweetTemplate alloc] initWithText:@"@having [coffee?]"];
	[[self tweets] addObject:tweet];
	[tweet release];
	
	tweet = [[TweetTemplate alloc] initWithText:@"d reporting w [85.4?]"];
	[[self tweets] addObject:tweet];
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

