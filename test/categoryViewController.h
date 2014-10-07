//
//  categoryViewController.h
//  test
//
//  Created by Poddar on 5/21/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableArray *categoryArray;

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

NSMutableArray *categoryArray;

@interface categoryViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    IBOutlet UITableView *postTable;
}

@end
