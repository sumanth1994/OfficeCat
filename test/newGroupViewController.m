//
//  newGroupViewController.m
//  chatPart
//
//  Created by Harinandan Teja on 6/30/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "newGroupViewController.h"
#import "UIView+Toast.h"
#import "CacheController.h"

@interface newGroupViewController ()

@end

@implementation newGroupViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"LOaded");
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //[groupNameField becomeFirstResponder];
    groupNameField.delegate = self;
    descriptionField.delegate = self;
    
    membersID = [[NSMutableArray alloc] init];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    /*[membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];
    [membersID addObject:@"hari.katam@gmail.com"];
    [membersID addObject:@"rohitranjan1729@gmail.com"];
    [membersID addObject:@"poddarmanish9@gmail.com"];
    [membersID addObject:@"himank.ajmera@gmail.com"];*/
    
    membersLabel.adjustsFontSizeToFitWidth = YES;
    membersLabel.text = [[NSString stringWithFormat:@"%lu",membersID.count] stringByAppendingString:@" Members"];
    
     //Color initialization
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    
    membersCollection.delegate = self;
    membersCollection.dataSource = self;
    navigationLabel.textColor = color_f7e9b7;
    
    //Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
    //background color
    //self.view.backgroundColor = [UIColor grayColor];
    navigationView.backgroundColor = color_691928;
    
    groupImage.layer.masksToBounds = YES;
    groupImage.image = [UIImage imageNamed:@"profile6.png"];
    groupImage.layer.cornerRadius = 45;
    
    picChangeButton.layer.masksToBounds = YES;
    picChangeButton.layer.cornerRadius = 12.5;
    
    searchButton.layer.masksToBounds = YES;
    searchButton.backgroundColor = color_691928;
    searchButton.layer.cornerRadius = 10;
    
    contactsSearchButton.layer.masksToBounds = YES;
    contactsSearchButton.backgroundColor = color_691928;
    contactsSearchButton.layer.cornerRadius = 10;
    
    descriptionField.layer.masksToBounds = YES;
    descriptionField.layer.cornerRadius = 15;
    descriptionField.backgroundColor = color_f7e9b7;
    
    groupNameField.backgroundColor = color_691928;
    groupNameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Group Name" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    groupNameField.layer.masksToBounds = YES;
    groupNameField.layer.cornerRadius = 15;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.3; //seconds
    lpgr.delegate = self;
    [membersCollection addGestureRecognizer:lpgr];
    
    popup = [[UIActionSheet alloc] initWithTitle:@"Select groupPic options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
             @"Take a picture",
             @"Choose from gallery",
             @"Remove",
             nil];
    popup.tag = 1;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    CGPoint p = [gestureRecognizer locationInView:membersCollection];
    
    NSIndexPath *indexPath = [membersCollection indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        //UICollectionViewCell* cell = [membersCollection cellForItemAtIndexPath:indexPath];
        NSLog(@"%lu",indexPath.item);
        selectedMemIndex = [NSString stringWithFormat:@"%lu",indexPath.item];
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                              message:@"Remove from the group"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"OK", nil];
        //deleteAlert.backgroundColor = color_691928;
        deleteAlert.tintColor = color_691928;
        deleteAlert.delegate = self;
        [deleteAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [membersID removeObjectAtIndex:[selectedMemIndex integerValue]];
        membersLabel.text = [[NSString stringWithFormat:@"%lu",membersID.count] stringByAppendingString:@" Members"];
        [membersCollection reloadData];
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 141;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)dismissKeyboard
{
    [descriptionField resignFirstResponder];
    [groupNameField resignFirstResponder];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//Count of number of images selected
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return membersID.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* const SwitchCellID = @"memberCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SwitchCellID forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"memberCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = color_f7e9b7;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 23;
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:10];
    //recipeImageView.image = [UIImage imageNamed:@"profile4.jpg"];
    
    NSString *imageString = [@"small" stringByAppendingString:[membersID[indexPath.item] stringByAppendingString:@".jpg"]];
    
    NSLog(@"%@",imageString);
    //Image caching
    UIImage *image = [[CacheController sharedInstance] getCacheForKey:imageString];//[imageCache objectForKey:imageString];
    recipeImageView.image = [UIImage imageNamed:@"nopic.jpg"];
    
    if(image)
    {
        NSLog(@"cached");
        recipeImageView.image = image;
    }
    else
    {
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            NSString* imageURLString = [NSString stringWithFormat:@"http://rohit1729.webfactional.com/profilepic/%@",imageString];
            NSURL *imageURL = [NSURL URLWithString:imageURLString];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image)
                {
                    NSLog(@"Image dowloaded");
                    recipeImageView.image = image;
                    [[CacheController sharedInstance] setCache:image forKey:imageString ];
                }
                else{
                    recipeImageView.image = [UIImage imageNamed:@"nopic.jpg"];
                }
            });
        });
    }    

    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)createAction:(id)sender;
{
    if(![groupNameField.text isEqualToString:@""] && ![descriptionField.text isEqualToString:@""]){
        NSLog(@"%@ -- %@", groupNameField.text,descriptionField.text);
    }
    else{
        [self.view makeToast:@"Please enter all the information"];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Assign group picture
-(IBAction)attachImageAction:(id)sender;
{
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)pop clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (pop.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    [self presentViewController:imagePicker animated:YES completion:Nil];
                    
                }
                    break;
                case 1:
                {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    imagePicker.allowsEditing = YES;
                    [self presentViewController:imagePicker animated:YES completion:Nil];
                }
                    break;
                case 2:
                {
                    groupImage.image = [UIImage imageNamed:@"nopic.jpg"];
                    groupPicData = NULL;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *proPic = [info objectForKey:UIImagePickerControllerOriginalImage];
    groupPicData = UIImageJPEGRepresentation(proPic, 0.5);
    groupImage.image = proPic;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
