//
//  ViewController.m
//  loginscreen
//
//  Created by Poddar on 5/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import "SWRevealViewController.h"
#import "profileViewController.h"

@interface ViewController ()

@property(strong,nonatomic) NSDictionary *postDict;
@property(strong,nonatomic) NSString *postString;

@end

@implementation ViewController

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >= 4 && range.length == 0)
    {
    	return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
}

-(void)saveToUserDefaults:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"email"];
        [standardUserDefaults synchronize];
    }
}

-(IBAction)submitAction:(id)sender;
{
    NSLog(@"asda");
    if(codeField.text.length == 4){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"id": Email ,@"code":codeField.text , @"password":Password};
        [manager POST:@"http://rohit1729.webfactional.com/sendmail.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.postDict = (NSDictionary *) responseObject;
            self.postString = self.postDict[@"status"];
            NSLog(@"JSON: %@", self.postString);
            NSLog(@"JSON: %@", responseObject);
            if([self.postString isEqualToString:@"registered"])
            {
                [self saveToUserDefaults:Email];
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                if (standardUserDefaults) {
                    [standardUserDefaults setObject:@"1" forKey:@"loginstatus"];
                    [standardUserDefaults synchronize];
                }
                [self.view makeToast:@"Thank you for registering :)"];
                profileViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileViewController"];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                navigationController.navigationBarHidden  = YES;
               
                [self presentViewController:navigationController animated:NO completion:nil];
                
            }
            else
            {
                [self.view makeToast:@"Wrong Code :/"];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:@"Network Error"];
        }];

    }
    else{
        [self.view makeToast:@"Incorrect Code Format"];
    }
    
    [textFieldTest1 resignFirstResponder];
    [textFieldTest2 resignFirstResponder];
    [textFieldTest3 resignFirstResponder];
    [codeField resignFirstResponder];
}

-(IBAction)sendCodeAction:(id)sender;
{   
    if([self NSStringIsValidEmail:textFieldTest1.text] && [textFieldTest2.text length] >5 && [textFieldTest2.text isEqualToString:textFieldTest3.text]){
        [loadingView startAnimating];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"id": Email , @"password":Password};
        [manager POST:@"http://rohit1729.webfactional.com/sendmail.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.postDict = (NSDictionary *) responseObject;
            //self.postArray = self.postDict[@"status"];
            self.postString = self.postDict[@"status"];
            NSLog(@"JSON: %@", self.postString);
            NSLog(@"JSON: %@", responseObject);
            [loadingView stopAnimating];
            if([self.postString isEqualToString:@"Code sent successfully"])
            {
                sendCodeButton.titleLabel.text = @"Proceed";
                sendCodeButton.hidden = YES;
                submitButton.hidden = NO;
                codeField.enabled = YES;
                [self.view makeToast:@"Code sent successfully \n      check your mail"];
            }
            else if ([self .postString isEqualToString:@"already registered"])
            {
                [self.view makeToast:@"User already registered \n      Go to login page"];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:@"Network Error"];
            [loadingView stopAnimating];
        }];

    }
    else{
        [self.view makeToast:@"Email and/or password is incorrect"];
    }
    [textFieldTest1 resignFirstResponder];
    [textFieldTest2 resignFirstResponder];
    [textFieldTest3 resignFirstResponder];
    [codeField resignFirstResponder];
    
}

-(IBAction)email:(id)sender;
{
    Email = textFieldTest1.text;
    
}

-(IBAction)password:(id)sender;
{
    if([textFieldTest2.text length] <6 ) {
        passwordCheck.text = @"x";
    }
    else
    {
        passwordCheck.text = @"";
        textFieldTest3.enabled = YES;
        //textFieldTest3.text = Password;
    }
    Password = textFieldTest2.text;
}
-(IBAction)confirmPassword:(id)sender;
{
    if([textFieldTest3.text isEqualToString:Password]){
        samePassword.text = @"";
    }
    else {
        samePassword.text = @"x";
    }
}

-(void)dismissKeyboard;
{
    [textFieldTest1 resignFirstResponder];
    [textFieldTest2 resignFirstResponder];
    [textFieldTest3 resignFirstResponder];
    [codeField resignFirstResponder];
}

- (void)viewDidLoad
{
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Navogation Bar background(691928)
    navigationView.backgroundColor = color_691928;
    
    //Textfields background color(691928)
    textFieldTest1.backgroundColor = color_691928;
    textFieldTest1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    textFieldTest1.layer.masksToBounds = YES;
    textFieldTest1.layer.cornerRadius = 15;
    
    textFieldTest2.backgroundColor = color_691928;
    textFieldTest2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password (Atleast 6 characters)" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    textFieldTest2.layer.masksToBounds = YES;
    textFieldTest2.layer.cornerRadius = 15;
    
    textFieldTest3.backgroundColor = color_691928;
    textFieldTest3.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm password" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    textFieldTest3.layer.masksToBounds = YES;
    textFieldTest3.layer.cornerRadius = 15;
    
    codeField.backgroundColor = color_691928;
    codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Code(4-digit)" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    codeField.layer.masksToBounds = YES;
    codeField.layer.cornerRadius = 15;
    
    //Background(f7e9b7)
    self.view.backgroundColor = color_f7e9b7;
    navigationLabel.textColor = color_f7e9b7;
    //Cache email
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    textFieldTest1.text = savedValue;
    Email = savedValue;
    
    //Activity initialization
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView setCenter:CGPointMake((screenWidth+16)/2.0, (screenHeight+160)/2.0)]; // I do this because I'm in landscape mode
    [self.view addSubview:loadingView];
    
    //[loadingView startAnimating];
    codeField.enabled = NO;
    codeField.delegate = self;
    
    //Tap tp disable keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Disable confirm password field
    textFieldTest3.enabled = NO;
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
	// Do any additional setup after loading the view, typically from a nib.
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

@end
