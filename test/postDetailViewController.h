//
//  postDetailViewController.h
//  test
//
//  Created by Poddar on 6/6/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

NSString *replyString;

@interface postDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    IBOutlet UICollectionView *imageCollection;
}
@property (nonatomic,strong) IBOutlet UIView *userReplyView;
@property (nonatomic,strong) IBOutlet UIView *postProfileView;
@property (nonatomic,strong) IBOutlet UIView *statusView;
@property (nonatomic,strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic,strong) IBOutlet UILabel *postProfileNameLabel;
@property (nonatomic,strong) IBOutlet UILabel *categoryAndAddressLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic,strong) IBOutlet UIImageView *postProfilePic;
@property (nonatomic,strong) IBOutlet UIImageView *userProfilePic;
@property (nonatomic,strong) IBOutlet UITextField *replyTextField;
@property (nonatomic,strong) IBOutlet UITableView *replyTable;
@property (nonatomic,strong) IBOutlet MKMapView *mapview;
@property (nonatomic,strong) IBOutlet UIButton *sendButton;

@property (nonatomic,strong) NSString *descriptionText;
@property (nonatomic,strong) NSString *postProfileNameText;
@property (nonatomic,strong) NSString *categoryText;
@property (nonatomic,strong) NSString *timeText;
@property (nonatomic,strong) NSString *distanceText;
@property (nonatomic,strong) NSString *repliesText;
@property (nonatomic,strong) NSString *latitudeText;
@property (nonatomic,strong) NSString *longitudeText;
@property (nonatomic,strong) UIImage *postProfileImage;
@property (nonatomic,strong) UIImage *userProfileImage;
@property (nonatomic,strong) NSString *postID;
@property (nonatomic,strong) NSMutableArray *replyArray;
@property (nonatomic,strong) NSMutableArray *imageArray;

-(IBAction)replyEditingAction:(id)sender;
-(IBAction)sendReplyAction:(id)sender;
@end
