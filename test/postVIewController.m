//
//  postVIewController.m
//  test
//
//  Created by Poddar on 5/21/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
// hi ra

#import "postVIewController.h"
#import "postcell.h"
#import "post_info.h"
#import "RNGridMenu.h"
#import "SWRevealViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import <FXBlurView/FXBlurView.h>
#import "CacheController.h"
#import "postDetailViewController.h"
#import "categoryCell.h"

@interface postVIewController ()

@property(strong,nonatomic) NSMutableArray *postDict;
@property(strong,nonatomic) NSString *postString;

@property(strong,nonatomic) NSDictionary *postDict_help;
@property(strong,nonatomic) NSString *postString_help;

@end

@implementation postVIewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)radiusAction:(id)sender;
{
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", locationRadius.value];
    NSString *raduisString = [formattedNumber stringByAppendingString:@"Miles"];
    //NSLog(raduisString);
    radiusLabel.text = raduisString;
    radiusLabel.frame = CGRectMake(72+locationRadius.value*116, 30, 60, 15);
}

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

#pragma mark - Target/Action

//Location selection interface
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //[self showGridWithHeaderFromPoint:[longPress locationInView:self.view]];
    }
}

#pragma mark - RNGridMenuDelegate

-(IBAction)location:(id)sender;
{
    sideBool = true;
    [self showList];
}

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    
    if(itemIndex != 0){
        locationLabel.text = item.title;
    }
    else{
        locationLabel.text = currentLocation;
    }
}

#pragma mark - Private

- (void)showImagesOnly {
    NSInteger numberOfOptions = 5;
    NSArray *images = @[
                        [UIImage imageNamed:@"arrow"],
                        [UIImage imageNamed:@"attachment"],
                        [UIImage imageNamed:@"block"],
                        [UIImage imageNamed:@"bluetooth"],
                        [UIImage imageNamed:@"cube"],
                        [UIImage imageNamed:@"download"],
                        [UIImage imageNamed:@"enter"],
                        [UIImage imageNamed:@"file"],
                        [UIImage imageNamed:@"github"]
                        ];
RNGridMenu *av = [[RNGridMenu alloc] initWithImages:[images subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showList {
    NSInteger numberOfOptions = 4;
    NSArray *options = @[
                         @"Current Location",
                         preferredLocation1,
                         preferredLocation2,
                         @"Custom Location",
                         /*@"Deliver",
                         @"Download",
                         @"Enter",
                         @"Source Code",
                         @"Github"*/
                         ];
    RNGridMenu *av = [[RNGridMenu alloc] initWithTitles:[options subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.itemTextAlignment = NSTextAlignmentLeft;
    av.itemFont = [UIFont boldSystemFontOfSize:18];
    av.itemSize = CGSizeMake(150, 55);
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGrid {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

- (void)showGridWithHeaderFromPoint:(CGPoint)point {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [RNGridMenuItem emptyItem],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [RNGridMenuItem emptyItem]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.bounces = NO;
    av.animationDuration = 0.2;
    //av.blurExclusionPath = [UIBezierPath bezierPathWithOvalInRect:self.imageView.frame];
    av.backgroundPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.f, 0.f, av.itemSize.width*3, av.itemSize.height*3)];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    header.text = @"Example Header";
    header.font = [UIFont boldSystemFontOfSize:18];
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.textAlignment = NSTextAlignmentCenter;
    // av.headerView = header;
    
    [av showInViewController:self center:point];
}

- (void)showGridWithPath {
    NSInteger numberOfOptions = 9;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] title:@"Next"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"attachment"] title:@"Attach"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"block"] title:@"Cancel"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bluetooth"] title:@"Bluetooth"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"cube"] title:@"Deliver"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"download"] title:@"Download"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"enter"] title:@"Enter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"file"] title:@"Source Code"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"github"] title:@"Github"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard;
{
    [self.view endEditing:YES];
    NSLog(@"Keyboard");
}

-(IBAction)searchAction:(id)sender;
{
    NSLog(@"asdfas");
    if(searchView.alpha == 0){
        [UIView animateWithDuration: 0.3
                         animations:^{
                             searchView.alpha = 1.0;
                             view1.alpha = 0.0;
                         }];
        [self.view endEditing:YES];
    }
}

-(IBAction)searchBackAction:(id)sender;
{
    [UIView animateWithDuration: 0.3
                     animations:^{
                         searchView.alpha = 0.0;
                         view1.alpha = 1.0;
                     }];
    [self.view endEditing:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Refresh control
-(void)refreshTable;
{
    //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMM d, h:mm a"];
    NSString *dateString = [dateFormat stringFromDate:date];
    //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Release"];
    [self.view makeToast:[@"Last Updated on " stringByAppendingString:dateString]];
    [refreshControl endRefreshing];
    [postTable reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
    
    lati = userLocation.coordinate.latitude;
    longi = userLocation.coordinate.longitude;
    
    //NSLog(@"%f - %f",lati,longi);
    
    //mypin = [[MyAnnotation alloc] initWithCoordinate:userLocation.coordinate];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        //NSLog(@"%@",locationLabel.text);
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        [postTable reloadData];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)revealToggle:(id)sender;
{
    if (sideBool) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             view1.frame = CGRectMake(view1.frame.origin.x+64, view1.frame.origin.y, 320, 523);
                             view2.frame = CGRectMake(view2.frame.origin.x+64, view2.frame.origin.y, 64, 523);
                         }];
        sideBool = false;
    }
    else{
        [UIView animateWithDuration:0.3
                         animations:^{
                             view1.frame = CGRectMake(view1.frame.origin.x-64, view1.frame.origin.y, 320, 523);
                             view2.frame = CGRectMake(view2.frame.origin.x-64, view2.frame.origin.y, 64, 523);
                         }];
        sideBool = true;
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)newPostProcess:(NSNotification *)note {
    NSLog(@"Received Notification - Someone seems to have logged in %@",note.userInfo);
    newPostsCount++;
    [self.view makeToast:[NSString stringWithFormat:@"%d new posts",newPostsCount]];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    newPostsCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newPostProcess:)
                                                 name:@"newPostRecieved" object:nil];
    
    sideBool = true;
    categoryArray = [NSMutableArray arrayWithObjects:@"Popular",@"My Posts",@"Music",@"Fun",@"Movies",@"Office",@"Sports",@"Buy/Sell",@"Travelling",@"HomeWork",@"Borrow",@"Mothers",@"Food",@"Teen",nil];
    categoryTable.delegate = self;
    categoryTable.dataSource = self;
    locationLabel.adjustsFontSizeToFitWidth = YES;
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor grayColor];//color_f7e9b7;
    searchView.backgroundColor = color_691928;
    view1.backgroundColor = [UIColor grayColor];
    navigationView.backgroundColor = color_691928;
    
    //Radius label background
    radiusLabel.backgroundColor = color_f7e9b7;
    radiusLabel.textColor = color_691928;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    searchView.alpha = 0;
    searchBar.tintColor = color_f7e9b7;
    
    //Tap to dismiss keyboard
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];*/
    
    //Set current location
    preferredLocation1 = @"Not Available";
    preferredLocation2 = @"Not Available";
    customLocation = @"Loading";
    locationLabel.text = @"Loading......";
    
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    
    lati = mapview.userLocation.coordinate.latitude;
    longi = mapview.userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        //NSLog(@"%@",locationLabel.text);
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        [postTable reloadData];
    }];
    
    refreshControl = [[UIRefreshControl alloc]init];
    //[postTable addSubview:refreshControl];
    //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //Blur view
    blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 650, 650)];
    [blurView setDynamic:YES];
    blurView.tintColor = color_691928;
    [self.view addSubview:blurView];
    blurView.hidden = YES;
    
    [navigationButton addTarget:self action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set the initial radius label
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", locationRadius.value];
    NSString *raduisString = [formattedNumber stringByAppendingString:@"Miles"];
    radiusLabel.layer.masksToBounds = YES;
    radiusLabel.layer.cornerRadius = 5;
    radiusLabel.text = raduisString;
    
    //Initialize post array
    post = [[NSMutableArray alloc] init];
    locationArray = @[@"Office",@"Current Location",@"Home"];
    
    //Loading all the posts
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":@"hari.katam@gmail.com"};
    
    [manager POST:@"http://rohit1729.webfactional.com/projectm/home.php" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.postDict = (NSMutableArray *) responseObject;
         for(NSDictionary *help in self.postDict){
             post_info *post_help = [[post_info alloc] init];
             post_help.name = help[@"name"];
             post_help.description = help[@"message"];
             post_help.lat = [[help objectForKey:@"latitude"] floatValue];
             post_help.lon = [[help objectForKey:@"longitude"] floatValue];
             post_help.time = help[@"timeofpost"];
             post_help.emailid = help[@"emailid"];
             post_help.where = help[@"address"];
             post_help.when = help[@"date"];
             post_help.numberOfReplies = [[help objectForKey:@"numofcomments"] intValue];
             post_help.postID = [[help objectForKey:@"postid"] intValue];
             post_help.category =  [help[@"category"] componentsJoinedByString:@","];
             post_help.imageArray = help[@"image"];
             //NSLog(@"%@",post_help.imageArray);
             if (post_help.imageArray==nil){
                 NSLog(@"No Images");
                 post_help.imageArray = [[NSMutableArray alloc] init];
             }
             
             //NSLog(@"%lu",post_help.imageArray.count);
             [post addObject:post_help];
             
             /*NSLog(@"latitude %f",post_help.lat);
             NSLog(@"longitude %f",post_help.lon);
             NSLog(@"Number of replies %lu",post_help.numberOfReplies);
             NSLog(@"postID %lu",post_help.postID);*/
             //NSLog(@"%lu",post.count);
         }
         [postTable reloadData];
         //NSLog(@"JSON: %@", responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [self.view makeToast:@"Network Error"];
     }];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [postTable addSubview:refreshControl];
    
    dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    dateFormatter_help = [[NSDateFormatter alloc] init] ;
    [dateFormatter_help setDateFormat:@"dd-MMM yy"];
    
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)handleRefresh{
    NSLog(@"Refreshing");
    [self.view makeToast:@"Loading posts"];
    //Loading all the posts
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":@"hari.katam@gmail.com"};
    
    [manager POST:@"http://rohit1729.webfactional.com/projectm/home.php" parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.postDict = (NSMutableArray *) responseObject;
         for(NSDictionary *help in self.postDict){
             post_info *post_help = [[post_info alloc] init];
             post_help.name = help[@"name"];
             post_help.description = help[@"message"];
             post_help.lat = [[help objectForKey:@"latitude"] floatValue];
             post_help.lon = [[help objectForKey:@"longitude"] floatValue];
             post_help.time = help[@"timeofpost"];
             post_help.emailid = help[@"emailid"];
             post_help.where = help[@"address"];
             post_help.when = help[@"date"];
             post_help.numberOfReplies = [[help objectForKey:@"numofcomments"] intValue];
             post_help.postID = [[help objectForKey:@"postid"] intValue];
             post_help.category =  [help[@"category"] componentsJoinedByString:@","];
             post_help.imageArray = help[@"image"];
             NSLog(@"%@",post_help.imageArray);
             if (help[@"image"] == nil){
                 NSLog(@"ajfasf");
                 post_help.imageArray = [[NSMutableArray alloc] init];
             }
             
             //NSLog(@"%lu",post_help.imageArray.count);
             [post addObject:post_help];
             
             /*NSLog(@"latitude %f",post_help.lat);
              NSLog(@"longitude %f",post_help.lon);
              NSLog(@"Number of replies %lu",post_help.numberOfReplies);
              NSLog(@"postID %lu",post_help.postID);*/
             //NSLog(@"%lu",post.count);
         }
         [postTable reloadData];
         //NSLog(@"JSON: %@", responseObject);
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [self.view makeToast:@"Network Error"];
     }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Set current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString *)getTime:(NSString *)time;
{
    CGFloat timeSec = [time intValue];
    if (timeSec < 60) {
        return [NSString stringWithFormat:@"%.0f Sec",timeSec];
    }
    else if((timeSec/60) <60){
        return [NSString stringWithFormat:@"%.0f Min",timeSec/60];
    }
    else if((timeSec/3600) <24){
        if ([[NSString stringWithFormat:@"%.0f",timeSec/3600] isEqualToString:@"1"]) {
            return [NSString stringWithFormat:@"%.0f Hr",timeSec/3600];
        }
        return [NSString stringWithFormat:@"%.0f Hrs",timeSec/3600];
    }
    else if ((timeSec/(3600 *24) <5)){
        if ([[NSString stringWithFormat:@"%.0f",timeSec/(3600 *24)] isEqualToString:@"1"]) {
            return [NSString stringWithFormat:@"%.0f Day",timeSec/(3600 *24)];
        }
        return [NSString stringWithFormat:@"%.0f Days",timeSec/(3600 *24)];
    }
    else{
        return @"Show date";
    }
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
    const int movementDistance = -184; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
        [UIView beginAnimations: @"animateTextField" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//What happenes when reply button is clicked(cell expands);

-(IBAction)replyAction:(id)sender;
{
    UIButton* aButton = (UIButton*)sender;
    aButton.titleLabel.textColor = color_691928;
    if([replyValue isEqualToString:[NSString stringWithFormat:@"%ld", (long)aButton.tag]]){
        replyValue = @"";
    }
    else{
        replyValue = [NSString stringWithFormat:@"%ld", (long)aButton.tag];
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:aButton.tag inSection:0];
        //UITableViewCell *cell = [postTable cellForRowAtIndexPath:indexPath];
        /*[UIView animateWithDuration:0.5 animations:^(void){
            [postTable scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:NO];
        }];*/
    }
    [postTable reloadData];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)sendReplyAction:(id)sender;
{
    UIButton *buttonHelp = (UIButton *)sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:buttonHelp.tag];
    postcell *cell = (postcell *)[postTable cellForRowAtIndexPath:indexpath];
    BOOL boolHelp = [replyString length] == 0;
    if(!boolHelp){
        //Conevrting postID to a number
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:cell.postID.text];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"id":myNumber,@"sender":[[NSUserDefaults standardUserDefaults] stringForKey:@"email"],@"comment":replyString};
        //NSDictionary *parameters = @{@"id":myNumber,@"id2":@"hari.katam@gmaIL.COM"};
        
        [manager POST:@"http://rohit1729.webfactional.com/projectm/comment.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.postDict_help = (NSDictionary *)responseObject;
            self.postString_help = self.postDict_help[@"status"];
            //NSLog(@"JSON: %@", responseObject);
            if([self.postString_help isEqualToString:@"comment added"]){
                [self.view makeToast:@"Reply Added"];
                replyValue = @"";
                [postTable reloadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.view makeToast:@"Network Error"];
        }];
    
    }
    else{
        [self.view makeToast:@"Please enter a valid reply"];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)textFieldAction:(id)sender;
{
    UITextField *textHelp = (UITextField *)sender;
    replyString = textHelp.text;
    //NSLog(replyString);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)gotoPostAction:(id)sender;
{
    NSLog(@"Going to post");
    UIButton *buttonHelp = (UIButton *)sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:buttonHelp.tag];
    postcell *cell = (postcell *)[postTable cellForRowAtIndexPath:indexpath];
    post_info *post_cell_help = post[post.count-indexpath.section-1];
    postDetailViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"postDetailViewController"];
    
    viewController.descriptionText = cell.desLabel.text;
    viewController.postProfileNameText = cell.nameLabel.text;
    viewController.categoryText = cell.dataLabel.text;
    viewController.timeText = cell.timeLabel.text;
    viewController.distanceText = cell.distanceLabel.text;
    viewController.latitudeText = cell.latLabel.text;
    viewController.longitudeText = cell.longLabel.text;
    viewController.postProfileImage = cell.thumbnailImageView.image;
    viewController.userProfileImage = cell.thumbnailImageView2.image;
    viewController.postID = cell.postID.text;
    viewController.repliesText = cell.repliesLabel.text;
    viewController.imageArray = post_cell_help.imageArray;
    //NSLog(@"%lu",post_cell_help.imageArray.count);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.navigationBarHidden  = YES;
    [self presentViewController:navigationController animated:NO completion:nil];
    
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Post table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(tableView.tag == 0){
        return [post count];
    }
    else{
        return categoryArray.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        static NSString *simpleTableIdentifier = @"infocell";
        
        post_info *post_cell_help = post[post.count-indexPath.section-1];
        postcell *cell = (postcell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"postcell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //rounded edges of a post
        [cell.layer setCornerRadius:10.0f];
        [cell.layer setMasksToBounds:YES];
        [cell.layer setBorderWidth:0.2];
        
        //Set description label
        cell.desLabel.text = post_cell_help.description;
        
        //Set post id of post
        cell.postID.text = [NSString stringWithFormat:@"%ld", (long)post_cell_help.postID];
        
        //Set attributes to rply textField
        cell.replyTextField.delegate = self;
        
        //Set number of replies label layout
        cell.repliesLabel.layer.cornerRadius = 8;
        cell.repliesLabel.layer.masksToBounds = YES;
        cell.repliesLabel.text = [NSString stringWithFormat:@"%ld", (long)post_cell_help.numberOfReplies];
        
        //Set Action to reply button
        [cell.replyButton addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.replyButton.tag = indexPath.section;
        cell.replyButton.titleLabel.textColor = color_691928;
        
        //Set Action to reply button
        [cell.gotoPostButton addTarget:self action:@selector(gotoPostAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.gotoPostButton.tag = indexPath.section;
        cell.gotoPostButton.titleLabel.textColor = color_691928;
        
        //Set Action to send button
        [cell.sendButton addTarget:self action:@selector(sendReplyAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.sendButton.tag = indexPath.section;
        //cell.sendButton.titleLabel.textColor = color_691928;
        
        //Set action to reply textfield
        [cell.replyTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        cell.replyTextField.layer.masksToBounds = YES;
        cell.replyTextField.layer.cornerRadius = 15;
        cell.replyTextField.layer.borderWidth = 0.5;
        cell.replyTextField.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        //Set laitude and longitude
        CLLocation *locA = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
        CLLocation *locB = [[CLLocation alloc] initWithLatitude:post_cell_help.lat longitude:post_cell_help.lon];
        CLLocationDistance distance = [locA distanceFromLocation:locB];
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi",(distance/1609.34)];
        cell.latLabel.text = [NSString stringWithFormat:@"%f", post_cell_help.lat];
        cell.longLabel.text = [NSString stringWithFormat:@"%f", post_cell_help.lon];
        
        //Set category address and time
        NSArray *myStrings = [[NSArray alloc] initWithObjects:post_cell_help.category,post_cell_help.when,post_cell_help.where,nil];
        NSString *joinedString = [myStrings componentsJoinedByString:@" / "];
        cell.dataLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.dataLabel.numberOfLines = 0;
        cell.dataLabel.text = joinedString;
        
        //Set profile pic of the user
        cell.thumbnailImageView.layer.masksToBounds = YES;
        cell.thumbnailImageView.layer.cornerRadius = 21.5;
        //cell.thumbnailImageView.image = post_cell_help.img;
        
        cell.thumbnailImageView2.layer.masksToBounds = YES;
        cell.thumbnailImageView2.layer.cornerRadius = 15;
        //cell.thumbnailImageView2.image = [UIImage imageNamed:@"profile3.jpeg"];
        
        //Time stamp
        NSDate *dateFromString = [dateFormatter dateFromString:post_cell_help.time];
        secs = [[NSDate date] timeIntervalSinceDate:dateFromString];
        
        if([[self getTime:[NSString stringWithFormat:@"%f",secs]] isEqualToString:@"Show date"]){
            cell.timeLabel.text = [dateFormatter_help stringFromDate:dateFromString];
        }
        else{
            cell.timeLabel.text = [self getTime:[NSString stringWithFormat:@"%f",secs]];
        }
        
        cell.nameLabel.text = post_cell_help.name;
        
        //Image caching
        NSString *imageString = [post_cell_help.emailid stringByAppendingString:@".jpg"];
        UIImage *image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
        cell.thumbnailImageView.image = [UIImage imageNamed:@"nopic.jpg"];
        
        if(image)
        {
            //NSLog(@"cached");
            cell.thumbnailImageView.image = image;
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
                        cell.thumbnailImageView.image = image;
                        [[CacheController sharedInstance] setCache:image forKey:imageString ];
                    }
                    else{
                        cell.thumbnailImageView.image = [UIImage imageNamed:@"nopic.jpg"];
                    }
                });
            });
        }
        
        //Image caching
        imageString = [NSString stringWithFormat:@"small%@.jpg",[[NSUserDefaults standardUserDefaults] stringForKey:@"email"]];//@"hari.katam@gmail.com.jpg"
        image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
        cell.thumbnailImageView2.image = [UIImage imageNamed:@"nopic.jpg"];
        
        if(image)
        {
            //NSLog(@"cached");
            cell.thumbnailImageView2.image = image;
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
                        cell.thumbnailImageView2.image = image;
                        [[CacheController sharedInstance] setCache:image forKey:imageString ];
                    }
                    else{
                        cell.thumbnailImageView2.image = [UIImage imageNamed:@"nopic.jpg"];
                    }
                });
            });
        }
        
        return cell;
    }
    else{
        static NSString *simpleTableIdentifier = @"catInfoCell";
        
        categoryCell *cell = (categoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //rounded edges of a post
        [cell.layer setCornerRadius:0.0f];
        [cell.layer setMasksToBounds:YES];
        [cell.layer setBorderWidth:0.0f];
        cell.backgroundColor = [UIColor blackColor];
        
        //categoryInfo *cathelp = categoryArray[indexPath.section];
        cell.notLabel.layer.masksToBounds = YES;
        cell.notLabel.layer.cornerRadius = 7;
        cell.notLabel.text = @"10";
        
        cell.totalLabel.layer.masksToBounds = YES;
        cell.totalLabel.layer.cornerRadius = 6;
        cell.totalLabel.text = @"1674";
        
        cell.categoryView.layer.masksToBounds = YES;
        cell.categoryView.layer.cornerRadius = 5;
        cell.categoryView.backgroundColor = color_691928;
        cell.categoryView.layer.borderColor = [[UIColor whiteColor]CGColor];
        cell.categoryView.layer.borderWidth = 1;
        
        cell.categoryLabel.text = [categoryArray[indexPath.section] uppercaseString];
        cell.categoryLabel.layer.cornerRadius = 5;
        cell.categoryLabel.backgroundColor = [UIColor whiteColor];
        cell.categoryLabel.textColor = [UIColor blackColor];
        cell.categoryLabel.adjustsFontSizeToFitWidth = YES;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   if (tableView.tag == 1) {
        NSLog(@"%lu",tableView.tag);
        categoryCell *cell = (categoryCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"%@",cell.categoryLabel.text);
        NSLog(@"%lu",indexPath.section);
        [navigationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        if([[NSString stringWithFormat:@"%ld", (long)indexPath.section] isEqualToString:replyValue]){
            return 140;
        }
        else{
            return 95;
        }
    }
    else{
        return 80;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView.tag == 0){
        return 3;
    }
    else return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 5)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
