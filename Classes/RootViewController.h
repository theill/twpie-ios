//
//  RootViewController.h
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright Commanigy 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TweetTemplate.h"
#import "TweetRepository.h"

@interface RootViewController : UIViewController {

@private
	TweetRepository *tweetRepository;
	IBOutlet UITableView *messagesTableView;
}

- (void)editMessage:(TweetTemplate *)tweet;
- (void)setupSampleTweets;

@property (nonatomic, retain) UITableView *messagesTableView;
@property (nonatomic, retain, readonly) TweetRepository *tweetRepository;

@end
