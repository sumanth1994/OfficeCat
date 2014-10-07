//
//  category.m
//  test
//
//  Created by Poddar on 5/20/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "category.h"

@interface category ()

@end

@implementation category


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    switch (indexPath.row) {
        case 0:
            identifier = @"firstCategory";
            break;
        case 1:
            identifier = @"secondCategory";
            break;
        default:
            break;
    }
    return identifier;
}

@end
