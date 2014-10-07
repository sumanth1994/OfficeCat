//
//  loadingScreenViewController.m
//  projectM
//
//  Created by Harinandan Teja on 7/30/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "loadingScreenViewController.h"
#import "postVIewController.h"
#import "startPageViewController.h"

@interface loadingScreenViewController ()

@end

@implementation loadingScreenViewController


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    loading.color = [UIColor whiteColor];
    [loading startAnimating];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = color_691928;    
    myTimer = [[NSTimer alloc] init];    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(afterLoading) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

-(void)afterLoading{
    NSString *loginstatus = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginstatus"];
    //NSLog(@"login status is %@",loginstatus);
    if([loginstatus isEqualToString:@"1"]){
        //NSLog(@"Already loggedin");
        postVIewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"postVIewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        [self presentViewController:navigationController animated:NO completion:nil];
    }
    else{
        //NSLog(@"Not logged in");
        startPageViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startPageViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        [self presentViewController:navigationController animated:NO completion:nil];
    }
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
