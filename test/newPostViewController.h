//
//  newPostViewController.h
//  test
//
//  Created by Poddar on 5/22/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <FXBlurView/FXBlurView.h>
#import <CoreLocation/CoreLocation.h>

@class mapViewController;

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

UIActionSheet *popup;
UIActionSheet *locationPopup;
NSArray *categoryNames;
NSMutableArray *selectedIndex;
NSMutableArray *selectedImages;
NSInteger selectedImageIndex;

//for parsing
NSMutableArray *selectedCategories;
NSString *descriptionData;
NSString *latitude;
NSString *longitude;
NSString *dateForEvent;
NSString *emailId;
NSString *locationAdress;
NSMutableArray *imageNameArray;
NSData *imageData;
NSMutableArray  *arrayImageData;

float lat_newPost;
float lon_newPost;

@interface newPostViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPageViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate>{
    
    CLLocationManager *locationManager;
    FXBlurView *blurView;
    
    UIImagePickerController *imagePicker;
    IBOutlet UICollectionView *imageCollection;
    IBOutlet UITextView *descriptionTextview;
    UIDatePicker *datepicker;    
    IBOutlet UILabel *todayDate;
    IBOutlet UILabel *navigationLabel;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *selectedCategory;
    
    IBOutlet MKMapView *mapview;
    NSString *currentLocation;
}
-(IBAction)postAction:(id)sender;
-(IBAction)categoryAction:(id)sender;
-(IBAction)locationAction:(id)sender;
-(IBAction)attachment:(id)sender;

-(void)saveToUserDefaultsCategory:(NSMutableArray*)myArray;
-(void)saveToUserDefaultsDate:(NSString*)myString;
-(void)saveToUserDefaultsDescription:(NSString*)myString;

@property (nonatomic, copy) NSString* chosenLocation;
@property (nonatomic, copy) NSString* chosenLatitude;
@property (nonatomic, copy) NSString* chosenLongitude;
@property (nonatomic, copy) NSString* locationIndex;
@property (nonatomic, strong) NSString *helpVariable;
@property (strong, nonatomic )IBOutlet UILabel *locationFromMapLabel;
@end
