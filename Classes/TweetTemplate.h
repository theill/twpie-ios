//
//  TweetTemplate.h
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

/*
 
 d reporting w 81.3
 d reporting w 81.3
 d reporting w 84.1
 d reporting t call jonas re: dakofa
 @having coffee
 d having coffee
 d having coffee
 d having a snack
 d having a nice cup of coffee
 d having coffee
 d having a glass of wine
 
 = how to recognize above sentences?
 
 * look at patterns such as "d <username> <message>"
   and "@<username> <message>"
 
 * group patterns and sort by overall total usage count, then
   message usage count and finally by descending creation date
   e.g. above sentences would result in
 
   d having == (6)
     coffee (3)
     a glass of wine (1)
     a nice cup of coffee (1)
     a snack (1)
 
   d reporting == (4)
     w 81.3 (2)
     t call jonas re: dakofa (1)
     w 84.1 (1)
   
   @having == (1)
     coffee (1)
 
 = retweets
 
 we do not need to support this
 
 = classes
 
 TweetGroup
   name (NSString with e.g. 'd reporting')
   messages (NSArray of TweetMessage instances)
 
 TweetMessage (aka TweetTemplate)
   text (NSString with e.g. 'w 81.3')
   usage_count (int, number of uses for this specific message)
   updated_at (DateTime for last increase in 'usage_count')
 
 */

#import <Foundation/Foundation.h>

@interface TweetTemplate : NSObject<NSCoding> {
	// template for tweet e.g. "d reporting w [86.1]"
	NSString *text;
	int usageCount;
	NSDate *updatedAt;
}

- (id)initWithText:(NSString *)t;

@property(nonatomic, retain) NSString *text;
@property (nonatomic) int usageCount;
@property(nonatomic, retain) NSDate *updatedAt;

@end
