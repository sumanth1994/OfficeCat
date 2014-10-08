//
//  groupsViewController.m
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
// i made this change

#import "groupsViewController.h"
#import "groupViewCell.h"
#import "groupDetailViewController.h"

@interface groupsViewController ()

@end

@implementation groupsViewController

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
    
    //Group table attributes
    grpTable.delegate = self;
    grpTable.dataSource = self;
    searchBar.delegate = self;
    searchBar.tintColor = color_f7e9b7;
    //searchBar.backgroundColor = [UIColor clearColor];
    //searchBar.barTintColor = color_691928;
    //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:color_691928];
    //[searchBar setShowsCancelButton:YES];
    //searchBar.tintColor = color_691928;
    
    //Init arrays
    searchArray = [[NSMutableArray alloc] init];
    groupsArray = [[NSMutableArray alloc] init];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
    //background color
    self.view.backgroundColor = [UIColor grayColor];
    navigationLabel.textColor = color_f7e9b7;
    navigationView.backgroundColor = color_691928;
    
    membersID = [[NSMutableArray alloc] init];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    
    //Hardcoded data
    NSMutableDictionary *groupDict = [[NSMutableDictionary alloc] init];
    [groupDict setValue:@"Eagles Group" forKey:@"name"];
    [groupDict setValue:@"345" forKey:@"members"];
    [groupDict setValue:@"This is group 1" forKey:@"des"];
    [groupDict setValue:@"25" forKey:@"posts"];
    
    [groupsArray addObject:groupDict];
    
    groupDict = [[NSMutableDictionary alloc] init];
    [groupDict setValue:@"Cricket Club" forKey:@"name"];
    [groupDict setValue:@"598" forKey:@"members"];
    [groupDict setValue:@"This is group 2" forKey:@"des"];
    [groupDict setValue:@"5" forKey:@"posts"];
    
    [groupsArray addObject:groupDict];
    
    groupDict = [[NSMutableDictionary alloc] init];
    [groupDict setValue:@"FootBall club india" forKey:@"name"];
    [groupDict setValue:@"14455" forKey:@"members"];
    [groupDict setValue:@"This is group 3 2014-07-05 12:22:02.499 test[402:60b] cached 2014-07-05 12:22:02.499 test[402:60b] hari.katam@gmail.com 2014-07-05 12:22:02.5" forKey:@"des"];
    [groupDict setValue:@"50" forKey:@"posts"];
    
    NSLog(@"%lu",[[groupDict objectForKey:@"des"] length]);
    [groupsArray addObject:groupDict];
    
    groupDict = [[NSMutableDictionary alloc] init];
    [groupDict setValue:@"Hockey Club Australia" forKey:@"name"];
    [groupDict setValue:@"264236" forKey:@"members"];
    [groupDict setValue:@"This is group 4" forKey:@"des"];
    [groupDict setValue:@"10000" forKey:@"posts"];
    
    [groupsArray addObject:groupDict];
    
    groupDict = [[NSMutableDictionary alloc] init];
    [groupDict setValue:@"Golf club nahar amrith shakthi" forKey:@"name"];
    [groupDict setValue:@"210" forKey:@"members"];
    [groupDict setValue:@"This is group 5" forKey:@"des"];
    [groupDict setValue:@"50" forKey:@"posts"];
    
    [groupsArray addObject:groupDict];
    
    NSLog(@"%lu",groupsArray.count);
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *simpleTableIdentifier = @"infocell";    
    groupViewCell *cell = (groupViewCell *)[grpTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"groupViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *help = [[NSDictionary alloc] init];
    
    if(searchArray.count > 0){
        help = searchArray[indexPath.section];
    }
    else{
        help = groupsArray[indexPath.section];
    }
    
    //rounded edges of a post
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0];
    cell.layer.cornerRadius = 10;
    
    //Set attributes of reply cell
    cell.grpPic.layer.masksToBounds = YES;
    cell.grpPic.layer.cornerRadius = 22;
    cell.grpPic.layer.borderWidth = 0.1;
    cell.grpPic.image = [UIImage imageNamed:@"wallpaper4.jpeg"];
    cell.gotoButton.tintColor = color_691928;
    cell.postsLabel.layer.masksToBounds = YES;
    cell.postsLabel.layer.cornerRadius = 10;
    cell.postsLabel.textColor = color_f7e9b7;
    cell.postsLabel.backgroundColor = color_691928;
    cell.postsLabel.adjustsFontSizeToFitWidth = YES;
    cell.nameLabel.adjustsFontSizeToFitWidth = YES;
    
    //Set Label
    cell.nameLabel.text = [help objectForKey:@"name"];
    cell.descriptionLabel.text = [help objectForKey:@"des"];
    cell.membersLabel.text = [[help objectForKey:@"members"] stringByAppendingString:@" Members"];
    cell.postsLabel.text = [help objectForKey:@"posts"];
    
    cell.view1.backgroundColor = color_f7e9b7;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(searchArray.count > 0){
        return searchArray.count;
    }
    else return groupsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%lu",indexPath.section);
    groupViewCell *cell = (groupViewCell *)[grpTable cellForRowAtIndexPath:indexPath];
    
    groupDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupDetailViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden  = YES;
    viewController.grpnameString = cell.nameLabel.text;
    viewController.desString = cell.descriptionLabel.text;
    viewController.memString = cell.membersLabel.text;
    viewController.grpImg = cell.grpPic.image;
    viewController.membersArray = membersID;
    [self presentViewController:navigationController animated:NO completion:nil];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //searchArray = [[NSMutableArray alloc] init];
    //[grpTable reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
    searchArray = [[NSMutableArray alloc] init];
    for(NSDictionary *help in groupsArray){
        if ([[help objectForKey:@"name"] rangeOfString:searchText].location == NSNotFound && [[[help objectForKey:@"name"] lowercaseString] rangeOfString:searchText].location == NSNotFound && [[[help objectForKey:@"name"] uppercaseString] rangeOfString:searchText].location == NSNotFound) {
        }
        else {
            [searchArray addObject:help];
        }
    }
    [grpTable reloadData];
    NSLog(@"%lu",searchArray.count);
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
