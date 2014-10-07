//
//  newPostViewController.m
//  test
//
//  Created by Poddar on 5/22/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "newPostViewController.h"
#import "post_info.h"
#import "postVIewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "mapViewController.h"
#import "UIView+Toast.h"
#import <AFNetworking/AFNetworking.h>
#import <FXBlurView/FXBlurView.h>

static const CGFloat imageMaxLimit = 6;

@interface newPostViewController ()

@property(strong,nonatomic) NSDictionary *postDict;
@property(strong,nonatomic) NSString *postString;

@end


@implementation newPostViewController

-(void)saveToUserDefaultsDescription:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"description"];
        [standardUserDefaults synchronize];
    }
}

-(void)saveToUserDefaultsDate:(NSString*)myString
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:@"date"];
        [standardUserDefaults synchronize];
    }
}

-(void)saveToUserDefaultsCategory:(NSMutableArray*)myArray
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myArray forKey:@"category"];
        [standardUserDefaults synchronize];
    }
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

//Action when post button is pressed
-(IBAction)postAction:(id)sender;
{
    //image uploading
    if(arrayImageData.count > 0)
    {
        NSString *urlString = [NSString stringWithFormat:@"http://rohit1729.webfactional.com/up.php"];
        emailId = @"himank.ajmera@gmail.com";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        int i;
        for(i =0; i<[arrayImageData count];i++)
        {
            NSLog(@"check");
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[]\"; filename=\"%@_%d.jpg\"\r\n",emailId,i+1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:arrayImageData[i]]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Image Return String: %@", returnString);
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //parameter uploading
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateForEvent = [dateFormatter stringFromDate:datepicker.date];
    for (int i=0; i<[selectedIndex count]; i++) {
        [selectedCategories addObject:[selectedIndex objectAtIndex:i]];
    }
    descriptionData = descriptionTextview.text;
    locationAdress = _locationFromMapLabel.text;
    latitude = _chosenLatitude;
    longitude = _chosenLongitude;
    
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:selectedIndex options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    if(![descriptionData isEqualToString:@""] && (selectedCategories.count > 0))
    {
        [self.view makeToast:@"Posting...."];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{@"longitude": longitude, @"latitude": latitude, @"address": locationAdress, @"message": descriptionData, @"date": dateForEvent, @"id": @"himank.ajmera@gmail.com", @"name": @"slim shady", @"category": jsonString, @"image": jsonString };
        
        [manager POST:@"http://rohit1729.webfactional.com/projectm/index.php" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"success");
             self.postDict = (NSDictionary *) responseObject;
             self.postString = self.postDict[@"status"];
             NSLog(@"JSON: %@", self.postString);
             NSLog(@"JSON: %@", responseObject);
             [self.view makeToast:@"Post added"];
             postVIewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"postVIewController"];
             UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
             navigationController.navigationBarHidden  = YES;
             [self presentViewController:navigationController animated:NO completion:nil];
             
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
             NSLog(@"Error: %@", error);
             [self.view makeToast:@"Network Error"];
         }];
    }
    else{
        [self.view makeToast:@"Please enter all the information"];
    }

}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Action when datepicker value is changed
-(void)dateSelection:(id)sender;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"dd - MM - YYYY"];
    dateForEvent = [dateFormatter stringFromDate:datepicker.date];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Action when category button is presed
-(IBAction)categoryAction:(id)sender;
{
    blurView.hidden = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Categories"
                                                    message:@"Please select the category you want to post into"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 2;
    UITableView *myView = [[UITableView alloc] initWithFrame:CGRectMake(0,  0, 250,350)] ;
    //[myView setRowHeight:40];
    myView.scrollEnabled = NO;
    myView.delegate = self;
    myView.dataSource = self;
    myView.backgroundColor = [UIColor clearColor];
    //myView.separatorColor = [UIColor clearColor];
    myView.allowsMultipleSelection = YES;
    [alert setValue:myView forKey:@"accessoryView"];
    //[alert addSubview:myView];
    [alert show];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//Number of categories
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [categoryNames count];
}

-(void)assignCategoryLabels
{
    if(selectedIndex.count == 0){
        selectedCategory.hidden = YES;
    }
    else{
        NSMutableArray *help = [[NSMutableArray alloc] init];
        for (int i=0; i<selectedIndex.count; i++) {
            [help addObject:selectedIndex[i]];
        }
        selectedCategory.hidden = NO;
        selectedCategory.text = [help componentsJoinedByString:@" , "];
    }    
}

//What happenes when u select a row(multiple selection)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *selectedCells = [tableView indexPathsForSelectedRows];
    if(selectedIndex.count<=2){
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [selectedIndex removeObject:categoryNames[indexPath.row]];
        }else{
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedIndex addObject:categoryNames[indexPath.row]];
        }
    }
    else{
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [selectedIndex removeObject:categoryNames[indexPath.row]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}


//Define height of each row in tableview(category on alert view)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29.5;
}

//Define each cell for the category view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const SwitchCellID = @"SwitchCell";
    UITableViewCell* aCell = [tableView dequeueReusableCellWithIdentifier:SwitchCellID];
    if( aCell == nil ) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellID];
    }
    aCell.textLabel.text = categoryNames[indexPath.row];//[NSString stringWithFormat:@"Option %d", [indexPath row] + 1];
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([selectedIndex indexOfObject:categoryNames[indexPath.row]] != NSNotFound){
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([selectedIndex containsObject:categoryNames[indexPath.row]]){
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    aCell.backgroundColor = [UIColor clearColor];
    return aCell;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Action when the date button is pressed
-(IBAction)dateButtonPressed:(UIButton *)sender;
{
    blurView.hidden = NO;
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Date" message:@"Please select the date of the event" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    datepicker.date = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 2 ];
    datepicker.minimumDate = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 0 ];
    [v addSubview:datepicker];
    [av setValue:v forKey:@"accessoryView"];
    av.tag = 1;
    [av show];
    
}

//To change the date when the ok button is pressed
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        switch (alertView.tag) {
            case 1:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                todayDate.text = [dateFormatter stringFromDate:datepicker.date];
                blurView.hidden = YES;
            }
                
                break;
            case 2:
            {
                [self assignCategoryLabels];
                blurView.hidden = YES;
            }
                break;
            case 3:
            {
                [selectedImages removeObjectAtIndex:selectedImageIndex];
                [imageCollection reloadData];
                [self.view makeToast:@"Item Deleted"];
                blurView.hidden = YES;
            }
                break;
                
            default:
                break;
        }
    }
    else{
        blurView.hidden = YES;
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Action when the attach button is pressed
-(IBAction)attachment:(id)sender;{
    blurView.hidden = NO;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)locationAction:(id)sender;
{
    blurView.hidden = NO;
    [locationPopup showInView:[UIApplication sharedApplication].keyWindow];
}

//Actions according the button pressed in the action sheet
- (void)actionSheet:(UIActionSheet *)pop clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (pop.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {   NSLog(@"camera");
                    if(selectedImages.count <imageMaxLimit){
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.allowsEditing = NO;
                        [self presentViewController:imagePicker animated:YES completion:Nil];
                    }
                    else{
                        [self.view makeToast:@"Attachment Limit exceded"];
                    }
                    blurView.hidden = YES;
                }
                    break;
                case 1:
                {   NSLog(@"Gallery");
                    if(selectedImages.count <imageMaxLimit){
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                        imagePicker.allowsEditing = NO;
                        [self presentViewController:imagePicker animated:YES completion:Nil];
                    }
                     else {
                        [self.view makeToast:@"Attachment Limit exceded"];
                     }
                    blurView.hidden = YES;
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (buttonIndex) {
                case 0:
                    NSLog(@"Current Location");
                    _locationIndex = @"0";
                    self.locationFromMapLabel.text = currentLocation;
                    blurView.hidden = YES;
                    break;
                case 1:
                    _locationIndex = @"1";
                    blurView.hidden = YES;
                    break;
                case 3:
                {
                    NSLog(@"custom location tapped");
                    _locationIndex = @"3";
                    [self saveToUserDefaultsDate:todayDate.text];
                    [self saveToUserDefaultsDescription:descriptionTextview.text];
                    [self saveToUserDefaultsCategory:selectedIndex];
                    mapViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mapViewController"];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    navigationController.navigationBar.hidden = YES;
                    [self presentViewController:navigationController animated:NO completion:nil];
                    blurView.hidden = YES;
                }
                    break;
                default:
                    blurView.hidden = YES;
                    break;
            }
            break;            
        }
        default:
            break;
    }
    blurView.hidden = YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:Nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageData = UIImageJPEGRepresentation(image, 0.5);
    [arrayImageData addObject:imageData];
    //NSLog([info objectForKey:@"UIImagePickerControllerOriginalImage"]);
    [selectedImages addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    [imageCollection reloadData];
    //[picker dismissViewControllerAnimated:YES completion:Nil];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Selectedf image scrolling collection view
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//Count of number of images selected
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return selectedImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const SwitchCellID = @"AttachCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SwitchCellID forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.layer.masksToBounds = YES;
    recipeImageView.layer.cornerRadius = 15;
    recipeImageView.image = selectedImages[indexPath.row];//[UIImage imageNamed:@"profile1.jpeg"];
    //cell.backgroundView = recipeImageView;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedImageIndex = indexPath.row;
    //NSLog(@"hasd%lu",selectedImageIndex);
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Are you sure you want to delete"
                                                    delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
    deleteAlert.tag = 3;
    deleteAlert.delegate = self;
    [deleteAlert show];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Dismiss Keyboard on tap
-(void)dismissKeyboard {
    [imageCollection resignFirstResponder];
    [descriptionTextview resignFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Going into this");
    mapView.centerCoordinate = userLocation.location.coordinate;
    lat_newPost = userLocation.coordinate.latitude;
    lon_newPost = userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        if(!([_locationIndex isEqualToString:@"1"]&&[_locationIndex isEqualToString:@"2"]&&[_locationIndex isEqualToString:@"3"])){
            self.locationFromMapLabel.text = currentLocation;
        }
        NSLog(@"Current Location %@",currentLocation);
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Blur view
    blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 650, 650)];
    [blurView setDynamic:YES];
    blurView.tintColor = color_691928;
    [self.view addSubview:blurView];
    blurView.hidden = YES;
    
    //background color
    self.view.backgroundColor = [UIColor whiteColor];//color_f7e9b7;
    
    //Navigation bar color
    navigationView.backgroundColor = color_691928;
    navigationLabel.textColor = color_f7e9b7;
    
    //Textview background color
    descriptionTextview.backgroundColor = color_f7e9b7;// color_691928;
    descriptionTextview.textColor = [UIColor blackColor];
    
    //Image collection background;
    imageCollection.backgroundColor = color_f7e9b7;// color_691928;
    
    [super viewDidLoad];
    self.locationFromMapLabel.adjustsFontSizeToFitWidth = YES;
    
    //Get current location
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    lat_newPost = mapview.userLocation.coordinate.latitude;
    lon_newPost = mapview.userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lati longitude:longi];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        if(!([_locationIndex isEqualToString:@"1"]&&[_locationIndex isEqualToString:@"2"]&&[_locationIndex isEqualToString:@"3"])){
            self.locationFromMapLabel.text = currentLocation;
        }
    }];
    
    //To set date limit
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    //Tap to dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Description layout
    [descriptionTextview.layer setMasksToBounds:YES];
    [descriptionTextview.layer setCornerRadius:10];
    [descriptionTextview.layer setBorderWidth:0.1f];
    
    //Image picker for selcting images from gallery/camera
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //Initialising array containing selected images;
    selectedImages = [[NSMutableArray alloc] init];
    [selectedImages addObject:[UIImage imageNamed:@"profile1.jpeg"]];
    [selectedImages addObject:[UIImage imageNamed:@"profile2.jpeg"]];
    [selectedImages addObject:[UIImage imageNamed:@"profile3.jpeg"]];
    [selectedImages addObject:[UIImage imageNamed:@"profile4.jpg"]];
    [selectedImages addObject:[UIImage imageNamed:@"profile5.jpg"]];
    [selectedImages addObject:[UIImage imageNamed:@"profile6.png"]];
    
    //Initialising array containing selected category indices
    selectedIndex = [[NSMutableArray alloc] init];
    
    //list of all category names
    categoryNames = [NSMutableArray arrayWithObjects:@"Music",@"Fun",@"Movies",@"Office",@"Sports",@"Buy/Sell",@"Travelling",@"HomeWork",@"Borrow",@"Mothers",@"Food",@"Teen",nil];
    
    //To set todays date
    todayDate.text = dateString;
    
    //Initialize selected categories array
    selectedCategories = [[NSMutableArray alloc] init];
    selectedCategory.adjustsFontSizeToFitWidth = YES;
             
    //To set the action to date picker in the alertview
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, 0, 60, 250)];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(dateSelection:) forControlEvents:UIControlEventValueChanged];
    
    //Initialize action sheet when attach button is pressed
    popup = [[UIActionSheet alloc] initWithTitle:@"Select attachment options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take a picture",
                            @"Choose from gallery",
                            nil];
    popup.tag = 1;
    
    //Poppup for location selection
    locationPopup = [[UIActionSheet alloc] initWithTitle:@"Select location options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
             @"Current Location",
             @"Preferred Location 1",
             @"Preferred Location 2",
             @"Custom Location",
             nil];
    locationPopup.tag = 2;
    
    //Set current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    _locationFromMapLabel.text = self.chosenLocation ;
    
    //Caching description date category
    if([self.helpVariable isEqualToString:@"1"]){
        NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"description"];
        descriptionTextview.text = savedValue;
        savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"date"];
        todayDate.text = savedValue;
        NSMutableArray *savedArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"category"];
        selectedIndex = [[NSMutableArray alloc] initWithArray:savedArray copyItems:YES];
        [self assignCategoryLabels];
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
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
