//
//  FFPersonalInfoViewController.m
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFPersonalInfoViewController.h"
#import "FFPersonalInfoTableCell.h"
#import "FFSecondPersonalInfoTableCell.h"

static NSString *cellIdentifer = @"FFPersonalInfoTableCell";
static NSString *cellSecondIdentifer = @"FFSecondPersonalInfoTableCell";

@interface FFPersonalInfoViewController ()<UITextViewDelegate>{

    FFUserInfo *personalInfo;
    NSMutableArray *dataSourceArray;

}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property(weak,nonatomic) IBOutlet UITableView   *personalInfoTableView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak,nonatomic) IBOutlet UIButton   *saveBtn;
@end

@implementation FFPersonalInfoViewController

#pragma mark- Life Cycle of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    [_saveBtn setHidden:(_isFromUserName)? NO : YES];
    [self initialMethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)initialMethod{
    
    if (_isFromUserName)
        self.titleLabel.text = @"CHANGE USERNAME";
    else
        self.titleLabel.text = @"PERSONAL INFO";
    
    _personalInfoTableView.estimatedRowHeight = 65;
    _personalInfoTableView.rowHeight = UITableViewAutomaticDimension;
    personalInfo = [[FFUserInfo alloc] init];
    
    [self apiToFetchUserprofileData];

}

#pragma mark- Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UITable Delegate and DataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 0 ? 4 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0) {
        
        if (indexPath.row == 2) {
            FFSecondPersonalInfoTableCell *personalSecondCell = [_personalInfoTableView dequeueReusableCellWithIdentifier:cellSecondIdentifer];
            personalSecondCell.bioTextView.userInteractionEnabled = NO;
            personalSecondCell.bioTextView.keyboardType = UIKeyboardTypeAlphabet;
            personalSecondCell.bioTextView.delegate = self;
            [personalSecondCell.bioLabel setText:[@[@"Change Display Name",@"Change username",@"Bio",@"Website"] objectAtIndex:indexPath.row]];
            personalSecondCell.bioTextView.text = personalInfo.bioString;
            return personalSecondCell;
            }
        else{
            FFPersonalInfoTableCell *personalCell = [_personalInfoTableView dequeueReusableCellWithIdentifier:cellIdentifer];
            personalCell.personalInfoTextFeilds.keyboardType = UIKeyboardTypeAlphabet;
             personalCell.personalInfoTextFeilds.userInteractionEnabled = NO;
            [personalCell.personalInfoLabel setText:[@[@"Display Name",@"User Name",@"Bio",@"Website"] objectAtIndex:indexPath.row]];
            personalCell.personalInfoTextFeilds.tag = 500 + indexPath.row;
            switch (indexPath.row) {
                case 0:
                    personalCell.personalInfoTextFeilds.text = personalInfo.displayNameString;
                    break;
                case 1:
                {
                    if (self.isFromUserName && [personalInfo.isVerify isEqualToString:@"0"])
                        personalCell.personalInfoTextFeilds.userInteractionEnabled = YES;
                        personalCell.personalInfoTextFeilds.text = personalInfo.displayNameString;
                }
                    break;
                case 3:
                    personalCell.personalInfoTextFeilds.text = personalInfo.websiteString;
                    break;
                default:
                    break;
            }
            return personalCell;
            }
        }
    else{
        FFPersonalInfoTableCell *personalCell = [_personalInfoTableView dequeueReusableCellWithIdentifier:cellIdentifer];
        [personalCell.personalInfoLabel setText:[@[@"Email:",@"Phone number",@"Gender"] objectAtIndex:indexPath.row]];
        personalCell.personalInfoTextFeilds.userInteractionEnabled = NO;
        personalCell.personalInfoTextFeilds.keyboardType = UIKeyboardTypeAlphabet;
        personalCell.personalInfoTextFeilds.tag = 600 + indexPath.row;
        switch (indexPath.row) {
            case 0:
                personalCell.personalInfoTextFeilds.text = personalInfo.emailString;
                break;
            case 1:
            {
                personalCell.personalInfoTextFeilds.keyboardType = UIKeyboardTypePhonePad;
                 if (self.isFromUserName && [personalInfo.isVerify isEqualToString:@"0"])
                     personalCell.personalInfoTextFeilds.userInteractionEnabled = YES;

                personalCell.personalInfoTextFeilds.text = personalInfo.phoneNumberString;
            }
                break;
            case 2:
                personalCell.personalInfoTextFeilds.text = personalInfo.genderString;
                if (self.isFromUserName && [personalInfo.isVerify isEqualToString:@"0"])
                    personalCell.personalInfoTextFeilds.userInteractionEnabled = YES;

                break;
            default:
                break;
        }
        return personalCell;
    
    }
}

#pragma mark -******************* UITableViewDelegate methods ****************-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
        return indexPath.row == 2 ? 100 : 70;
    else
        return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectioView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, MainScreenWidth-30, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, sectioView.frame.size.width-30, 20)];
    titleLabel.font = [UIFont fontWithName:@"AvantGarde-Book" size:14];
    titleLabel.text = @"Priavte Infomation:";
    [sectioView addSubview:titleLabel];
    return sectioView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 20.0 : 0.0;
}

#pragma mark -***************** TextField Delegate Methods ****************-

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 601 && str.length > 20) {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view layoutIfNeeded];
    
    switch (textField.tag) {
        case 500:
            personalInfo.displayNameString = textField.text;
            break;
        case 501:
            personalInfo.changeUserNameString = textField.text;
            break;
        case 503:
            personalInfo.websiteString = textField.text;
            break;
        case 600:
            personalInfo.emailString = textField.text;
            break;
        case 601:
            personalInfo.phoneNumberString = textField.text;
            break;
        case 602:
            personalInfo.genderString = textField.text;
            break;
        default:
            break;
    }
}
#pragma mark -***************** TextView Delegate Methods ****************-
- (void)textViewDidEndEditing:(UITextView *)textView{

    personalInfo.bioString = textView.text;
}
#pragma mark- UIButton Action Method
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)saveButtonAction:(id)sender
{
    [self.view endEditing:YES];
    if (![personalInfo.changeUserNameString length]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter user name." onController:self];
    }
    else if (![personalInfo.phoneNumberString length]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter phone number." onController:self];
    }
    else if (![personalInfo.genderString length]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter your gender." onController:self];
    }
    else{
    
        [self apiToUpdateUserName];
    }
}


//Validate Method
-(BOOL)validateFields{

    BOOL isValidate = NO;
    if (![personalInfo.displayNameString length]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter display name." onController:self];
    }
   else if (![personalInfo.changeUserNameString length]) {
        [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter user name." onController:self];
    }
   else if (![personalInfo.bioString length]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter bio." onController:self];
   }
   else if (![personalInfo.websiteString length]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter website." onController:self];
   }
   else if (![personalInfo.emailString length]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter email." onController:self];
   }
   else if (![personalInfo.emailString isValidEmail]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid email." onController:self];
   }
   else if ([personalInfo.phoneNumberString length] < 10) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter at least 10 digits phone number." onController:self];
   }
   else if (![personalInfo.phoneNumberString isVAlidPhoneNumber]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid phone number." onController:self];
   }
   else if (![personalInfo.genderString length]) {
       [[AlertView sharedManager] displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter gender." onController:self];
   }
   else{
       isValidate = YES;
   }
    return isValidate;
}


#pragma mark API TO FETCH USER PROFILE DATA-
//***** CP

-(void)apiToFetchUserprofileData
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiUserProfile forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                NSDictionary *userDetail = [response objectForKeyNotNull:@"userDetail" expectedObj:[NSDictionary dictionary]];
                
                personalInfo.displayNameString = [userDetail valueForKey:@"userName"];
                personalInfo.changeUserNameString = [userDetail valueForKey:@"userName"];
                personalInfo.websiteString = [userDetail valueForKey:@"url"];
                personalInfo.emailString = [userDetail valueForKey:@"email"];
                personalInfo.phoneNumberString = [userDetail valueForKey:@"phoneNumber"];
                personalInfo.genderString = [userDetail valueForKey:@"gender"];
                personalInfo.bioString = [userDetail valueForKey:@"bio"];
                personalInfo.isVerify = [userDetail valueForKey:@"isVerify"];


                [self.personalInfoTableView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


-(void)apiToUpdateUserName
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiUpdateUserName forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:personalInfo.changeUserNameString forKey:KUserName];
    [dictRequest setValue:personalInfo.phoneNumberString forKey:KPhoneNumber];
    [dictRequest setValue:personalInfo.genderString forKey:KGender];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Success!" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    [self.navigationController popViewControllerAnimated:YES];

                }];
                
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
