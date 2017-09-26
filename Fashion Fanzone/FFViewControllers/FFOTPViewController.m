//
//  FFOTPViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 29/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFOTPViewController.h"
#import "FFTextField.h"
#import "Macro.h"

@interface FFOTPViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet FFTextField *otpTextField;

@end

@implementation FFOTPViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonAction:(id)sender {
    
    if (!TRIM_SPACE(self.otpTextField.text).length) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter OTP." onController:self];
    }else {
        [self makeWebApiCallOTP];
    }
}

- (IBAction)resendOtpButton:(id)sender {
    
    [self makeWebApiResendOtp];
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length>=5) {
        return NO;
    }
    return YES;
}



#pragma mark - Service Helper Nethod

- (void)makeWebApiCallOTP {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiVerifyOTP forKey:KAction];
    [dictRequest setValue:TRIM_SPACE(self.otpTextField.text) forKey:KOtp];
    [dictRequest setValue:[self.userInfo objectForKeyNotNull:@"email" expectedObj:@""] forKey:KEmail];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if ([[self.userInfo objectForKeyNotNull:KEditPassword expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"editPassword"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"editPassword"];
                }
                if ([[self.userInfo objectForKeyNotNull:KImageStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"imageTophoto"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"imageTophoto"];
                }
                if ([[self.userInfo objectForKeyNotNull:KDLocationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"locationSetting"];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"locationSetting"];
                }
                if ([[self.userInfo objectForKeyNotNull:KMobileDataStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"mobileData"];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"mobileData"];
                }
                if ([[self.userInfo objectForKeyNotNull:KNotificationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"pushNotification"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"pushNotification"];
                    
                }
                [NSUSERDEFAULT setValue:[self.userInfo valueForKey:KUserId] forKey:KUserId];
                [NSUSERDEFAULT setValue:[self.userInfo valueForKey:KUserType] forKey:KUserType];
                [NSUSERDEFAULT setValue:[self.userInfo valueForKey:KUserImage] forKey:KUserImage];
                [NSUSERDEFAULT setValue:[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:KIsVerify]] forKey:KIsVerify];
                [NSUSERDEFAULT synchronize];

                [self performSegueWithIdentifier:@"otpSegue" sender:self];
                
            }
            else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


- (void)makeWebApiResendOtp{
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiResendOTP forKey:KAction];
    [dictRequest setValue:[self.userInfo objectForKeyNotNull:@"email" expectedObj:@""] forKey:KEmail];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KSuccess andMessage:strResponseMessage onController:self];
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
    
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
