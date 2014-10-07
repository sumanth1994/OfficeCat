//
//  categoryViewController.m
//  test
//
//  Created by Poddar on 5/21/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "categoryViewController.h"
#import "categoryCell.h"
#import "categoryInfo.h"

@interface categoryViewController ()

@end

@implementation categoryViewController


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    //background color
    self.view.backgroundColor = [UIColor blackColor];
    postTable.backgroundColor = color_691928;
    
    CGRect newFrame = self.view.frame;
    
    newFrame.size.width = 200;
    newFrame.size.height = 200;
    [self.view setFrame:newFrame];
    
    categoryArray = [NSMutableArray arrayWithObjects:@"Music",@"Fun",@"Movies",@"Office",@"Sports",@"Buy/Sell",@"Travelling",@"HomeWork",@"Borrow",@"Mothers",@"Food",@"Teen",nil];
    
    // Do any additional setup after loading the view.
}


//#pragma mark - posttable data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [categoryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"catInfoCell";
    
    categoryCell *cell = (categoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"categoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //rounded edges of a post
    [cell.layer setCornerRadius:0.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:0.0f];
    cell.backgroundColor = [UIColor blackColor];
    
    //categoryInfo *cathelp = categoryArray[indexPath.row];
    cell.notLabel.layer.masksToBounds = YES;
    cell.notLabel.layer.cornerRadius = 7;
    cell.notLabel.text = @"10";

    cell.totalLabel.layer.masksToBounds = YES;
    cell.totalLabel.layer.cornerRadius = 6;
    cell.totalLabel.text = @"1674";
    
    cell.categoryView.layer.masksToBounds = YES;
    cell.categoryView.layer.cornerRadius = 5;
    cell.categoryView.backgroundColor = color_691928;
    cell.categoryView.layer.borderColor = [[UIColor whiteColor]CGColor];
    cell.categoryView.layer.borderWidth = 1;
    
    cell.categoryLabel.text = categoryArray[indexPath.row];
    cell.categoryLabel.layer.cornerRadius = 5;
    cell.categoryLabel.backgroundColor = [UIColor whiteColor];
    cell.categoryLabel.textColor = [UIColor blackColor];
    cell.categoryLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
