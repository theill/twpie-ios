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

@interface MessageViewController : UIViewController {
	TweetTemplate *selectedObject;
	MGTwitterEngine *engine;

	IBOutlet UITextView *message;
}

@property (nonatomic, retain) TweetTemplate *selectedObject;

@end
