//
//  TweetTemplate.m
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetTemplate.h"


@implementation TweetTemplate

@synthesize template;

- (id)initWithTemplate:(NSString *)tmpl {
	self.template = tmpl;

	return self;
}

#pragma mark -
#pragma mark Encoding

- (void)encodeWithCoder:(NSCoder *)encoder {
	//Encode properties, other class variables, etc
    [encoder encodeObject:self.template	forKey:@"template"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
		//decode properties, other class vars
        self.template = [decoder decodeObjectForKey:@"template"];
    }
    return self;
}

@end
