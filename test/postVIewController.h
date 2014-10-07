//
//  postVIewController.h
//  test
//
//  Created by Poddar on 5/21/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import <FXBlurView/FXBlurView.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

NSMutableArray *post;
NSArray *locationArray;

NSString *replyValue;
NSString *replyString;
NSString *replyPostId;

float lati;
float longi;

@interface postVIewController : UIViewController <UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate,RNGridMenuDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    IBOutlet UITableView *postTable;
    IBOutlet UITableView *categoryTable;
    
    IBOutlet UISlider *locationRadius;
    IBOutlet UILabel *radiusLabel;
    IBOutlet UIButton *locationButton;
    IBOutlet UILabel *locationLabel;
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    BOOL sideBool;
    NSMutableArray *categoryArray;
    
    IBOutlet UIButton *navigationButton;
    IBOutlet UIButton *searchNavigationButton;
    IBOutlet UIView *navigationView;
    
    IBOutlet UIView *searchView;
    IBOutlet UISearchBar *searchBar;
    
    NSString *currentLocation;
    NSString *preferredLocation1;
    NSString *preferredLocation2;
    NSString *customLocation;
    
    int newPostsCount;
    
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatter_help;
    NSTimeInterval secs;
    
    FXBlurView *blurView;
    UIRefreshControl *refreshControl;
    IBOutlet MKMapView *mapview;
    
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
-(IBAction)searchAction:(id)sender;
-(IBAction)radiusAction:(id)sender;
-(IBAction)location:(id)sender;
-(IBAction)replyAction:(id)sender;
-(IBAction)searchBackAction:(id)sender;
@end
