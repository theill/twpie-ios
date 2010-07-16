//
//  TweetGroup.h
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TweetGroup : NSObject {
	NSString *name;
	NSMutableDictionary *messages;
}

- (int)usageCount;
- (void)addMessage:(NSString *)message;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableDictionary *messages;

@end
