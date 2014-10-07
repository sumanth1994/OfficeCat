//
//  groupViewCell.m
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "groupViewCell.h"

@implementation groupViewCell

@synthesize gotoButton;
@synthesize grpPic;
@synthesize nameLabel;
@synthesize descriptionLabel;
@synthesize view1;
@synthesize view2;
@synthesize postsLabel;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
