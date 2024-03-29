//
//  TweetRepository.m
//  twpie
//
//  Created by Peter Theill on 8/3/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetRepository.h"
#import "TweetSorting.h"

@implementation TweetRepository

@synthesize tweets;

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
		// sort by latest update time if usage count is the same
		return [[msg2 updatedAt] compare:[msg1 updatedAt]];
	}
}

- (id)init {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableArray *weightedTweets;
	
	NSData *dataRepresentingSavedArray = [defaults objectForKey:@"tweets"];
	if (dataRepresentingSavedArray != nil) {
		NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
		if (oldSavedArray != nil) {
			weightedTweets = [[NSMutableArray alloc] initWithArray:oldSavedArray];
		}
		else {
			weightedTweets = [[NSMutableArray alloc] init];
		}
	}
	else {
		weightedTweets = [[NSMutableArray alloc] init];
	}
	
	tweets = [[NSMutableDictionary alloc] init];
	
	// insert tweets into dictionary
	NSEnumerator *enumerator = [weightedTweets objectEnumerator];
	
	TweetTemplate *tweet;
	while (tweet = [enumerator nextObject]) {
		[[self tweets] setObject:tweet forKey:[tweet tweet]];
	}
	
	[weightedTweets release];
	
	return self;
}

- (void)add:(TweetTemplate *)tweet {
	TweetTemplate *t = [[self tweets] objectForKey:[tweet tweet]];
	if (t) {
		[t increase];
	}
	else {
		[[self tweets] setObject:tweet forKey:[tweet tweet]];
	}
}

- (void)persistTweets {
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[self weighted]];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:myEncodedObject forKey:@"tweets"];
}

// sort by usage count and then by last updated at
- (NSMutableArray *)weighted {
	NSArray *sortedArray = [[self.tweets allValues] sortedArrayUsingFunction:usageCountUpdatedSort context:NULL];
	return [NSMutableArray arrayWithArray:sortedArray];
}

- (void)dealloc {
	[tweets release];
	[super dealloc];
}

@end
