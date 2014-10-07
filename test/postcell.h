//
//  postcell.h
//  test
//
//  Created by Poddar on 5/20/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface postcell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *desLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *latLabel;
@property (nonatomic, weak) IBOutlet UILabel *longLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *repliesLabel;
@property (nonatomic, weak) IBOutlet UILabel *dataLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView2;

@property (nonatomic, weak) IBOutlet UIButton *replyButton;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;
@property (nonatomic, weak) IBOutlet UIButton *gotoPostButton;

@property (nonatomic, weak) IBOutlet UIView *backView1;
@property (nonatomic, weak) IBOutlet UIView *backView2;
@property (nonatomic, weak) IBOutlet UIView *backView3;
@property (nonatomic, weak) IBOutlet UITextField *replyTextField;
@property (nonatomic, weak) IBOutlet UILabel *postID;
@end
