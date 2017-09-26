//
//  FFSignUPViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFSignUPViewController.h"
#import "FFSignUpEmailViewController.h"
#import "Macro.h"

@interface FFSignUPViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) FFUserInfo *userInfoObj;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation FFSignUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialLoadingViewDidLoad]; //helper
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -*************** Helper Methods *****************-
- (void)setUpInitialLoadingViewDidLoad {
    _usernametextFld.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernametextFld.delegate = self;
    self.userInfoObj = [[FFUserInfo alloc]init];
}

-(BOOL)validateSignUpUsername {
    
    if (_userInfoObj.userNameString.length == 0) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter username." onController:self];
        return NO;
    }
    if (self.usernametextFld.text.length > 60) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid username, username length should not be greater than 60 characters long." onController:self];
        return NO;
    }
    else if (![_userInfoObj.userNameString isValidName]) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please valid username." onController:self];
        return NO;
    }
    
    return YES;
}

#pragma mark -***************** TextField Delegate Methods ****************-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.userInfoObj.userNameString = TRIM_SPACE(strComplete);
    return ((textField.text.length >= 60 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
}
#pragma mark-IBAction Methods--
-(IBAction)continueBtnClicked:(id)sender {
    if([self validateSignUpUsername]) {
        
        [self makeWebApiToCheckUserName];
    }
}

-(IBAction)callBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Service Helper Method

- (void)makeWebApiToCheckUserName {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiCheckUser forKey:KAction];
    [dictRequest setValue:_userInfoObj.userNameString forKey:KUserName];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            if (strResponseCode.integerValue == 200) {

                FFSignUpEmailViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"emailIdentifier"];
                objVc.userInfoObj = self.userInfoObj;
                [self.navigationController pushViewController:objVc animated:YES];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:@"Username already exist." onController:self];
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
