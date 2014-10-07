//
//  loginViewController.h
//  test
//
//  Created by Poddar on 6/2/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;


@interface loginViewController : UIViewController
{
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *navigationLabel;
    UIActivityIndicatorView *loadingView;
}

-(IBAction)loginAction:(id)sender;
-(IBAction)forgotPassAction:(id)sender;
//-(void)saveToUserDefaults:(NSString*)myString;
@end
