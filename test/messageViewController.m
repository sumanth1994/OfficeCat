//
//  messageViewController.m
//  test
//
//  Created by Harinandan Teja on 6/16/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "messageViewController.h"
#import "fromMsgCell.h"
#import "toMsgCell.h"
#import "chatListCell.h"

@interface messageViewController ()

@end

@implementation messageViewController

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
    /*static NSString *simpleTableIdentifier = @"infocell";
    
    chatListCell *cell = (chatListCell *)[messageTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
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
    
    return cell;*/
    
    if((indexPath.row % 2) == 0){
        static NSString *simpleTableIdentifier = @"infocell";
        
        fromMsgCell *cell = (fromMsgCell *)[messageTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"fromMsgCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //rounded edges of a post
        //[cell.layer setCornerRadius:20.0f];
        [cell.layer setMasksToBounds:YES];
        [cell.layer setBorderWidth:0.0];
        
        //Set view of the msg bubble
        cell.msgView.layer.masksToBounds = YES;
        cell.msgView.backgroundColor = color_bf9fa5;
        cell.msgView.layer.cornerRadius = 10;
        
        //Set reply text
        cell.messageLabel.text = @"Hey dude how r you";
        
        //Set time label
        cell.timeLabel.text = @"3 hr";
        
        return cell;
    }
    else{
        static NSString *simpleTableIdentifier = @"infocell";
        
        toMsgCell *cell = (toMsgCell *)[messageTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"toMsgCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //rounded edges of a post
        //[cell.layer setCornerRadius:20.0f];
        [cell.layer setMasksToBounds:YES];
        [cell.layer setBorderWidth:0.0];
        
        //Set view of the msg bubble
        cell.msgView.layer.masksToBounds = YES;
        cell.msgView.backgroundColor = [UIColor grayColor];// color_f7e9b7;
        cell.msgView.layer.cornerRadius = 10;
        
        //Set reply text
        cell.messageLabel.text = @"I am fine dude how r u";
        
        //Set time label
        cell.timeLabel.text = @"3 hr";
        
        return cell;        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    messageTable.delegate = self;
    messageTable.dataSource = self;
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor grayColor];
    navigationView.backgroundColor = color_691928;
    sendMessageView.backgroundColor = color_f7e9b7;
    
    //Set friend pic and name
    friendPic.layer.masksToBounds = YES;
    friendPic.layer.cornerRadius = 15;
    friendPic.image = [UIImage imageNamed:@"profile4.jpg"];
    
    //Set user profile pic 
    profilePic.layer.masksToBounds = YES;
    profilePic.layer.cornerRadius = 18;
    profilePic.image = [UIImage imageNamed:@"profile5.jpg"];
    
    friendName.text = @"Himank Ajmera";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
