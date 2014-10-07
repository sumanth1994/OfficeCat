//
//  newGroupViewController.h
//  chatPart
//
//  Created by Harinandan Teja on 6/30/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import <UIKit/UIKit.h>

UIColor *color_691928;
UIColor *color_f7e9b7;
UIColor *color_bf9fa5;

@interface newGroupViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    
    UIImagePickerController *imagePicker;
    UIActionSheet *popup;
    IBOutlet UIImageView *groupImage;
    NSData *groupPicData;

    IBOutlet UICollectionView *membersCollection;
    IBOutlet UITextField *groupNameField;
    IBOutlet UITextView *descriptionField;
    IBOutlet UIButton *searchButton;
    IBOutlet UIButton *contactsSearchButton;
    IBOutlet UIButton *picChangeButton;
    IBOutlet UIView *navigationView;
    IBOutlet UILabel *navigationLabel;
    
    IBOutlet UILabel *membersLabel;
    NSString *selectedMemIndex;
    NSMutableArray *membersID;
}

-(IBAction)createAction:(id)sender;
-(IBAction)attachImageAction:(id)sender;

@end
