//
//  ViewController.h
//  loginscreen
//
//  Created by Poddar on 5/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;


NSString *Password;
NSString *Email;
NSString *Country;
@interface ViewController : UIViewController <UITextFieldDelegate>
{    
    IBOutlet UIButton *sendCodeButton;
    IBOutlet UIButton *submitButton;
    IBOutlet UIView *navigationView;
    UIActivityIndicatorView *loadingView;
    IBOutlet UILabel *navigationLabel;
    IBOutlet UILabel *emailCheck;
    IBOutlet UILabel *passwordCheck;
    IBOutlet UILabel *samePassword;
    IBOutlet UITextField *codeField;
    IBOutlet UITextField *textFieldTest1;
    IBOutlet UITextField *textFieldTest2;
    IBOutlet UITextField *textFieldTest3;
    IBOutlet UIPickerView *country;
}

-(IBAction)submitAction:(id)sender;
-(IBAction)sendCodeAction:(id)sender;
-(void)saveToUserDefaults:(NSString*)myString;
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
-(IBAction)email:(id)sender;
-(IBAction)password:(id)sender;
-(IBAction)confirmPassword:(id)sender;
@end
