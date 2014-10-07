//
//  chatListViewController.h
//  test
//
//  Created by Harinandan Teja on 6/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface chatListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIView *navigationView;
    IBOutlet UITableView *chatTable;
    IBOutlet UISearchBar *searchBar;
}

-(IBAction)addAction:(id)sender;

@end
