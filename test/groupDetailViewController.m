//
//  groupDetailViewController.m
//  chatPart
//
//  Created by Harinandan Teja on 6/28/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "groupDetailViewController.h"
#import "groupPostCell.h"
#import "CacheController.h"

@interface groupDetailViewController ()

@end

@implementation groupDetailViewController

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
    
    postTable.delegate = self;
    postTable.dataSource = self;
    
    membersCollection.delegate = self;
    membersCollection.dataSource = self;
    membersCollection.backgroundColor = [UIColor whiteColor];//color_691928;
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
    //background color
    self.view.backgroundColor = [UIColor grayColor];
    view1.backgroundColor = color_f7e9b7;
    navigationView.backgroundColor = color_691928;
    navigationLabel.textColor = color_f7e9b7;
    
    grpPic.layer.masksToBounds = YES;
    grpPic.layer.cornerRadius = 28;
    grpPic.image = self.grpImg;
    
    grpnameLabel.textColor = color_f7e9b7;
    grpnameLabel.text = self.grpnameString;// @"Eagle Group";
    grpnameLabel.adjustsFontSizeToFitWidth = YES;
    
    memLabel.text = self.memString;
    desLabel.text = self.desString;
    desLabel.adjustsFontSizeToFitWidth = YES;
    
    membersPostbutton.layer.masksToBounds = YES;
    membersPostbutton.layer.cornerRadius = 10;
    membersPostbutton.backgroundColor = color_691928;
    [membersPostbutton setTitleColor:color_f7e9b7 forState:UIControlStateNormal];
    membersPostbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    NSLog(@"Members : %lu %@",self.membersArray.count,self.membersArray[0]);
    
    commentIndex = @"1";
    
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"infocell";
    groupPostCell *cell = (groupPostCell *)[postTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"groupPostCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //rounded edges of a post
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0];
    cell.layer.cornerRadius = 10;
    
    cell.nameLabel.text = @"Harinandan Teja";
    cell.timeLabel.text = @"now";
    [cell.descriptionLabel setNumberOfLines:0];
    cell.descriptionLabel.text = @"2014-06-23 17:57:37.467 agadfgadsfgsdfgsdfg szg 014-06-23 17:57:37.467 agadfgadsfgsdfgsdfg szg 014-06-23 17:57:37.467 agadfgadsfgsdfgsdfg szg";
    
    cell.userPic.layer.masksToBounds = YES;
    cell.userPic.image = [UIImage imageNamed:@"profile4.jpg"];
    cell.userPic.layer.cornerRadius = 15;
    
    [cell.commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tintColor = color_691928;
    cell.commentButton.tag = indexPath.section;
    
    cell.view1.backgroundColor = color_f7e9b7;
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([commentIndex isEqualToString:[NSString stringWithFormat:@"%lu",indexPath.row]]) {
        return 500;
    }
    return 130;
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)commentAction:(id)sender;
{
    UIButton* aButton = (UIButton*)sender;
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:aButton.tag];
    //groupPostCell *cell = (groupPostCell *) [postTable cellForRowAtIndexPath:indexPath];
    
    if([commentIndex isEqualToString:[NSString stringWithFormat:@"%lu",aButton.tag]]){
        commentIndex = @"-1";
    }
    else{
        commentIndex = [NSString stringWithFormat:@"%lu",aButton.tag];
    }
    [postTable reloadData];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Selectedf image scrolling collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//Count of number of images selected
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.membersArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const SwitchCellID = @"memberCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SwitchCellID forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"memberCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = color_f7e9b7;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 34;
    
    /*UILabel *nameLabel = (UILabel *)[cell viewWithTag:10];
    nameLabel.text = @"Harinandan";
    nameLabel.textColor = color_691928;*/
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.layer.masksToBounds = YES;
    recipeImageView.layer.cornerRadius = 30;
    //recipeImageView.image = [UIImage imageNamed:@"profile4.jpg"];
    
    NSString *imageString = [@"small" stringByAppendingString:[self.membersArray[indexPath.item] stringByAppendingString:@".jpg"]];
    
    NSLog(@"%@",imageString);
    UIImage *image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
    recipeImageView.image = [UIImage imageNamed:@"nopic.jpg"];
    
    if(image)
    {
        NSLog(@"cached");
        recipeImageView.image = image;
    }
    else
    {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSString* imageURLString = [NSString stringWithFormat:@"http://rohit1729.webfactional.com/profilepic/%@",imageString];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                {
                    NSLog(@"Image dowloaded");
                    recipeImageView.image = image;
                    [[CacheController sharedInstance] setCache:image forKey:imageString ];
                }
                else{
                    recipeImageView.image = [UIImage imageNamed:@"nopic.jpg"];
                }
            });
        });
    }
    
    NSLog(@"%@",self.membersArray[indexPath.item]);
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)memberPostAction:(id)sender;
{
    if(membersCollection.isHidden){
        self.view.backgroundColor = [UIColor whiteColor];
        membersCollection.hidden = NO;
        [membersPostbutton setTitle:@"Posts" forState:UIControlStateNormal];
        postTable.hidden = YES;
    }
    else{
        self.view.backgroundColor = [UIColor grayColor];
        membersCollection.hidden = YES;
        [membersPostbutton setTitle:@"Members" forState:UIControlStateNormal];
        postTable.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
