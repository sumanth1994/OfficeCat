//
//  post_info.h
//  test
//
//  Created by Poddar on 5/19/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface post_info : NSObject

@property NSString *name;
@property NSString *emailid;
@property NSString *time;
@property NSString *description;
@property CGFloat lat;
@property CGFloat lon;
@property UIImage *img;
@property NSString *category;
@property NSString *when;
@property NSString *where;
@property NSInteger numberOfReplies;
@property NSInteger postID;
@property NSMutableArray *imageArray;

@end
