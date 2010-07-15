//
//  RootViewController.h
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright Commanigy 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RootViewController : UIViewController {

@private
	NSMutableArray *tweets;
	IBOutlet UITableView *messagesTableView;
}

- (void)editMessage:(NSString *)obj;
- (void)setupSampleTweets;

@property (nonatomic, retain) UITableView *messagesTableView;
@property (nonatomic, retain) NSMutableArray *tweets;

@end
