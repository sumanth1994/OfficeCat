//
//  profileEditViewController.h
//  test
//
//  Created by Harinandan Teja on 6/12/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface profileEditViewController : UIViewController 
{
    IBOutlet UIImageView *proPic;
    IBOutlet UIImageView *coverPic;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIView *profileView;
    IBOutlet UIView *editView;
    
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *firstNameLabel;
    IBOutlet UILabel *lastNameLabel;
    IBOutlet UILabel *phoneNumLabel;
    IBOutlet UILabel *sexLabel;
    IBOutlet UILabel *dobLabel;
    
    IBOutlet UILabel *editEmailLabel;
    IBOutlet UITextField *firstNameField;
    IBOutlet UITextField *lastNameField;
    IBOutlet UITextField *phoneNumField;
    IBOutlet UILabel *editsexLabel;
    IBOutlet UILabel *editdobLabel;
    IBOutlet UIButton *changeSexButton;
    IBOutlet UIButton *changeDobButton;
    
    IBOutlet UIButton *editButton;
}

-(IBAction)editAction:(id)sender;

@end
