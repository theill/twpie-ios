//
//  MessageViewController.h
//  twpie
//
//  Created by Peter Theill on 7/14/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGTwitterEngine.h"
#import "TweetTemplate.h"

@protocol MessageViewControllerDelegate;

@interface MessageViewController : UIViewController {
	id<MessageViewControllerDelegate> delegate;
	TweetTemplate *selectedObject;
	MGTwitterEngine *engine;

	IBOutlet UITextView *message;
}

@property(nonatomic, assign) id delegate;
@property (nonatomic, retain) TweetTemplate *selectedObject;

@end

@protocol MessageViewControllerDelegate
- (void)tweetSent:(UIViewController *)controller text:(NSString *)t;
@end
