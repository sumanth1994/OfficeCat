//
//  createPostViewController.h
//  projectM
//
//  Created by Harinandan Teja on 7/6/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

CGFloat createPostLat;
CGFloat createPostLong;

@interface createPostViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UILabel *navigationLabel;
    IBOutlet UIView *navigationView;
    
    IBOutlet UICollectionView *imageCollection;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UITextView *descriptionView;
    
    NSDateFormatter *dateFormatter;
    NSDate *currDate;
    NSMutableArray *categoryNames;
    UIImagePickerController *imagePicker;
    UIActionSheet *attachPopup;
    UIActionSheet *locationPopup;
    UIDatePicker *datePicker;
    
    IBOutlet MKMapView *mapview;
    NSString *currentLocation;
}

@property (nonatomic , strong) NSMutableArray *imageArray;
@property (nonatomic , strong) NSMutableArray *categoryArray;
@property (nonatomic , strong) NSString *dateString;
@property (nonatomic , strong) NSString *desString;
@property (nonatomic , strong) NSString *locationString;
@property (nonatomic , strong) NSString *postLat;
@property (nonatomic , strong) NSString *postLong;
@property (nonatomic , strong) NSString *help;

-(IBAction)categoryAction:(id)sender;
-(IBAction)dateAction:(id)sender;
-(IBAction)attachAction:(id)sender;
-(IBAction)locationAction:(id)sender;
-(IBAction)postAction:(id)sender;

@end
