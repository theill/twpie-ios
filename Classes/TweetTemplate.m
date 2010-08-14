//
//  TweetTemplate.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetTemplate.h"

@implementation TweetTemplate

@synthesize text, group, usageCount, updatedAt;

- (id)initWithText:(NSString *)t group:(NSString *)g {
	self.text = t;
	self.group = g;
	self.usageCount = 1;
	self.updatedAt = [NSDate date];

	return self;
}

- (id)initWithTweet:(NSString *)tweet {
	return [self initWithText:[self extractTextFrom:tweet] group:[self extractGroupFrom:tweet]];
}

- (void)increase {
	self.usageCount++;
	self.updatedAt = [NSDate date];
}

- (NSString *)extractGroupFrom:(NSString *)tweet {
	NSArray *parts = [tweet componentsSeparatedByString:@" "];
	if ([parts count] <= 1) {
		// no group if only one word
		return @"";
	}
	
	if ([[[parts objectAtIndex:0] lowercaseString] isEqual:@"d"] && [parts count] > 1) {
		return [NSString stringWithFormat:@"d %@", [parts objectAtIndex:1]];
	}
	
	if ([[parts objectAtIndex:0] hasPrefix:@"@"]) {
		return [parts objectAtIndex:0];
	}
	
	return @"";
}

- (NSString *)extractTextFrom:(NSString *)tweet {
	return [[tweet substringFromIndex:[[self extractGroupFrom:tweet] length]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)tweet {
	if (self.group && [self.group length] > 0) {
		return [NSString stringWithFormat:@"%@ %@", self.group, self.text];
	}
	else {
		return self.text;
	}
}

- (void)setTweet:(NSString *)tweet {
	self.group = [self extractGroupFrom:tweet];
	self.text = [self extractTextFrom:tweet];
}


- (void)dealloc {
	[text release];
	[group release];
	[updatedAt release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Encoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Encode properties, other class variables, etc
	[encoder encodeObject:self.text forKey:@"text"];
	[encoder encodeObject:self.group forKey:@"group"];
	[encoder encodeInt:self.usageCount forKey:@"usage_count"];
	[encoder encodeObject:self.updatedAt forKey:@"updated_at"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init];
	if (self != nil) {
		//decode properties, other class vars
		self.text = [decoder decodeObjectForKey:@"text"];
		self.group = [decoder decodeObjectForKey:@"group"];
		self.usageCount = [decoder decodeIntForKey:@"usage_count"];
		self.updatedAt = [decoder decodeObjectForKey:@"updated_at"];
	}
	return self;
}

@end
