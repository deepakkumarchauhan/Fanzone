//
//  FFAcocuntTypeViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFAcocuntTypeViewController.h"
#import "FFUploadPhotoViewController.h"
#import "Macro.h"

@interface FFAcocuntTypeViewController ()<UITextFieldDelegate>


@end

@implementation FFAcocuntTypeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpInitialLoadingViewDidLoad];
}

#pragma mark- manageSegmentContrllerIndex
-(void)manageSegmentContrllerIndex  //if perosnal hide business flds else hide first name last name flds
{
    switch (_segmentController.selectedSegmentIndex) {
        case 0: {
            _businessNametxtFld.hidden = YES;
            _firstNameTxtFld.hidden = NO;
            _lastNameTxtFld.hidden = NO;
            self.userInfoObj.userType = @"Personal";

        }
            break;
        case 1: {
            _businessNametxtFld.hidden = NO;
            _firstNameTxtFld.hidden = YES;
            _lastNameTxtFld.hidden = YES;
            self.userInfoObj.userType = @"Business";

        }
            break;
        default:
            break;
    }
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
    
    _firstNameTxtFld.autocorrectionType =  UITextAutocorrectionTypeNo;
    _lastNameTxtFld.autocorrectionType =  UITextAutocorrectionTypeNo;
    _businessNametxtFld.autocorrectionType =  UITextAutocorrectionTypeNo;
    
    //Setting up textfield delegate
    self.firstNameTxtFld.delegate =  self;
    self.lastNameTxtFld.delegate =  self;
    self.businessNametxtFld.delegate =  self;
    _segmentController.selectedSegmentIndex = 0;  // by default set personal selected
    self.userInfoObj.userType = @"Personal";
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [self manageSegmentContrllerIndex];
    UIColor *blackColor = [UIColor blackColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[blackColor] forKeys:@[NSForegroundColorAttributeName]];
    [_segmentController setTitleTextAttributes:attributes
                                      forState:UIControlStateNormal];
    
    
    attributes = [NSDictionary dictionaryWithObjects:@[blackColor] forKeys:@[NSForegroundColorAttributeName]];
    [_segmentController setTitleTextAttributes:attributes
                                      forState:UIControlStateSelected];

}


/**
 Validate Input Field

 @return Validation status
 */
-(BOOL)validateSignUpAccountType {
    
    BOOL isInputValid = NO;
    switch (_segmentController.selectedSegmentIndex) {
        case 0: {
            if (_userInfoObj.firstNameString.length == 0) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter first name." onController:self];
                isInputValid = NO;
            }
           else if (_userInfoObj.firstNameString.length >=60) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid first name, first name length should not be greater than 60 characters long." onController:self];
                isInputValid = NO;
            }
            else if (![_userInfoObj.firstNameString isValidName]) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid first name." onController:self];
                isInputValid = NO;
            }
            
            else if (_userInfoObj.lastNameString.length == 0) {
               // [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter last name." onController:self];
               // isInputValid = NO;
                isInputValid = YES;
            }
            else if (_userInfoObj.lastNameString.length>=60) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid last name, last name length should not be greater than 60 characters long." onController:self];
                isInputValid = NO;
            }
            else if (![_userInfoObj.lastNameString isValidName]) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid last name." onController:self];
                isInputValid = NO;
            }
            else
                isInputValid = YES;

        }
            break;
        case 1: {
            if (self.businessNametxtFld.text.length == 0) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter business name." onController:self];
                isInputValid = NO;
            }
            else if (![self.businessNametxtFld.text isValidName]) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid business name." onController:self];
                isInputValid = NO;
            }
            else if (self.businessNametxtFld.text.length>=60) {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Invalid business name, business  length should not be greater than 60 characters long." onController:self];
                isInputValid = NO;
            }
            else
                isInputValid = YES;
        }
            break;
        default:
            break;
    }

    return isInputValid;
}

#pragma mark -***************** TextField Delegate Methods ****************-
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (_segmentController.selectedSegmentIndex) {
        case 0: {
            switch (textField.tag) {
                case 100: {
                    self.userInfoObj.firstNameString = TRIM_SPACE(strComplete);
                    return ((textField.text.length >= 60 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
                }
                    break;
                case 101: {
                    self.userInfoObj.lastNameString = TRIM_SPACE(strComplete);
                    return ((textField.text.length >= 60 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            self.userInfoObj.businessNameString = TRIM_SPACE(strComplete);
            return ((textField.text.length >= 60 && range.length == 0) || [string isEqualToString:@" "] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) ? NO : YES;  // to avoid space
        }
            break;
        default:
            break;
    }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * errorMessage = nil;
    if ([textField isEqual:_firstNameTxtFld]) {
        self.userInfoObj.firstNameString = textField.text;
       if (textField.text.length>60) {
           errorMessage = @"Invalid first name, first name length should not be greater than 60 characters long.";
       }
    }
    if ([textField isEqual:_lastNameTxtFld]) {
        self.userInfoObj.lastNameString = textField.text;
        if (textField.text.length>60) {
             errorMessage = @"Invalid last name, last name length should not be greater than 60 characters long.";
        }
    }
    if ([textField isEqual:_businessNametxtFld]) {
        self.userInfoObj.businessNameString = textField.text;
        if (textField.text.length>60) {
             errorMessage = @"Invalid business name, business length should not be greater than 60 characters long.";
        }
    }
    
    if (errorMessage) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Error!" message:errorMessage andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             textField.text = @"";
         }];
    }
   
    
}

#pragma mark IBACtion Methoods-
-(IBAction)continueBtnClicked:(id)sender {
    if([self validateSignUpAccountType]) {
        FFUploadPhotoViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"userPhotoIdentifier"];
        objVc.userInfoObj = self.userInfoObj;
        [self.navigationController pushViewController:objVc animated:YES];
    }
       // [self performSegueWithIdentifier:@"uploadPhoto" sender:self];
}

-(IBAction)segmentChanged:(UISegmentedControl *)controller {
    [self manageSegmentContrllerIndex];
}

-(IBAction)callBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
