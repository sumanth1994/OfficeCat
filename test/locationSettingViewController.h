//
//  locationSettingViewController.h
//  test
//
//  Created by Harinandan Teja on 6/13/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface locationSettingViewController : UIViewController<UIPopoverControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,MKMapViewDelegate> {
    IBOutlet UILabel *currentLocationLabel;
    IBOutlet UILabel *preferred1Label;
    IBOutlet UILabel *preferred2Label;
    IBOutlet UIButton *change1Button;
    IBOutlet UIButton *change2Button;
    IBOutlet UIView *navigationView;
    UIActionSheet *popup1;
    UIActionSheet *popup2;
    IBOutlet MKMapView *mapview;
    MyAnnotation *customPin;
    IBOutlet UIView *customMapview;
}

-(IBAction)changeAction1:(id)sender;
-(IBAction)changeAction2:(id)sender;

@end
