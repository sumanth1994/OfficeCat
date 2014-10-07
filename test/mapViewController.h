//
//  mapViewController.h
//  test
//
//  Created by Poddar on 5/27/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newPostViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

CGFloat lat;
CGFloat lng;
NSMutableArray *suggestionsArray;
NSString *locationData;

@interface mapViewController : UIViewController <UISearchDisplayDelegate,MKMapViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *suggestionTable;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *navigationLabel;
    MyAnnotation *mypin;
    MyAnnotation *customPin;
    IBOutlet MKMapView *mapview;
}

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
-(IBAction)valueChanged:(id)sender;
@end
