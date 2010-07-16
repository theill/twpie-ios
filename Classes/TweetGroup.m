//
//  TweetGroup.m
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetGroup.h"
#import "TweetTemplate.h"

@implementation TweetGroup

@synthesize name, messages;

NSInteger usageCountUpdatedSort(id msg1, id msg2, void *context) {
	int usageCount1 = [msg1 usageCount];
    int usageCount2 = [msg2 usageCount];
    if (usageCount1 < usageCount2) {
		return NSOrderedDescending;
	}
    else if (usageCount1 > usageCount2) {
		return NSOrderedAscending;
    }
	else {
		if ([msg1 updatedAt] < [msg2 updatedAt]) {
			return NSOrderedDescending;
		}
		else if ([msg1 updatedAt] < [msg2 updatedAt]) {
			return NSOrderedAscending;
		}
		return NSOrderedSame;
	}
}

//
// Adds a new message to group. In case message already is available
// its usage count will be increased and last updated at value set.
//
- (void)addMessage:(NSString *)message {
	TweetTemplate *t = [[self messages] valueForKey:message];
	if (t) {
		[t increase];
	}
	else {
		t = [[TweetTemplate alloc] initWithText:message];
		[[self messages] valueForKey:message];
		[t release];
	}
}

//
// Returns messages weighted by usage count and updated date.
//
- (NSArray *)weighted {
	NSArray *msgs = [[self messages] allValues];
	
	// sort by usage count and then by last updated at
	NSArray *sortedArray = [msgs sortedArrayUsingFunction:usageCountUpdatedSort context:NULL];
	
	return sortedArray;
	
	// FIXME: is 'sortedArray' it autoreleased?
}

//
// Iterate all messages and get total usage count.
//
- (int)usageCount {
	int totalUsageCount = 0;
	
	if ([self messages]) {
		NSArray *msgs = [[self messages] allValues];
		for (int i = 0; i < [msgs count]; i++) {
			totalUsageCount += [[msgs objectAtIndex:i] usageCount];
		}
	}
	
	return totalUsageCount;
}


@end
