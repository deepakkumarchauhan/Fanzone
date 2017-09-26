//
//  FFSignUpEmailViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFSignUpEmailViewController.h"
#import "FFChoosePasswordViewController.h"
#import "Macro.h"

@interface FFSignUpEmailViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation FFSignUpEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setUpInitialLoadingViewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -*************** Helper Methods *****************-
- (void)setUpInitialLoadingViewDidLoad {
    self.emailTxtFld.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailTxtFld.delegate = self;
}

-(BOOL)validateSignUpEmailAddress {
    
    if (_userInfoObj.emailAddressString.length == 0) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter email address." onController:self];
        return NO;
    }
    else if (![_userInfoObj.emailAddressString isValidEmail]) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid email address." onController:self];
        return NO;
    }
    
    return YES;
}

#pragma mark -***************** TextField Delegate Methods ****************-
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.userInfoObj.emailAddressString = TRIM_SPACE(strComplete);
    return ((textField.text.length >= 60 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
    
    return YES;
}

#pragma Mark IBAction Methods--

-(IBAction)continueBtnClicked:(id)sender
{
    if([self validateSignUpEmailAddress]) {
        
        [self makeWebApiToCheckEmail];
    }
}
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Service Helper Method

- (void)makeWebApiToCheckEmail {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiCheckUser forKey:KAction];
    [dictRequest setValue:_userInfoObj.emailAddressString forKey:KUserName];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
           if (strResponseCode.integerValue == 200) {

                FFChoosePasswordViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"passwordIdentifier"];
                objVc.userInfoObj = self.userInfoObj;
                [self.navigationController pushViewController:objVc animated:YES];

            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:@"Email address already exist." onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}



#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    self.view.userInteractionEnabled = NO;
    [self.continueButton setTitle:@"" forState:UIControlStateNormal];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    self.view.userInteractionEnabled = YES;
    [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



@end
