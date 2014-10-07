//
//  profileViewController.h
//  test
//
//  Created by Poddar on 6/2/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
NSArray *countryArray;

NSDictionary *dictDialingCodes;
NSDictionary *codeForCountryDictionary;

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

NSString *firstName;
NSString *LastName;
NSString *phoneNumber;
NSString *country;
NSString *teleCode;
NSString *dobString;

BOOL sexHelp;

NSString *language;
NSString *countryCode;

NSString *emailid;
NSData *imageData;
BOOL help;
BOOL help1;

@interface profileViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *imagePicker;
    UIActionSheet *popup;
    IBOutlet UITextField *firstnameTextField;
    IBOutlet UITextField *lastnameTextField;
    IBOutlet UITextField *phoneTextField;
    IBOutlet UILabel *phoneCodeLabel;
    IBOutlet UIPickerView *picker1;
    IBOutlet UIView *navigationView;
    IBOutlet UIButton *sexButton;
    IBOutlet UILabel *sexLabel;
    IBOutlet UIButton *profilePicButton;
    UIDatePicker *datepicker;
    IBOutlet UILabel *dobLabel;
    IBOutlet UIImageView *propicView;
    UIImage *proPic;
}

-(IBAction)sexAction:(id)sender;
-(IBAction)propicAction:(id)sender;
-(IBAction)nextAction:(id)sender;

@end
