//
//  moreOptionsViewController.h
//  test
//
//  Created by Poddar on 6/3/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

NSArray *optionsList;

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface moreOptionsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *optionsTabel;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *navigationLabel;
    IBOutlet UIButton *logoutButton;
    IBOutlet UIActivityIndicatorView *loggingout;
    IBOutlet UILabel *loggingOutLabel;
    NSTimer *mytimer;
}

-(IBAction)logoutAction:(id)sender;

@end
