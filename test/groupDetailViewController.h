//
//  groupDetailViewController.h
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface groupDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{
    IBOutlet UIView *view1;
    IBOutlet UIView *navigationView;
    IBOutlet UISegmentedControl *segmentControl;
    IBOutlet UITableView *postTable;
    IBOutlet UIImageView *grpPic;
    IBOutlet UICollectionView *membersCollection;
    IBOutlet UIButton *membersPostbutton;
    IBOutlet UILabel *navigationLabel;
    IBOutlet UILabel *grpnameLabel;
    IBOutlet UILabel *desLabel;
    IBOutlet UILabel *memLabel;
    NSString *commentIndex;
}


@property (nonatomic ,strong) NSString *grpnameString;
@property (nonatomic ,strong) NSString *desString;
@property (nonatomic ,strong) NSString *memString;
@property (nonatomic ,strong) UIImage *grpImg;
@property (nonatomic ,strong) NSMutableArray *membersArray;

-(IBAction)memberPostAction:(id)sender;

@end
