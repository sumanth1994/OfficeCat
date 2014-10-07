//
//  notificationViewController.m
//  test
//
//  Created by Harinandan Teja on 6/12/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "notificationViewController.h"

@interface notificationViewController ()

@end

@implementation notificationViewController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 1:
            return @"MESSAGE NOTIFICATIONS";
            break;
        case 2:
            return @"GROUP NOTIFICATIONS";
            break;
        default:
            return @"OTHER";
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 3:
            return 2;
            break;
            
        default:
            return 2;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 1:
        {
            static NSString *CellIdentifier = @"infocell";
            UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
            }
            if(indexPath.row == 1){
                UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                switchview.tag = tableView.tag;
                switchview.onTintColor = color_691928;
                switchview.on = YES;
                cell.accessoryView = switchview;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"New Message";
                    break;
                default:
                    cell.textLabel.text = @"Alerts";
                    break;
            }
            return cell;
        }
            break;
        case 2:
        {
            static NSString *CellIdentifier = @"infocell1";
            UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if(indexPath.row == 1){
                UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                switchview.tag = tableView.tag;
                switchview.onTintColor = color_691928;
                switchview.on = YES;
                cell.accessoryView = switchview;
            }
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Group Message";
                    break;
                default:
                    cell.textLabel.text = @"Alerts";
                    break;
            }
            return cell;
        }
            break;
            
        default:
        {
            static NSString *CellIdentifier = @"infocell2";
            UITableViewCell *cell = [tableView3 dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath] ;
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchview.tag = tableView.tag;
            switchview.onTintColor = color_691928;
            switchview.on = YES;
            cell.accessoryView = switchview;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"In-App Vibrate";
                    break;
                default:
                    cell.textLabel.text = @"In-App Sounds";
                    break;
            }
            return cell;
        }
            break;
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor whiteColor];
    navigationView.backgroundColor = color_691928;

    navigationLabel.textColor = color_f7e9b7;
    
    tableView1.scrollEnabled = NO;
    tableView2.scrollEnabled = NO;
    tableView3.scrollEnabled = NO;
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
