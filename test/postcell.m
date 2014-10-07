//
//  postcell.m
//  test
//
//  Created by Poddar on 5/20/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "postcell.h"

@implementation postcell


@synthesize nameLabel;
@synthesize desLabel;
@synthesize longLabel;
@synthesize latLabel;
@synthesize thumbnailImageView;
@synthesize thumbnailImageView2;
@synthesize timeLabel;
@synthesize repliesLabel;
@synthesize dataLabel;
@synthesize backView1;
@synthesize backView2;
@synthesize backView3;
@synthesize replyButton;
@synthesize replyTextField;
@synthesize sendButton;
@synthesize gotoPostButton;

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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)awakeFromNib
{
    // Initialization code
    //textView.backgroundColor = [UIColor colorWithRed:247 green:233 blue:183 alpha:1];
   // [textView setBackgroundColor: [self colorWithHexString:@"FFFFFF"]];
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    self.backgroundColor = color_691928;
    backView1.backgroundColor = color_f7e9b7;
    backView3.backgroundColor = color_f7e9b7;
    repliesLabel.backgroundColor = color_691928;
    repliesLabel.textColor = [UIColor whiteColor];
    replyButton.titleLabel.textColor = color_691928;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
