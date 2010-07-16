//
//  TweetCell.h
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetTemplate.h"

@interface TweetCell : UITableViewCell {
	TweetTemplate *template;
}

@property (nonatomic, retain) TweetTemplate *template;

@end
