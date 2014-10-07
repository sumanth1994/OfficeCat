//
//  groupPostCell.m
//  chatPart
//
//  Created by Harinandan Teja on 6/30/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "groupPostCell.h"

@implementation groupPostCell

@synthesize commentButton;
@synthesize view1;
@synthesize commentTable;
@synthesize nameLabel;
@synthesize timeLabel;

- (void)awakeFromNib
{
    // Initialization code
    self.descriptionLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)changeSizewithx:(int)x;
{
    self.view2.frame = CGRectMake(0, 0, 10, 10);
}

@end
