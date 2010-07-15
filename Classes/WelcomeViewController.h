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
	IBOutlet UITextField *usernameTextField;
	IBOutlet UITextField *passwordTextField;

	MGTwitterEngine *engine;
}

- (IBAction)settingsDone:(id)sender;

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) UITextField *usernameTextField;
@property(nonatomic, retain) UITextField *passwordTextField;

@end

@protocol WelcomeViewControllerDelegate
- (void)configurationDidChange:(WelcomeViewController *)controller;
@end
