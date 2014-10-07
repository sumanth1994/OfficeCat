//
//  locationSettingViewController.m
//  test
//
//  Created by Harinandan Teja on 6/13/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "locationSettingViewController.h"

@interface locationSettingViewController ()

@end

@implementation locationSettingViewController

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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)changeAction1:(id)sender;
{
    [popup1 showInView:[UIApplication sharedApplication].keyWindow];
}
-(IBAction)changeAction2:(id)sender;
{
    [popup2 showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)pop clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (pop.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    NSLog(@"1 CURRENT");
                    preferred1Label.text = currentLocationLabel.text;
                    break;
                case 1:
                {
                    customMapview.hidden = NO;
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
                    NSLog(@"2 CURRENT");
                    preferred2Label.text = currentLocationLabel.text;
                    break;
                case 1:
                    NSLog(@"2 CUSTOM");
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = color_f7e9b7;//[UIColor whiteColor];
    navigationView.backgroundColor = color_691928;
    
    //Button tint color
    change1Button.tintColor = color_691928;
    change2Button.tintColor = color_691928;
    
    //popup for preferred location
    
    //Initialize action sheet when change button is pressed
    popup1 = [[UIActionSheet alloc] initWithTitle:@"Set options for preferred location1" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
             @"Current Location",
             @"Custom Location",
             nil];
    popup1.tag = 1;
    
    popup2 = [[UIActionSheet alloc] initWithTitle:@"Set options for preferred location2" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
              @"Current Location",
              @"Custom Location",
              nil];
    popup2.tag = 2;
    
    //Mapview initialization
    mapview = [[MKMapView alloc] init];
    mapview.showsUserLocation = YES;
    mapview.mapType = MKMapTypeStandard;
    mapview.delegate = self;
    
    //Custom map view attributes
    customMapview.layer.masksToBounds = YES;
    customMapview.layer.borderWidth = 1.0f;
    customMapview.layer.cornerRadius = 20;
    
    //Setting a pin at current location;
    customPin = [[MyAnnotation alloc] init];
    customPin = [[MyAnnotation alloc] initWithCoordinate:mapview.userLocation.coordinate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
