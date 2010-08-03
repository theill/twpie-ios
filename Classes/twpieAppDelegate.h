//
//  twpieAppDelegate.h
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright Commanigy 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TweetRepository.h"

@interface twpieAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UINavigationController *navigationController;

@private
//	TweetRepository *tweetRepository;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (NSString *)applicationDocumentsDirectory;

@end

