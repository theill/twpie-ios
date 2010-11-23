//
//  WelcomeViewController.h
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"MGTwitterEngine.h"

@protocol WelcomeViewControllerDelegate;

@interface WelcomeViewController : UIViewController {
	id<WelcomeViewControllerDelegate> delegate;
	MGTwitterEngine *engine;
	
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;
	IBOutlet UITextView *introduction;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UILabel *status;

@private
	NSUserDefaults *defaults;
	NSMutableDictionary *_tweets;
	NSString *userTimelineToken, *xauthRequestToken, *sentDirectMessagesToken;
}

- (IBAction)settingsDone:(id)sender;
- (void)populate:(NSMutableDictionary *)tweets with:(NSArray *)msgs;
- (NSMutableDictionary *)tweets;

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) UITextField *usernameTextField;
@property(nonatomic, retain) UITextField *passwordTextField;
@property(nonatomic, retain) UITextView *introduction;
@property(nonatomic, retain) UIActivityIndicatorView *activity;

@end

@protocol WelcomeViewControllerDelegate
- (void)configurationDidComplete:(WelcomeViewController *)controller with:(NSMutableDictionary *)tweets;
@end
