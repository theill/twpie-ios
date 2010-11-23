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
@synthesize groupNameLabel, messageLabel, countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
	}
	return self;
}

-(void)awakeFromNib {
	UIImage *image = [UIImage imageNamed:@"updates-bg.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.contentMode = UIViewContentModeScaleToFill;
	self.backgroundView = imageView;
	[imageView release];
	
	UIView *selectedView = [[UIView alloc] init];
	selectedView.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:215/255.0 alpha:0.40];
	self.selectedBackgroundView = selectedView;
	[selectedView release];
	//		cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SelectedCellBackground.png"]] autorelease];
	
	//		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	//		[cell setSelectedBackgroundView:<#(UIView *)#>
	
	//		UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"updates-bg.png"]];
	//		[cell setBackgroundView:bgView];
	
	//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
}


- (void)configure:(TweetTemplate *)t {
	self.tweet = t;
	
	self.groupNameLabel.text = [tweet group];
	self.messageLabel.text = [tweet text];
	self.countLabel.text = [NSString stringWithFormat:@"%d", [tweet usageCount]];
	
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