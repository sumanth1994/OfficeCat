//
//  profileEditViewController.m
//  test
//
//  Created by Harinandan Teja on 6/12/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "profileEditViewController.h"
#import "UIImage+StackBlur.h"

@interface profileEditViewController ()

@end

@implementation profileEditViewController

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    //self.view.backgroundColor = color_f7e9b7;// [UIColor whiteColor];
    profileView.backgroundColor = [UIColor clearColor];
    navigationView.backgroundColor = color_691928;
    
    //Image attributes
    coverPic.image = [[UIImage imageNamed:@"profile4.jpg"] stackBlur:30];
    proPic.image = [UIImage imageNamed:@"profile4.jpg"];
    proPic.layer.masksToBounds = YES;
    proPic.layer.cornerRadius = 30;   
    
    nameLabel.text = @"Harinandan Teja";
    nameLabel.textColor = color_f7e9b7;
    
    //Label attributes
    emailLabel.layer.masksToBounds = YES;
    emailLabel.layer.cornerRadius = 10.5;
    emailLabel.backgroundColor = color_691928;
    emailLabel.textColor = color_f7e9b7;
    firstNameLabel.layer.masksToBounds = YES;
    firstNameLabel.layer.cornerRadius = 10.5;
    firstNameLabel.backgroundColor = color_691928;
    firstNameLabel.textColor = color_f7e9b7;
    lastNameLabel.layer.masksToBounds = YES;
    lastNameLabel.layer.cornerRadius = 10.5;
    lastNameLabel.backgroundColor = color_691928;
    lastNameLabel.textColor = color_f7e9b7;
    dobLabel.layer.masksToBounds = YES;
    dobLabel.layer.cornerRadius = 10.5;
    dobLabel.backgroundColor = color_691928;
    dobLabel.textColor = color_f7e9b7;
    sexLabel.layer.masksToBounds = YES;
    sexLabel.layer.cornerRadius = 10.5;
    sexLabel.backgroundColor = color_691928;
    sexLabel.textColor = color_f7e9b7;
    phoneNumLabel.layer.masksToBounds = YES;
    phoneNumLabel.layer.cornerRadius = 10.5;
    phoneNumLabel.backgroundColor = color_691928;
    phoneNumLabel.textColor = color_f7e9b7;
    
    editdobLabel.layer.masksToBounds = YES;
    editdobLabel.layer.cornerRadius = 10.5;
    editdobLabel.backgroundColor = color_691928;
    editdobLabel.textColor = color_f7e9b7;
    editEmailLabel.layer.masksToBounds = YES;
    editEmailLabel.layer.cornerRadius = 10.5;
    editEmailLabel.backgroundColor = color_691928;
    editEmailLabel.textColor = color_f7e9b7;
    editsexLabel.layer.masksToBounds = YES;
    editsexLabel.layer.cornerRadius = 10.5;
    editsexLabel.backgroundColor = color_691928;
    editsexLabel.textColor = color_f7e9b7;
    
    //Textfields attributes
    firstNameField.backgroundColor = color_691928;
    firstNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    firstNameField.layer.masksToBounds = YES;
    firstNameField.layer.cornerRadius = 10.5;
    firstNameField.text = firstNameLabel.text;
    firstNameField.textColor = color_f7e9b7;
    
    lastNameField.backgroundColor = color_691928;
    lastNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    lastNameField.layer.masksToBounds = YES;
    lastNameField.layer.cornerRadius = 10.5;
    lastNameField.text = lastNameLabel.text;
    lastNameField.textColor = color_f7e9b7;
    
    phoneNumField.backgroundColor = color_691928;
    phoneNumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    phoneNumField.layer.masksToBounds = YES;
    phoneNumField.layer.cornerRadius = 10.5;
    phoneNumField.text = phoneNumLabel.text;
    phoneNumField.textColor = color_f7e9b7;
    
    changeDobButton.tintColor = color_691928;
    changeSexButton.tintColor = color_691928;
    
    editView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)dismissKeyboard:(id)sender;
{
    [self.view endEditing:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)editAction:(id)sender;
{
    if(editView.alpha == 1){
        [UIView animateWithDuration: 1.0
                         animations:^{
                             editView.alpha = 0.0;
                             profileView.alpha = 1.0;
                         }];
        [self.view endEditing:YES];
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        //profileView.hidden = NO;
        //editView.hidden = YES;
    }
    else{
        [UIView animateWithDuration: 1.0
                         animations:^{
                             profileView.alpha = 0.0;
                             editView.alpha = 1.0;
                         }];
        //profileView.hidden = YES;
        //editView.hidden = NO;
        [firstNameField becomeFirstResponder];
        [editButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
