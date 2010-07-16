//
//  TweetCell.m
//  twpie
//
//  Created by Peter Theill on 7/16/10.
//  Copyright 2010 Commanigy. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

@synthesize template;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
