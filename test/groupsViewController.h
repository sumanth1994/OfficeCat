//
//  groupsViewController.h
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface groupsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    IBOutlet UIView *navigationView;
    IBOutlet UIButton *newChatButton;
    IBOutlet UITableView *grpTable;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UILabel *navigationLabel;
    NSMutableArray *membersID;
    NSMutableArray *groupsArray;
    NSMutableArray *searchArray;
}

@end
