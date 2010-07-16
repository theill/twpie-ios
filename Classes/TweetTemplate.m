//
//  TweetTemplate.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetTemplate.h"

@implementation TweetTemplate

@synthesize text, usageCount, updatedAt;

- (id)initWithText:(NSString *)t {
	self.text = t;
	self.usageCount = 0;
	self.updatedAt = [NSDate date];

	return self;
}

- (void)dealloc {
	[super dealloc];
	[text release];
	[updatedAt release];
}

#pragma mark -
#pragma mark Encoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Encode properties, other class variables, etc
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeInt:self.usageCount forKey:@"usage_count"];
    [encoder encodeObject:self.updatedAt forKey:@"updated_at"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
		//decode properties, other class vars
        self.text = [decoder decodeObjectForKey:@"text"];
        self.usageCount = [decoder decodeIntForKey:@"usage_count"];
        self.updatedAt = [decoder decodeObjectForKey:@"updated_at"];
    }
    return self;
}

@end
