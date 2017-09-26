//
//  ViewController.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/10/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "Macro.h"
#import "NSDictionary+NullChecker.h"

@interface ViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) FFUserInfo *userInfoObj;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpInitialLoadingOfController];  //helper
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -******************* Helper Methods ******************-
- (void)setUpInitialLoadingOfController {
    _passwordFld.delegate = self;
    _userNameFld.delegate = self;
    self.userInfoObj = [[FFUserInfo alloc]init];
}

#pragma mark- IBAction Methods--
//
-(IBAction)performForgetPassword:(id)sender {
    [self performSegueWithIdentifier:@"forgot" sender:self];
}

-(IBAction)performSignUpPassword:(id)sender {
    [self performSegueWithIdentifier:@"signup" sender:self];
}

-(IBAction)performLogin:(id)sender {
    if ([self validateLogin]) {
        //[self performSegueWithIdentifier:@"menuFashion" sender:self];

        [self makeWebApiCallForLogIn];
    }
}

-(BOOL)validateLogin {
    
    BOOL checkForEmail = [_userInfoObj.userNameString rangeOfString:@"@" options:NSCaseInsensitiveSearch].location == NSNotFound;
    
    if (_userInfoObj.userNameString.length == 0) {
        
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter user name." onController:self];
        return NO;
    }else if (checkForEmail){
        if (![_userInfoObj.userNameString isValidName]) {
            [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid user name." onController:self];
            return NO;
        }
    }
    else if (!checkForEmail){
        if (![_userInfoObj.userNameString isValidEmail]) {
            [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid email address." onController:self];
            return NO;
        }
    }
    else if (_userInfoObj.passwordString.length == 0 ) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter password." onController:self];
        return NO;
    }
    else if (_passwordFld.text.length < 7) {
        
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid password, password length should be atleast of 8 characters long." onController:self];
        return NO;
    }
    else if (_passwordFld.text.length > 20) {
        
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid password, password length should not be greater than 20 characters long." onController:self];
        return NO;
    }
    return YES;
}

#pragma mark -******************* TextField Delegate Methods *******************-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(textField.tag == 98) {
        self.userInfoObj.userNameString = TRIM_SPACE(strComplete);
        return ((textField.text.length >= 50 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
        
    }
    else if(textField.tag == 99) {
        self.userInfoObj.passwordString = TRIM_SPACE(strComplete);
        return ((textField.text.length > 20 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 99) {
        
        if (textField.text.length > 20) {
            [[AlertView sharedManager] presentAlertWithTitle:@"Error!" message:@"Invalid password, password length should not be greater than 20 characters long." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
             {
                 textField.text = @"";
             }];
        }
    }
}


#pragma mark - Helper Method

- (void)makeWebApiCallForLogIn {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiLogIn forKey:KAction];
    [dictRequest setValue:_userInfoObj.userNameString forKey:KUserName];
    [dictRequest setValue:_userInfoObj.passwordString forKey:KPassword];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDeviceToken] forKey:KDeviceToken];
    [dictRequest setValue:@"ios" forKey:KDeviceType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                NSDictionary *userInfo = [response objectForKeyNotNull:@"userInfo" expectedObj:[NSDictionary dictionary]];
                
                if ([[userInfo objectForKeyNotNull:KEditPassword expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"editPassword"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"editPassword"];
                }
                if ([[userInfo objectForKeyNotNull:KImageStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"imageTophoto"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"imageTophoto"];
                }
                if ([[userInfo objectForKeyNotNull:KDLocationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"locationSetting"];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"locationSetting"];
                }
                if ([[userInfo objectForKeyNotNull:KMobileDataStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"mobileData"];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"mobileData"];
                }
                if ([[userInfo objectForKeyNotNull:KNotificationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"pushNotification"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"pushNotification"];
                    
                }
                [NSUSERDEFAULT setValue:[userInfo valueForKey:KUserId] forKey:KUserId];
                [NSUSERDEFAULT setValue:[userInfo valueForKey:KUserType] forKey:KUserType];
                [NSUSERDEFAULT setValue:[userInfo valueForKey:KUserImage] forKey:KUserImage];
                [NSUSERDEFAULT setValue:[NSString stringWithFormat:@"%@",[userInfo valueForKey:KIsVerify]] forKey:KIsVerify];
                [NSUSERDEFAULT synchronize];

                [self performSegueWithIdentifier:@"menuFashion" sender:self];
                
            }else if (strResponseCode.integerValue == 404) {
                
                NSDictionary *userInfo = [response objectForKeyNotNull:@"userInfo" expectedObj:[NSDictionary dictionary]];
                
                FFOTPViewController * detail = (FFOTPViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFOTPViewControllerId"];
                detail.userInfo = userInfo;
                [self.navigationController pushViewController:detail animated:YES];

                //[self openTextFieldForOTP];
            }
            
            else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.loginButton.enabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    [self.loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.loginButton.enabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



@end
