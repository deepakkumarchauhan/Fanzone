//
//  FFForgotPasswordViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFForgotPasswordViewController.h"
#import "FFUtility.h"

@interface FFForgotPasswordViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation FFForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userNameFld.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- IBAction Methods--

-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)performForgetPassword:(id)sender
{
    if ([[FFUtility sharedInstance] NSStringIsValidEmail:_userNameFld.text]) {
       
        [self makeWebApiCallForForgotPassword];
    }
    else
    {
        NSString * message = nil;
        if (_userNameFld.text.length==0) {
            message = @"Please enter a email address.";
        }
        else
        {
            message = @"Please enter a valid email address.";
        }
       [[AlertView sharedManager] presentAlertWithTitle:@"Error!" message:message andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index , NSString * title)
        {
            
        }];
    }
}

#pragma mark - Helper Method

- (void)makeWebApiCallForForgotPassword {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiForgot forKey:KAction];
    [dictRequest setValue:_userNameFld.text forKey:KEmail];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                            [self.navigationController popViewControllerAnimated:YES];
                    }];
                });

                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.submitButton.enabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    [self.submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.submitButton.enabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}




@end
