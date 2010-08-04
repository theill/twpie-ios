//
//  TweetCell.m
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

@synthesize tweet;
@synthesize groupNameLabel, messageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
	}
	return self;
}

- (void)configure:(TweetTemplate *)t {
	self.tweet = t;
	
	self.groupNameLabel.text = [tweet group];
//	self.messageLabel.text = [[tweet text] stringByAppendingFormat:@" (%d)", [tweet usageCount]];
	self.messageLabel.text = [tweet text];
	
	int offset = (self.groupNameLabel.text.length > 0) ? 8 : 0;
	
	CGSize sizeToMakeLabel = [self.groupNameLabel.text sizeWithFont:self.groupNameLabel.font];
	self.groupNameLabel.frame = CGRectMake(self.groupNameLabel.frame.origin.x,
										   self.groupNameLabel.frame.origin.y,
										   sizeToMakeLabel.width,
										   self.groupNameLabel.frame.size.height);
	self.messageLabel.frame = CGRectMake(self.groupNameLabel.frame.origin.x + self.groupNameLabel.frame.size.width + offset,
										 self.messageLabel.frame.origin.y,
										 self.frame.size.width - (self.groupNameLabel.frame.origin.x + self.groupNameLabel.frame.size.width + offset) - 8,
										 self.messageLabel.frame.size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}


- (void)dealloc {
	[super dealloc];
}


@end