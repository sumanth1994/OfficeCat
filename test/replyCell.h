//
//  replyCell.h
//  test
//
//  Created by Poddar on 6/6/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface replyCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *replyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profilePic;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
