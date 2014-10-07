//
//  groupMapViewController.m
//  test
//
//  Created by Harinandan Teja on 7/5/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "groupMapViewController.h"
#import "groupNewPostViewController.h"
#import "createPostViewController.h"

@interface groupMapViewController ()

@end

@implementation groupMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    navigationLabel.textColor = color_f7e9b7;
    navigationView.backgroundColor = color_691928;
    
    searchbar.tintColor = color_691928;
    searchbar.delegate = self;
    
    searchTable.delegate = self;
    searchTable.dataSource = self;
    
    suggestionsArray = [[NSMutableArray alloc] init];
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [mapview addGestureRecognizer:longPressGesture];
    longPressGesture.minimumPressDuration = 1;
    
    locationLabel.adjustsFontSizeToFitWidth = YES;
    locationLabel.numberOfLines = 0;
    
    annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = mapview.userLocation.coordinate;
    annotation.title = @"Current Location";
    annotation.subtitle = @"You are here";
    [mapview addAnnotation:annotation];
    
    grpMapLat = mapview.userLocation.coordinate.latitude;
    grpMapLong = mapview.userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:grpMapLat longitude:grpMapLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
    NSLog(@"updating location");
    
    //[mapview removeAnnotation:annotation];
    annotation.coordinate = userLocation.coordinate;
    annotation.title = @"Updated Location";
    annotation.subtitle = @"You are here";
    [mapview addAnnotation:annotation];
    
    grpMapLat = userLocation.coordinate.latitude;
    grpMapLong = userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:grpMapLat longitude:grpMapLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        //annotation = [[MyAnnotation alloc] initWithCoordinate:droppedAt];
        //[annotation setCoordinate:droppedAt];
        [mapview removeAnnotation:annotation];
        annotation.coordinate = droppedAt;
        annotation.title = @"Dropped Here";
        [mapview addAnnotation:annotation];
        grpMapLat = droppedAt.latitude;
        grpMapLong = droppedAt.longitude;
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:grpMapLat longitude:grpMapLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];  //selecting the first option suggested for given lat n lng
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender;
{
    NSLog(@"long press");
    CGPoint point = [sender locationInView:mapview];
    CLLocationCoordinate2D locCoord = [mapview convertPoint:point toCoordinateFromView:mapview];
    
    [mapview removeAnnotation:annotation];
    annotation.coordinate = locCoord;
    annotation.title = @"Hold here";
    [mapview addAnnotation:annotation];
    
    grpMapLat = locCoord.latitude;
    grpMapLong = locCoord.longitude;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:grpMapLat longitude:grpMapLong];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [suggestionsArray removeAllObjects];
    if([searchText isEqualToString:@""] ) {
        searchTable.hidden = YES;
    }
    else
    {
        searchTable.hidden = NO;
    }

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchText completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            [suggestionsArray addObject:[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
        }
        [searchTable reloadData];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [suggestionsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"InfoCell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:self options:nil];
        //cell = [nib objectAtIndex:0];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    //rounded edges of a post
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = suggestionsArray[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    locationLabel.text = cell.textLabel.text;
    
    [annotation setCoordinate:[self geoCodeUsingAddress:locationLabel.text]];
    grpMapLat = [self geoCodeUsingAddress:locationLabel.text].latitude;
    grpMapLong = [self geoCodeUsingAddress:locationLabel.text].longitude;
    
    MKCoordinateRegion region = mapview.region;
    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:grpMapLat longitude:grpMapLong];
    region.center = centerLocation.coordinate;
    region.span.longitudeDelta /= 1500; // Bigger the value, closer the map view
    region.span.latitudeDelta /= 1500;
    [mapview setRegion:region animated:YES];

    //locationLabel.text =[[self geoCodeUsingAddress:locationData].latitude ;
    
    [searchbar resignFirstResponder];    tableView.hidden = YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) anno {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"Pin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: anno reuseIdentifier: @"Pin"];
    } else {
        pin.annotation = anno;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    
    return pin;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)saveAction:(id)sender;
{
    if([_from isEqualToString:@"Group"]){
        groupNewPostViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupNewPostViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        
        viewController.help = @"From Map";
        viewController.locationString = locationLabel.text;
        viewController.imageArray = _imageArray;
        viewController.dateString = _dateString;
        viewController.postLat = [NSString stringWithFormat:@"%f",grpMapLat];
        viewController.postLong = [NSString stringWithFormat:@"%f",grpMapLong];
        viewController.desString = _desString;
        viewController.grpID = _grpID;
        [self presentViewController:navigationController animated:NO completion:nil];
    }
    else{
        createPostViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"createPostViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        
        viewController.help = @"From Map";
        viewController.locationString = locationLabel.text;
        viewController.imageArray = _imageArray;
        viewController.dateString = _dateString;
        viewController.postLat = [NSString stringWithFormat:@"%f",grpMapLat];
        viewController.postLong = [NSString stringWithFormat:@"%f",grpMapLong];
        viewController.desString = _desString;
        viewController.categoryArray = _categoryArray;
        [self presentViewController:navigationController animated:NO completion:nil];
    }

}

-(IBAction)cancelAction:(id)sender;
{
    if(![_from isEqualToString:@"Group"]){
        createPostViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"createPostViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        
        viewController.help = @"From Map";
        viewController.locationString = _locationString;
        viewController.imageArray = _imageArray;
        viewController.dateString = _dateString;
        viewController.postLat = _postLat;
        viewController.postLong = _postLat;
        viewController.desString = _desString;
        viewController.categoryArray = _categoryArray;
        [self presentViewController:navigationController animated:NO completion:nil];
    }
    else{
        groupNewPostViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupNewPostViewController"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        navigationController.navigationBarHidden  = YES;
        
        viewController.help = @"From Map";
        viewController.locationString = _locationString;
        viewController.imageArray = _imageArray;
        viewController.dateString = _dateString;
        viewController.postLat = _postLat;
        viewController.postLong = _postLat;
        viewController.desString = _desString;
        viewController.grpID = _grpID;
        [self presentViewController:navigationController animated:NO completion:nil];

    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
