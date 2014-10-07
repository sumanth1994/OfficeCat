//
//  groupViewCell.h
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface groupViewCell : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *membersLabel;
@property (nonatomic, weak) IBOutlet UIImageView *grpPic;
@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;
@property (nonatomic, weak) IBOutlet UIButton *gotoButton;
@property (nonatomic, weak) IBOutlet UILabel *postsLabel;

@end
