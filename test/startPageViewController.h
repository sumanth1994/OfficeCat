//
//  startPageViewController.h
//  test
//
//  Created by Poddar on 5/30/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface startPageViewController : UIViewController<KASlideShowDelegate>{
    IBOutlet UIImageView *loadingSymbol1;
    IBOutlet UIImageView *loadingSymbol2;
    IBOutlet UIImageView *loadingSymbol3;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *registerButton;    
}

@end
