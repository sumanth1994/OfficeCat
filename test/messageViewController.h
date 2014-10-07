//
//  messageViewController.h
//  test
//
//  Created by Harinandan Teja on 6/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface messageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIView *navigationView;
    IBOutlet UITableView *messageTable;
    IBOutlet UILabel *friendName;
    IBOutlet UIImageView *friendPic;
    IBOutlet UIImageView *profilePic;
    IBOutlet UIView *sendMessageView;
}

@end
