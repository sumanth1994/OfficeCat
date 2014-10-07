//
//  groupMapViewController.h
//  test
//
//  Created by Harinandan Teja on 7/5/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface groupMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MKMapViewDelegate>{
    
    CGFloat grpMapLat;
    CGFloat grpMapLong;
    IBOutlet UILabel *navigationLabel;
    IBOutlet UIView *navigationView;
    MKPointAnnotation *annotation;
    IBOutlet MKMapView *mapview;
    IBOutlet UILabel *locationLabel;
    IBOutlet UISearchBar *searchbar;
    IBOutlet UITableView *searchTable;
    
    NSMutableArray *suggestionsArray;
}

@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , strong) NSMutableArray *categoryArray;
@property (nonatomic , strong) NSString *dateString;
@property (nonatomic , strong) NSString *desString;
@property (nonatomic , strong) NSString *locationString;
@property (nonatomic , strong) NSString *postLat;
@property (nonatomic , strong) NSString *postLong;
@property (nonatomic , strong) NSString *grpID;

@property (nonatomic , strong) NSString *from;

-(IBAction)cancelAction:(id)sender;
-(IBAction)saveAction:(id)sender;

@end
