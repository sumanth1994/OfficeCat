//
//  postDetailViewController.m
//  test
//
//  Created by Poddar on 6/6/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "postDetailViewController.h"
#import "replyCell.h"
#import "postcell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import "reply_info.h"
#import "CacheController.h"

@interface postDetailViewController ()

@property(strong,nonatomic) NSDictionary *postDict_help;
@property(strong,nonatomic) NSString *postString_help;

@property(strong,nonatomic) NSMutableArray *postDict;
@end

@implementation postDetailViewController

//hexcode to color funtion
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%lu",self.imageArray.count);
    return self.imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const SwitchCellID = @"memberCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SwitchCellID forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"memberCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:30];
    recipeImageView.layer.masksToBounds = YES;
    recipeImageView.layer.cornerRadius = 5;
    NSString *imageString = self.imageArray[indexPath.item];
    
    NSLog(@"%@",imageString);
    UIImage *image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
    recipeImageView.image = [UIImage imageNamed:@"camera.png"];
    
    if(image)
    {
        NSLog(@"cached");
        recipeImageView.image = image;
    }
    else
    {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSString* imageURLString = [NSString stringWithFormat:@"http://rohit1729.webfactional.com/uploads/%@",imageString];
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
                    recipeImageView.image = [UIImage imageNamed:@"camera.png"];
                }
            });
        });
    }
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.replyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"infocell";
    
    replyCell *cell = (replyCell *)[self.replyTable dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"replyCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //rounded edges of a post
    //[cell.layer setCornerRadius:20.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0];

    //Set image of reply cell
    cell.profilePic.layer.masksToBounds = YES;
    cell.profilePic.layer.cornerRadius = 25;
    
    reply_info *reply_help = self.replyArray[indexPath.row];
    
    //Image caching
    NSString *imageString = [@"small" stringByAppendingString:[reply_help.emailID stringByAppendingString:@".jpg"]];
    UIImage *image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
    cell.profilePic.image = [UIImage imageNamed:@"nopic.jpg"];
    
    if(image)
    {
        //NSLog(@"cached");
        cell.profilePic.image = image;
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
                    //NSLog(@"Image dowloaded");
                    cell.profilePic.image = image;
                    [[CacheController sharedInstance] setCache:image forKey:imageString ];
                }
                else{
                    cell.profilePic.image = [UIImage imageNamed:@"nopic.jpg"];
                }
            });
        });
    }
    
    //Set Name
    cell.nameLabel.text = reply_help.name;
    
    //Set reply text
    cell.replyLabel.text = reply_help.replyText;
    
    //Set time label
    cell.timeLabel.text = @"3 days ago";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard;
{
    [self.replyTextField resignFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Move the screen up when key board shows up

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -168; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.userReplyView.frame = CGRectOffset(self.userReplyView.frame, 0, movement);
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)replyEditingAction:(id)sender;
{
    UITextField *textHelp = (UITextField *)sender;
    replyString = textHelp.text;
}

-(IBAction)sendReplyAction:(id)sender;
{
    [self.replyTextField resignFirstResponder];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":self.postID,@"sender":@"hari.katam@gmail.com",@"comment":replyString,@"name":@"Harinandan Teja"};
    
    [manager POST:@"http://rohit1729.webfactional.com/projectm/comment.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.postDict_help = (NSDictionary *)responseObject;
        self.postString_help = self.postDict_help[@"status"];
        NSLog(@"JSON: %@", responseObject);
        if([self.postString_help isEqualToString:@"comment added"]){
            [self.view makeToast:@"Reply Added"];
            self.replyTextField.text = @"";
            AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
            manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSDictionary *parameters = @{@"id":self.postID};
            [manager1 POST:@"http://rohit1729.webfactional.com/projectm/getcomments.php" parameters:parameters
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSLog(@"JSON: %@", responseObject);
                      self.replyArray = [[NSMutableArray alloc] init];
                      self.postDict = (NSMutableArray *)responseObject;
                      for(NSDictionary *help in self.postDict){
                          reply_info *reply_help = [[reply_info alloc] init];
                          reply_help.name = help[@"sendername"];
                          reply_help.replyText = help[@"comment"];
                          reply_help.emailID = help[@"sender"];
                          [self.replyArray addObject:reply_help];
                      }
                      [self.replyTable reloadData];
                      NSLog(@"Count %lu",self.replyArray.count);
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"Error: %@", error);
                      [self.view makeToast:@"Network Error"];
                  }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.view makeToast:@"Network Error"];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"Coutn is : %lu",self.imageArray.count);
    //NSLog(@"%@",self.imageArray[1]);
    imageCollection.delegate = self;
    imageCollection.dataSource = self;
    
    //Tap to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.replyTextField.layer.masksToBounds = YES;
    self.replyTextField.layer.cornerRadius = 15;
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Background colors
    self.postProfileView.backgroundColor = color_f7e9b7;
    self.userReplyView.backgroundColor = color_f7e9b7;
    self.statusView.backgroundColor = color_691928;

    //Setting up all the values from postviewController
    
    self.categoryAndAddressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.categoryAndAddressLabel.numberOfLines = 0;
    
    self.descriptionLabel.text = self.descriptionText;
    self.postProfileNameLabel.text = self.postProfileNameText;
    self.categoryAndAddressLabel.text = self.categoryText;
    self.timeLabel.text = self.timeText;
    self.distanceLabel.text = self.distanceText;
    
    self.postProfilePic.layer.masksToBounds = YES;
    self.postProfilePic.layer.cornerRadius = 35;
    self.postProfilePic.image = self.postProfileImage;
    
    self.userProfilePic.layer.masksToBounds = YES;
    self.userProfilePic.layer.cornerRadius = 17;
    self.userProfilePic.image = self.userProfileImage;
    
    self.latitudeText = [self.latitudeText substringToIndex:[self.latitudeText length] - 4];
    self.longitudeText = [self.longitudeText substringToIndex:[self.longitudeText length] - 4];
    
    //Converting lat,long strings to float
    CGFloat latFloat = (CGFloat)[self.latitudeText floatValue];
    CGFloat longFloat = (CGFloat)[self.longitudeText floatValue];
    
    //Setting up mapview to show location
    MKCoordinateRegion region = self.mapview.region;
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:latFloat longitude:longFloat];
    region.center = centerLocation.coordinate;
    region.span.longitudeDelta /= 1500; // Bigger the value, closer the map view
    region.span.latitudeDelta /= 1500;
    [self.mapview setRegion:region animated:YES];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    
    [annotation setCoordinate: centerLocation.coordinate];
    [annotation setTitle: @"The event is here"];
    [annotation setSubtitle: self.timeText];
    [self.mapview addAnnotation: annotation];
    
    //Initializing reply array
    self.replyArray = [[NSMutableArray alloc] init];
    if(![self.repliesText isEqualToString:@"0"]){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"id":self.postID};
        [manager POST:@"http://rohit1729.webfactional.com/projectm/getcomments.php" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  NSLog(@"JSON: %@", responseObject);
                  self.postDict = (NSMutableArray *)responseObject;
                  for(NSDictionary *help in self.postDict){
                      reply_info *reply_help = [[reply_info alloc] init];
                      reply_help.name = help[@"sendername"];
                      reply_help.replyText = help[@"comment"];
                      reply_help.emailID = help[@"sender"];
                      [self.replyArray addObject:reply_help];
                      //NSLog(reply_help.name);
                      //NSLog(reply_help.replyText);
                  }
                  [self.replyTable reloadData];
                  NSLog(@"%lu",self.replyArray.count);
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Error: %@", error);
                  [self.view makeToast:@"Network Error"];
              }];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
