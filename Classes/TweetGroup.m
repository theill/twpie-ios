//
//  TweetGroup.m
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetGroup.h"


@implementation TweetGroup

@synthesize name, messages;

- (int)usageCount {
	int totalUsageCount = 0;
	
	if ([self messages]) {
		for (int i = 0; i < [[self messages] count]; i++) {
			totalUsageCount += [[[self messages] objectAtIndex:i] usageCount];
		}
	}
	
	return totalUsageCount;
}


@end
