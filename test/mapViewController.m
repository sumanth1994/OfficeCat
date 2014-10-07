//
//  mapViewController.m
//  test
//
//  Created by Poddar on 5/27/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "mapViewController.h"
#import "categoryCell.h"
#import "categoryInfo.h"
#import "MyAnnotation.h"
#import "newPostViewController.h"

@interface mapViewController ()

@end

@implementation mapViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"saveLocation"]) {
        newPostViewController *destViewController = segue.destinationViewController;
        destViewController.chosenLocation = locationLabel.text;
        destViewController.chosenLatitude = [[NSNumber numberWithFloat:lat] stringValue];
        destViewController.chosenLongitude = [[NSNumber numberWithFloat:lng] stringValue];
        destViewController.locationIndex = @"3";
        destViewController.helpVariable = @"1";
    }
}

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
    locationData = cell.textLabel.text;
    [mypin setCoordinate:[self geoCodeUsingAddress:locationData]];
    lat = [self geoCodeUsingAddress:locationData].latitude;
    lng = [self geoCodeUsingAddress:locationData].longitude;
    MKCoordinateRegion region;
    region.center.latitude = [self geoCodeUsingAddress:locationData].latitude;
    region.center.longitude = [self geoCodeUsingAddress:locationData].longitude;
    region.span.latitudeDelta = 0.001f;
    region.span.longitudeDelta = 0.001f;
    [mapview setRegion:region animated:YES];
    //locationLabel.text =[[self geoCodeUsingAddress:locationData].latitude ;
    [self.searchBar resignFirstResponder];    tableView.hidden = YES;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//When check button is pressed
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

//Update the array while typing the location/suggestionsarray
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [suggestionsArray removeAllObjects];
    if([searchText isEqualToString:@""] ) {
        suggestionTable.hidden = YES;
    }
    else
    {
        suggestionTable.hidden = NO;
    }
    //[searchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:searchText completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        //CLPlacemark *placemark = [placemarks objectAtIndex:0];
        for (CLPlacemark *placemark in placemarks) {
            [suggestionsArray addObject:[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
        }
        [suggestionTable reloadData];
    }];
}

//Go to the location after typing the location
/*-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        //Print the location to console
        NSLog(@"I am currently at %@",locatedAt);
        MKCoordinateRegion region;
        region.center.latitude = placemark.region.center.latitude;
        region.center.longitude = placemark.region.center.longitude;
        MKCoordinateSpan span;
        double radius = placemark.region.radius / 100; // convert to km
        //NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
        span.latitudeDelta = radius / 112.0;
        region.span = span;
        [mapview setRegion:region animated:YES];
    }];
    suggestionTable.hidden = YES;

} */

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"Pin"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"Pin"]; // If you use ARC, take out 'autorelease'
    } else {
        pin.annotation = annotation;
    }
    pin.animatesDrop = YES;
    pin.draggable = YES;
    
    return pin;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        //NSLog(@"\m/ Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        [customPin setCoordinate:droppedAt];
        [mapview addAnnotation:customPin];
        lat = droppedAt.latitude;
        lng = droppedAt.longitude;
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];  //selecting the first option suggested for given lat n lng
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];

    //[label setText:[NSString stringWithFormat:@"%d", (int)value]];
    NSString *yo;
    yo= [NSString stringWithFormat:@"%.20lf", value];
    NSLog(@"%@",yo);
    MKCoordinateRegion newRegion=MKCoordinateRegionMake(mapview.region.center,MKCoordinateSpanMake(50/value, 50/value));
    [mapview setRegion:newRegion];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate = userLocation.location.coordinate;
    
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    
    lat = userLocation.coordinate.latitude;
    lng = userLocation.coordinate.longitude;
    
    //mypin = [[MyAnnotation alloc] initWithCoordinate:userLocation.coordinate];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    //[self.mapView addAnnotation:point];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender;
{
    CGPoint point = [sender locationInView:mapview];
    CLLocationCoordinate2D locCoord = [mapview convertPoint:point toCoordinateFromView:mapview];
    [customPin setCoordinate:locCoord];
    [mapview addAnnotation:customPin];
    lat = locCoord.latitude;
    lng = locCoord.longitude;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

- (void)viewDidLoad
{
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    //self.view.backgroundColor = color_f7e9b7;
    
    //Navigation view color
    navigationView.backgroundColor = color_691928;
    navigationLabel.textColor = color_f7e9b7;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
    
    locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    locationLabel.numberOfLines = 0;
    
    //Long press drop a pin
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [mapview addGestureRecognizer:longPressGesture];
    
    suggestionsArray = [[NSMutableArray alloc] init];
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    
    customPin = [[MyAnnotation alloc] init];
    mypin = [[MyAnnotation alloc] initWithCoordinate:mapview.userLocation.coordinate];
    
    lat = mapview.userLocation.coordinate.latitude;
    lng = mapview.userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        locationLabel.text = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
    }];
    
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];*/
    // Do any additional setup after loading the view.
    
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    NSLog(@"asfdads");
    return UIStatusBarStyleLightContent;
}


- (void) dismissKeyboard
{
    // add self
    [suggestionTable resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
