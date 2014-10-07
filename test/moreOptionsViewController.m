//
//  moreOptionsViewController.m
//  test
//
//  Created by Poddar on 6/3/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "moreOptionsViewController.h"
#import "notificationViewController.h"
#import "profileEditViewController.h"
#import "startPageViewController.h"

@interface moreOptionsViewController ()

@end

@implementation moreOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return optionsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"infocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=optionsList[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [self colorWithHexString:@"bf9fa5"];
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            profileEditViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"profileEditViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navigationController.navigationBarHidden  = YES;
            [self presentViewController:navigationController animated:NO completion:nil];
        }
            break;
        case 2:
        {
            notificationViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"notificationViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
            navigationController.navigationBarHidden  = YES;
            [self presentViewController:navigationController animated:NO completion:nil];
        }
            break;
            
        default:
            break;
    }
    
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor whiteColor];//color_f7e9b7;
    loggingout.hidden = YES;
    //Navigation bar color
    navigationView.backgroundColor = color_691928;
    navigationLabel.textColor = color_f7e9b7;
    
    logoutButton.tintColor = color_f7e9b7;
    logoutButton.backgroundColor = color_691928;
    logoutButton.layer.masksToBounds = YES;
    logoutButton.layer.cornerRadius = 10;
    mytimer = [[NSTimer alloc] init];
    //Tableview background color
    optionsTabel.backgroundColor = [UIColor clearColor];// color_f7e9b7;
    
    optionsList = @[@"Profile",@"Location Settings",@"Notification Settings",@"Privacy Statement",@"Account Settings"];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)logoutAction:(id)sender;
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:@"0" forKey:@"loginstatus"];
        [standardUserDefaults synchronize];
        loggingout.hidden = NO;
        [loggingout startAnimating];
        loggingout.color = [UIColor blackColor];
        loggingOutLabel.hidden = NO;
        mytimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(methodToUpdateProgress) userInfo:nil repeats:YES];
    }
}

-(void)methodToUpdateProgress{
    startPageViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"startPageViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden  = YES;
    [self presentViewController:navigationController animated:NO completion:nil];
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
