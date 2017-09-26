//
//  FFChoosePasswordViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFChoosePasswordViewController.h"
#import "FFAcocuntTypeViewController.h"
#import "Macro.h"

@interface FFChoosePasswordViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) NSString *strRepeatPwd;

@end

@implementation FFChoosePasswordViewController

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

/**
 Load the default setup for the View
 */
- (void)setUpInitialLoadingViewDidLoad {
    _choosePasswrdFld.autocorrectionType = UITextAutocorrectionTypeNo;
    _repeatPasswrdFld.autocorrectionType = UITextAutocorrectionTypeNo;
    _choosePasswrdFld.delegate = self;
    _repeatPasswrdFld.delegate = self;

}


/**
 Validate Input Field
 
 @return Validation status
 */
-(BOOL)validateSignUpChoosePassword {
    
    BOOL isInputValid = NO;
    if (self.userInfoObj.passwordString.length == 0) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter password." onController:self];
        isInputValid = NO;
    }
    else if (self.userInfoObj.passwordString.length < 6) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid password." onController:self];
        isInputValid = NO;
    }
    else if (self.userInfoObj.passwordString.length > 20)
    {
        [[AlertView sharedManager] presentAlertWithTitle:@"Error!" message:@"Invalid password, password length should not be greater than 20 characters long." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             
         }];

    }
    else  if (self.strRepeatPwd.length == 0) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter repeat password." onController:self];
        isInputValid = NO;
    }
    else if (self.strRepeatPwd.length < 6) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid repeat password." onController:self];
        isInputValid = NO;
    }
    else if (![self.userInfoObj.passwordString isEqualToString:self.strRepeatPwd]) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Password and repeat password do not match." onController:self];
        isInputValid = NO;

    }
    else
        isInputValid = YES;
    
    return isInputValid;
}

#pragma mark -***************** TextField Delegate Methods ****************-
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    switch (textField.tag) {
        case 100: {
            self.userInfoObj.passwordString = TRIM_SPACE(strComplete);
            return ((textField.text.length >= 20 && range.length == 0) ||  [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;
        }
            break;
        case 101: {
            self.strRepeatPwd = TRIM_SPACE(strComplete);
            return ((textField.text.length >= 20 && range.length == 0) ||  [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;
        }
            break;
               default:
            break;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
        case 100: {
            self.userInfoObj.passwordString = textField.text;
           
        }
            break;
        case 101: {
            self.strRepeatPwd = textField.text;
           
        }
            break;
        default:
            break;
    }
   
}
#pragma mark IBACtion Methoods-
-(IBAction)continueBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    if([self validateSignUpChoosePassword]) {
        FFAcocuntTypeViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"businessAccountIdentifier"];
        objVc.userInfoObj = self.userInfoObj;
        [self.navigationController pushViewController:objVc animated:YES];
}
}

-(IBAction)callBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
