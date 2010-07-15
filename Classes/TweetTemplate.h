//
//  TweetTemplate.h
//  twpie
//
//  Created by Peter Theill on 7/15/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TweetTemplate : NSObject<NSCoding> {
	NSString *template;
}

- (id)initWithTemplate:(NSString *)tmpl;

@property(nonatomic, retain) NSString *template;

@end
