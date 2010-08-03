//
//  TweetRepository.h
//  twpie
//
//  Created by Peter Theill on 8/3/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetTemplate.h"

@interface TweetRepository : NSObject {
	NSMutableDictionary *tweets;
}

- (void)add:(TweetTemplate *)tweet;
- (NSMutableArray *)weighted;

@property (nonatomic, retain) NSMutableDictionary *tweets;

@end