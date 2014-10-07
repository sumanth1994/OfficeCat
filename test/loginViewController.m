//
//  loginViewController.m
//  test
//
//  Created by Poddar on 6/2/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "loginViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import "SWRevealViewController.h"
#import "postVIewController.h"

@interface loginViewController ()

@property(strong,nonatomic) NSDictionary *postDict;
@property(strong,nonatomic) NSString *postString;

@end

@implementation loginViewController

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction)forgotPassAction:(id)sender;
{
    
}


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



-(IBAction)loginAction:(id)sender;
{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if([self NSStringIsValidEmail:emailTextField.text] && [passwordTextField.text length] >5)
    {
        NSLog(@"loginactionstarted");
        [loadingView startAnimating];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"id": emailTextField.text , @"password":passwordTextField.text};
        [manager POST:@"http://rohit1729.webfactional.com/projectm/login.php" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //NSLog(@"success");
             self.postDict = (NSDictionary *) responseObject;
             self.postString = self.postDict[@"status"];
             //NSLog(@"JSON: %@", self.postString);
             //NSLog(@"JSON: %@", responseObject);
             if([self.postString isEqualToString:@"loggedin"])
             {
                 [loadingView stopAnimating];
                 [self saveToUserDefaults:emailTextField.text];
                 postVIewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"postVIewController"];
                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                 navigationController.navigationBarHidden  = YES;
                 NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                 
                 if (standardUserDefaults) {
                     [standardUserDefaults setObject:@"1" forKey:@"loginstatus"];
                     [standardUserDefaults synchronize];
                 }
                 [self presentViewController:navigationController animated:NO completion:nil];
                 
             }
             else if ([self.postString isEqualToString:@"loggedout"]){
                 [loadingView stopAnimating];
                 [self.view makeToast:@"Incorrect password/email"];
             }
             
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             [loadingView stopAnimating];
             NSLog(@"Error: %@", error);
             [passwordTextField resignFirstResponder];
             [self.view makeToast:@"Network Error"];
         }];
    }
    else{
        [passwordTextField resignFirstResponder];
        [self.view makeToast:@"Wrong email and/or password"];
    }
}



-(void)dismissKeyboard;
{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(void)saveToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"email"];
        [standardUserDefaults synchronize];
    }
}

-(void)viewDidLoad{
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Navigation Bar background color
    navigationView.backgroundColor = color_691928;
    navigationLabel.textColor = color_f7e9b7;
    //Textfields backgournd color;
    emailTextField.backgroundColor = color_691928;
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    emailTextField.layer.masksToBounds = YES;
    emailTextField.layer.cornerRadius = 15;
    
    passwordTextField.backgroundColor = color_691928;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    passwordTextField.layer.masksToBounds = YES;
    passwordTextField.layer.cornerRadius = 15;
    
    //return cached email id
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    emailTextField.text = savedValue;
    
    //Activity initialization
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView setCenter:CGPointMake((screenWidth+16)/2.0, (screenHeight+160)/2.0)]; // I do this because I'm in landscape mode lol
    [self.view addSubview:loadingView];
    
    
    //View background color
    self.view.backgroundColor = color_f7e9b7;
    
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
