//
//  profileViewController.m
//  test
//
//  Created by Poddar on 6/2/14.
//  Copyright (c) 2014 shearwater. All rights reserved.
//

#import "profileViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIView+Toast.h"
#import "postVIewController.h"

@interface profileViewController ()
@property(strong,nonatomic) NSDictionary *postDict;
@property(strong,nonatomic) NSString *postString;
@end

@implementation profileViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [countryArray count];
}

/*- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
 return locationArray[row];//Or, your suitable title; like Choice-a, etc.
 }*/

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    country = countryArray[row];
    countryCode = [codeForCountryDictionary objectForKey:country];
    phoneCodeLabel.text = [@"+" stringByAppendingString:dictDialingCodes[countryCode]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        tView.numberOfLines=1;
        tView.adjustsFontSizeToFitWidth = YES;
    }
    tView.text = countryArray[row];
    return tView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Function for disabling keyboard
-(void)dismissKeyboard;
{
    [firstnameTextField resignFirstResponder];
    [lastnameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)sexAction:(id)sender;
{
    if(sexHelp){
        sexLabel.text = @"Female";
        sexHelp = false;
    }
    else{
        sexLabel.text = @"Male";
        sexHelp =true;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)nextAction:(id)sender;
{
    emailid = @"hari.katam@gmail.com"; //[[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    [firstnameTextField resignFirstResponder];
    [lastnameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    help1 = true;
    
    if(!(firstnameTextField.text.length == 0) && !(lastnameTextField.text.length == 0))
    {
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///// image uploading
        if(help){
            NSString *urlString = [NSString stringWithFormat:@"http://rohit1729.webfactional.com/up.php"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image[]\"; filename=\"%@.jpg\"\r\n", emailid] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            if ([returnString isEqualToString:@"success"])
            {
                help1 = true;
            }
            else{
                help1 = false;
            }
            NSLog(@"Image Return String: %@", returnString);
        }
        
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ///// parameter uploading
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //[[NSUserDefaults standardUserDefaults] stringForKey:@"email"]
        NSDictionary *parameters = @{@"id": @"hitendrakatiyar@gmail.com" ,@"phonenumber":[phoneCodeLabel.text stringByAppendingString:phoneTextField.text] , @"firstname":firstnameTextField.text,@"lastname":lastnameTextField.text,@"dob":dobString,@"sex":sexLabel.text};
        [manager POST:@"http://rohit1729.webfactional.com/projectm/profile.php" parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             self.postDict = (NSDictionary *) responseObject;
             self.postString = self.postDict[@"status"];
             NSLog(@"JSON: %@", self.postString);
             NSLog(@"JSON: %@", responseObject);
             if([self.postString isEqualToString:@"Profile updated"] && help1)
             {
                 [self.view makeToast:@"Profile Updated"];
                 postVIewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"revealviewcontroller"];
                 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
                 navigationController.navigationBarHidden  = YES;
                 [self presentViewController:navigationController animated:NO completion:nil];
                 
             }
         }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [self.view makeToast:@"Network Error"];
         }];
    }
    else{
        [self.view makeToast:@"Please enter all the information"];
    }
    
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(IBAction)dateButtonPressed:(UIButton *)sender;
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Date" message:@"Please select the date of birth" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
    [v addSubview:datepicker];
    [av setValue:v forKey:@"accessoryView"];
    av.tag = 1;
    [av show];
    
}

//To change the date when the ok button is pressed
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        switch (alertView.tag) {
            case 1:
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                dobLabel.text = [dateFormatter stringFromDate:datepicker.date];
            }
                
                break;
            default:
                break;
        }
    }
}

//Action when datepicker value is changed
-(void)dateSelection:(id)sender;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    dobLabel.text = [dateFormatter stringFromDate:datepicker.date];
    dobString = [dateFormatter stringFromDate:datepicker.date];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Action when profile pic button is pressed
-(IBAction)propicAction:(id)sender;
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
                    propicView.image = [UIImage imageNamed:@"nopic.jpg"];
                    help = false;
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
    [picker dismissViewControllerAnimated:YES completion:Nil];
    proPic =[info objectForKey:UIImagePickerControllerOriginalImage];
    imageData = UIImageJPEGRepresentation(proPic, 0.5);
    NSLog(@"%@",imageData);
    propicView.image = proPic;
    help = true;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Move the screen up when key board shows up

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -180; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    sexHelp = true;
    //background color
    color_691928 = [self colorWithHexString:@"691928"];
    color_bf9fa5 = [self colorWithHexString:@"bf9fa5"];
    color_f7e9b7 = [self colorWithHexString:@"f7e9b7"];
    self.view.backgroundColor = color_f7e9b7;
    
    //navgationbar color
    navigationView.backgroundColor = color_691928;
    profilePicButton.tintColor = color_691928;
    
    //textfield background color
    firstnameTextField.backgroundColor = color_691928;
    firstnameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Firstname" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    
    lastnameTextField.backgroundColor = color_691928;
    lastnameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Lastname" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    
    phoneTextField.backgroundColor = color_691928;
    phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color_bf9fa5}];
    
    //Profile pic button attributes
    propicView.layer.masksToBounds = YES;
    propicView.layer.cornerRadius = 27.0f;
    propicView.layer.borderWidth = 0.2;
    
    //dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    //Image picker for selcting images from gallery/camera
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //To set todays date
    //To set date limit
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    dobLabel.text = dateString;
    dobString = dateString;
    
    //Date picker initialization
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-30, 0, 60, 250)];
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(dateSelection:) forControlEvents:UIControlEventValueChanged];
    
    help = false;
    //Get an array of all the countries
    
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:[countryCodes count]];
    
    for (NSString *countryCode in countryCodes)
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    codeForCountryDictionary = [[NSDictionary alloc] initWithObjects:countryCodes forKeys:countries];
    //NSLog(codeForCountryDictionary[@"Aland Islands"]);
    
    //Sort the array
    countryArray = [countries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //Get the language and country code of the user
    language = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    //Get telephone code and country code
    dictDialingCodes = [[NSDictionary alloc]initWithObjectsAndKeys:
                        
                        @"972", @"IL",
                        @"93", @"AF",
                        @"355", @"AL",
                        @"213", @"DZ",
                        @"1", @"AS",
                        @"376", @"AD",
                        @"244", @"AO",
                        @"1", @"AI",
                        @"1", @"AG",
                        @"54", @"AR",
                        @"374", @"AM",
                        @"297", @"AW",
                        @"61", @"AU",
                        @"43", @"AT",
                        @"994", @"AZ",
                        @"1", @"BS",
                        @"973", @"BH",
                        @"880", @"BD",
                        @"1", @"BB",
                        @"375", @"BY",
                        @"32", @"BE",
                        @"501", @"BZ",
                        @"229", @"BJ",
                        @"1", @"BM", @"975", @"BT",
                        @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
                        @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
                        @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
                        @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
                        @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
                        @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
                        @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
                        @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
                        @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
                        @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
                        @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
                        @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
                        @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
                        @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
                        @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
                        @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
                        @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
                        @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
                        @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
                        @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
                        @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
                        @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
                        @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
                        @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
                        @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
                        @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
                        @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
                        @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
                        @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
                        @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
                        @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
                        @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
                        @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
                        @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
                        @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
                        @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
                        @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
                        @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
                        @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
                        @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
                        @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
                        @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
                        @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
                        @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
                        @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
                        @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
                        @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
                        @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
                        @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
                        @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
                        @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
                        @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963",
                        @"SY",@"886",
                        @"TW", @"255",
                        @"TZ", @"670",
                        @"TL",@"58",
                        @"VE",@"84",
                        @"VN",
                        @"284", @"VG",
                        @"340", @"VI",
                        @"678",@"VU",
                        @"681",@"WF",
                        @"685",@"WS",
                        @"967",@"YE",
                        @"262",@"YT",
                        @"27",@"ZA",
                        @"260",@"ZM",
                        @"263",@"ZW",
                        nil];
    //Assign Label according to country
    phoneCodeLabel.text = [@"+" stringByAppendingString:dictDialingCodes[countryCode]];
    
    //Select default index for picker view
    [picker1 selectRow:10 inComponent:0 animated:YES];
    
    //Initialize action sheet when image is pressed
    popup = [[UIActionSheet alloc] initWithTitle:@"Select profilepic options:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
             @"Take a picture",
             @"Choose from gallery",
             @"Remove",
             nil];
    popup.tag = 1;
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Do any additional setup after loading the view.
}

//change satus bar color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
