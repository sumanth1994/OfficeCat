//
//  categoryCell.h
//  test
//
//  Created by Poddar on 5/21/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface categoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *notLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UIView *categoryView;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;

@end
