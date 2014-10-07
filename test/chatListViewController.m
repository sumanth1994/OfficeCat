//
//  chatListViewController.m
//  test
//
//  Created by Harinandan Teja on 6/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "chatListViewController.h"
#import "chatListCell.h"
#import "replyCell.h"

@interface chatListViewController ()

@end

@implementation chatListViewController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)addAction:(id)sender;
{
    NSLog(@"sadfgadsf");
}

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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"infocell";
    
    chatListCell *cell = (chatListCell *)[chatTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"chatListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //rounded edges of a post
    //[cell.layer setCornerRadius:20.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0];
    
    //Set image of reply cell
    cell.userPic.layer.masksToBounds = YES;
    cell.userPic.layer.cornerRadius = 25;
    cell.userPic.layer.borderWidth = 0.1;
    cell.userPic.image = [UIImage imageNamed:@"wallpaper6.jpg"];
    
    //Set Name
    cell.nameLabel.text = @"Himank Ajmera";
    
    //Set reply text
    cell.messageLabel.text = @"Users/poddar-mac/Desktop/test/test/postDetailViewController.m";
    
    //Set time label
    cell.timeLabel.text = @"3 hr";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)dismissKeyboard:(id)sender;
{
    [searchBar resignFirstResponder];
    [chatTable resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    chatTable.delegate = self;
    chatTable.dataSource = self;
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor grayColor];
    navigationView.backgroundColor = color_691928;
    
    //[self.view addGestureRecognizer:tap];

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
