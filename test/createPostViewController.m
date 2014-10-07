//
//  createPostViewController.m
//  projectM
//
//  Created by Harinandan Teja on 7/6/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "createPostViewController.h"
#import "groupMapViewController.h"
#import "UIView+Toast.h"

@interface createPostViewController ()

@end

@implementation createPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    navigationLabel.textColor = color_f7e9b7;
    navigationView.backgroundColor = color_691928;
    descriptionView.backgroundColor = color_f7e9b7;
    descriptionView.layer.masksToBounds = YES;
    descriptionView.layer.cornerRadius = 10;
    imageCollection.backgroundColor = color_f7e9b7;
    
    //To set todays date
    currDate = [NSDate date];
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM YYYY"];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

    NSString *todayDate = [dateFormatter stringFromDate:currDate];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, 0, 60, 250)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateSelection:) forControlEvents:UIControlEventValueChanged];
    
    imageCollection.delegate = self;
    imageCollection.dataSource = self;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:createPostLat longitude:createPostLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        NSLog(@"Updated User viewdid Location :%@ ",currentLocation);
    }];
    
    if([self.help isEqualToString:@"From Map"]){
        NSLog(@"from map");
        locationLabel.text = self.locationString;
        dateLabel.text = self.dateString;
        descriptionView.text = self.desString;
        categoryLabel.text = [_categoryArray componentsJoinedByString:@" , "];
        NSLog(@"%lu",_categoryArray.count);
    }
    else{
        NSLog(@"New");
        dateLabel.text = todayDate;
        locationLabel.text = @"No Event Location Selected";
        _imageArray = [[NSMutableArray alloc] init];
        _categoryArray = [[NSMutableArray alloc] init];
        createPostLat = mapview.userLocation.coordinate.latitude;
        createPostLong = mapview.userLocation.coordinate.longitude;
    }
    //list of all category names
    categoryNames = [NSMutableArray arrayWithObjects:@"Music",@"Fun",@"Movies",@"Office",@"Sports",@"Buy/Sell",@"Travelling",@"HomeWork",@"Borrow",@"Mothers",@"Food",@"Teen",nil];
    
    attachPopup = [[UIActionSheet alloc] initWithTitle:@"Select Attachment options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                   @"Take a picture",
                   @"Choose from gallery",
                   nil];
    attachPopup.tag = 1;
    
    locationPopup = [[UIActionSheet alloc] initWithTitle:@"Select Location options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                     @"Current Location",
                     @"Preferred Location 1",
                     @"Preferred Location 2",
                     @"Custom Location",
                     @"Remove",
                     nil];
    locationPopup.tag = 2;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)dismissKeyboard{
    [descriptionView resignFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
    
    createPostLat = userLocation.coordinate.latitude;
    createPostLong = userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:createPostLat longitude:createPostLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        currentLocation = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        NSLog(@"Updated User Location :%@ ",currentLocation);
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)postAction:(id)sender;
{
    if([descriptionView.text isEqualToString:@""] || [locationLabel.text isEqualToString:@"No Event Location Selected"] || [locationLabel.text isEqualToString:@""] || (_categoryArray.count == 0)){
        [self.view makeToast:@"No Post information given"];
    }
    else{
        
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Action when category button is presed
-(IBAction)categoryAction:(id)sender;
{
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
    if(_categoryArray.count == 0){
        categoryLabel.hidden = YES;
    }
    else{
        NSMutableArray *help = [[NSMutableArray alloc] init];
        for (int i=0; i<_categoryArray.count; i++) {
            [help addObject:_categoryArray[i]];
        }
        categoryLabel.hidden = NO;
        categoryLabel.text = [help componentsJoinedByString:@" , "];
    }
}

//What happenes when u select a row(multiple selection)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSArray *selectedCells = [tableView indexPathsForSelectedRows];
    if(_categoryArray.count<=2){
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [_categoryArray removeObject:categoryNames[indexPath.row]];
        }else{
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [_categoryArray addObject:categoryNames[indexPath.row]];
        }
    }
    else{
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [_categoryArray removeObject:categoryNames[indexPath.row]];
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
    if([_categoryArray indexOfObject:categoryNames[indexPath.row]] != NSNotFound){
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([_categoryArray containsObject:categoryNames[indexPath.row]]){
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    aCell.backgroundColor = [UIColor clearColor];
    return aCell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)dateSelection:(id)sender;
{
    _dateString = [dateFormatter stringFromDate:datePicker.date];
}

-(IBAction)dateAction:(id)sender;
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Date" message:@"Please select the date of the event" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    datePicker.date = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 2 ];
    datePicker.minimumDate = [[ NSDate alloc ] initWithTimeIntervalSinceNow: (NSTimeInterval) 0 ];
    [v addSubview:datePicker];
    [av setValue:v forKey:@"accessoryView"];
    av.tag = 1;
    [av show];
}

//To change the date when the ok button is pressed
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1:
        {
            if (buttonIndex == 1)
            {
                dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                dateLabel.text = [dateFormatter stringFromDate:datePicker.date];
                _dateString = [dateFormatter stringFromDate:datePicker.date];
            }
        }
            break;
        case 2:
        {
            [self assignCategoryLabels];
        }
            break;
        default:
            break;
    }
    
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)attachAction:(id)sender;
{
    [attachPopup showInView:[UIApplication sharedApplication].keyWindow];
}

-(IBAction)locationAction:(id)sender;
{
    [locationPopup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:Nil];
                    
                }
                    break;
                case 1:
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    imagePicker.allowsEditing = NO;
                    [self presentViewController:imagePicker animated:YES completion:Nil];
                }
                    break;
                default:
                    break;
            }
            break;
        }
            
        case 2: {
            switch (buttonIndex) {
                case 0:
                {
                    locationLabel.text = currentLocation;
                    _locationString = currentLocation;
                }
                    break;
                case 1:
                {
                    locationLabel.text = @"Preferred Location 1";
                    _locationString = @"Preferred Location 1";
                }
                    break;
                case 2:
                {
                    locationLabel.text = @"Preferred Location 2";
                    _locationString = @"Preferred Location 2";
                }
                    break;
                case 3:
                {
                    groupMapViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupMapViewController"];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                    navigationController.navigationBarHidden  = YES;
                    
                    viewController.locationString = locationLabel.text;
                    viewController.imageArray = _imageArray;
                    viewController.dateString = dateLabel.text;
                    viewController.desString = descriptionView.text;
                    viewController.postLat = [NSString stringWithFormat:@"%f",createPostLat];
                    viewController.postLong = [NSString stringWithFormat:@"%f",createPostLong];
                    viewController.from = @"Post";
                    viewController.categoryArray = _categoryArray;
                    NSLog(@"%lu",_categoryArray.count);
                    [self presentViewController:navigationController animated:NO completion:nil];
                }
                    break;
                case 4:
                {
                    locationLabel.text = @"";
                    _locationString = @"";
                }
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = color_691928;
        }
        if ([subview isKindOfClass:[UILabel class]]) {
            [((UILabel *)subview) setFont:[UIFont boldSystemFontOfSize:15.f]];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    [_imageArray addObject:imageData];
    [imageCollection reloadData];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//Count of number of images selected
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const SwitchCellID = @"AttachCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SwitchCellID forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = color_f7e9b7;
    //cell.layer.masksToBounds = YES;
    //cell.layer.cornerRadius = 23;
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageWithData:_imageArray[indexPath.item]];//[UIImage imageNamed:imageArray[indexPath.item]];
    
    NSLog(@"Image added");
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
