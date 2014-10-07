//
//  notificationViewController.h
//  test
//
//  Created by Harinandan Teja on 6/12/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface notificationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tableView1;
    IBOutlet UITableView *tableView2;
    IBOutlet UITableView *tableView3;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *navigationLabel;
}

@end
