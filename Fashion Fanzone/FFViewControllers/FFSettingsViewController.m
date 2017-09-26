//
//  FFSettingsViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 27/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFSettingsViewController.h"
#import "FFPersonalInfoViewController.h"
#import "FFSettingTableCell.h"
#import "AppDelegate.h"
#import "FFOfferViewController.h"
#import "Macro.h"

static NSString *settingCellIdentifer = @"FFSettingTableCell";
@interface FFSettingsViewController ()
{
    UIImageView * headerImage;
    UIButton * button;
    NSMutableArray *dataSourceArray;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property(weak, nonatomic) IBOutlet UITableView *settingTableView;
@property(weak, nonatomic) IBOutlet UIView *offerPointView;
@end

@implementation FFSettingsViewController



#pragma mark- Life Cycle of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    _offerPointView.hidden = YES;
    [self initialMethod];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _offerPointView.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [headerImage removeFromSuperview];
    [button removeFromSuperview];
}

- (void)initialMethod{
    
    _settingTableView.estimatedRowHeight = 40;
    _settingTableView.rowHeight = UITableViewAutomaticDimension;
    dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"Your Offers",@"GUIDE ME - FF most intresting features.",@"Push Notification",@"Edit Profile",@"Manage Flow's",@"Interaction History",@"Invite Friends",@"Private Account",@"Location Settings",@"Save original images to phone?",@"Mobile Data Settings",@"Change Username",@"Edit Password, two factor authentication",@"Report Problem",@"Block Users",@"Personal Info",@"Request Verfication",@"Fashion Fanzone Information",@"Terms and Conditions",@"Privacy Policy",@"LOG OUT", nil];
}

#pragma mark- Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- UITable Delegate and DataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFSettingTableCell *settingCell = [_settingTableView dequeueReusableCellWithIdentifier:settingCellIdentifer];
    
    [settingCell.settingLabel setText:[dataSourceArray objectAtIndex:indexPath.row]];
    [settingCell.settingSwitch setHidden:YES];
    [settingCell.verifyButton setHidden:YES];
    [settingCell.settingSwitch setTag:(indexPath.row+100)];
    
    [settingCell.settingSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [settingCell.settingSwitch setOn:NO];
    [settingCell.verifyButton addTarget:self action:@selector(verifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[NSUSERDEFAULT valueForKey:KIsVerify] isEqualToString:@"1"])
        [settingCell.verifyButton setTitle:@"Verified" forState:UIControlStateNormal];
    else
        [settingCell.verifyButton setTitle:@"Verify" forState:UIControlStateNormal];
    
    
    switch (indexPath.row) {
        case 0: case 1: case 3: case 4: case 5: case 6: case 7: case 13:case 14: case 15: case 17: case 18: case 19: case 20:{
            [settingCell.settingSwitch setHidden:YES];
        }
            break;
        case 2:
        {
            [settingCell.settingSwitch setOn:[NSUSERDEFAULT boolForKey:@"pushNotification"]];
            [settingCell.settingSwitch setHidden:NO];
        }
            break;
        case 8:
        {
            [settingCell.settingSwitch setOn:[NSUSERDEFAULT boolForKey:@"locationSetting"]];
            [settingCell.settingSwitch setHidden:NO];
        }
            break;
        case 9:
        {
            [settingCell.settingSwitch setOn:[NSUSERDEFAULT boolForKey:@"imageTophoto"]];
            [settingCell.settingSwitch setHidden:NO];
        }
            break;
        case 10:
        {
            [settingCell.settingSwitch setOn:[NSUSERDEFAULT boolForKey:@"mobileData"]];
            [settingCell.settingSwitch setHidden:NO];
        }
            break;
        case 12:
        {
            [settingCell.settingSwitch setOn:[NSUSERDEFAULT boolForKey:@"editPassword"]];
            [settingCell.settingSwitch setHidden:NO];
        }
            break;
        case 16:{
            
            [settingCell.verifyButton setHidden:NO];
        }
            break;
        default:
            [settingCell.settingSwitch setHidden:YES];
            break;
            
    }
    return settingCell;
}

#pragma mark -******************* UITableViewDelegate methods ****************-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  _settingTableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0: {
            //Offer Me Pop-Up
            FFOfferViewController * detail = (FFOfferViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFOfferViewControllerId"];
            [self.navigationController pushViewController:detail animated:YES];
        }
//            [self performSelector:@selector(showPopOver) withObject:nil afterDelay:.5];
            break;
        case 1:{
            //Guide Me
            FFGuideMeViewController *guideVc = (FFGuideMeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFGuideMeViewController"];
            [self.navigationController pushViewController:guideVc animated:YES];
        }
            break;
        case 3:{
            //Edit Profile
            FFEditProfileViewController *editProfileVc = (FFEditProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFEditProfileViewController"];
            [self.navigationController pushViewController:editProfileVc animated:YES];
        }
            break;
        case 4:{
            //Manage Flow
            FFCreateFlowViewController *createFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCreateFlowViewController"];
            [self.navigationController pushViewController:createFlowVC animated:YES];
        }
            break;
        case 5:{
            //Interaction History Flow
            FFInteractionHistoryViewController *connectionFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFInteractionHistoryViewControllerID"];
            [self.navigationController pushViewController:connectionFlowVC animated:YES];
            
        }
            break;
        case 6:{
            //Invite Friends
            FFInviteFriendsViewController *connectionFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFInviteFriendsViewController"];
            [self.navigationController pushViewController:connectionFlowVC animated:YES];
            
        }
            break;
        case 7:{
            //Private Account Flow
            FFPrivateAccountViewController *connectionFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFPrivateAccountViewController"];
            [self.navigationController pushViewController:connectionFlowVC animated:YES];
            
        }
            break;
        case 11:{
            //Change User Name
            FFPersonalInfoViewController *editProfileVc = (FFPersonalInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPersonalInfoViewController"];
            editProfileVc.isFromUserName = YES;
            [self.navigationController pushViewController:editProfileVc animated:YES];
            
        }
            break;
            
        case 13: {
            
            // ReportVC
            FFReportViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFReportViewControllerID"];
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
        case 14: {
            
            // User UnBlockVC
            FFBlockUserViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFBlockUserViewControllerID"];
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
        case 15: {
            
            // Personal info
            FFPersonalInfoViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFPersonalInfoViewController"];
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
        case 17: {
            
            // Terms And ConditionVC
            FFTermsPolicyViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFTermsPolicyViewControllerID"];
            objVc.titleText = @"FASHION FANZONE INFORMATION";
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
        case 18: {
            
            // Terms And ConditionVC
            FFTermsPolicyViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFTermsPolicyViewControllerID"];
            objVc.titleText = @"TERMS AND CONDITIONS";
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
        case 19: {
            
            // Privacy PolicyVC
            FFTermsPolicyViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFTermsPolicyViewControllerID"];
            objVc.titleText = @"PRIVACY POLICY";
            [self.navigationController pushViewController:objVc animated:YES];
        }
            break;
            
        case 20: {
            
            // Logout Alert
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AlertView sharedManager] presentAlertWithTitle:@"Are you sure!" message:@"You want to logout from FASHION FANZONE?" andButtonsWithTitle:@[@"Yes",@"No"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    if (index == 0) {
                        [self makeWebApiCallForLogOut];
                    }
                }];
            });
        }
            break;
        default:
            break;
    }
}

//Helper Method
- (void)switchChanged:(UISwitch *)sender {
    
    switch (sender.tag%100) {
        case 2:
        {
            
            [self apiForToggleOnOff:[sender isOn]?@"1":@"0" type:KNotificationStatus];
            
        }
            break;
        case 8:
        {
            [self apiForToggleOnOff:[sender isOn]?@"1":@"0" type:KDLocationStatus];
            
        }
            break;
        case 9:
        {
            [self apiForToggleOnOff:[sender isOn]?@"1":@"0" type:KImageStatus];
            
        }
            break;
        case 10:
        {
            [self apiForToggleOnOff:[sender isOn]?@"1":@"0" type:KMobileDataStatus];
            
        }
            break;
        case 12:
        {
            [self apiForToggleOnOff:[sender isOn]?@"1":@"0" type:KEditPassword];
            
        }
            break;
        default:
            break;
    }
}

- (void)verifyButtonAction:(UIButton *)sender {
    // Do something
    
  
        [[AlertView sharedManager] presentAlertWithTitle:@"Are you sure!" message:[[NSUSERDEFAULT valueForKey:KIsVerify] isEqualToString:@"1"]?@"You want to get unverified?":@"You want to get verified?" andButtonsWithTitle:[NSArray arrayWithObjects:@"YES",@"NO",nil] onController:self dismissedWith:^(NSInteger index, NSString * titlestring){
            
            if (index == 0) {
                
                [self apiToVerifyUser:[[NSUSERDEFAULT valueForKey:KIsVerify] isEqualToString:@"1"]?@"0":@"1"];
                
            }
        }];
    
}

-(void)showPopOver{
    _offerPointView.hidden = NO;
}

#pragma mark- UIButton Action Method
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkOutYourAction:(id)sender {
    self.offerPointView.hidden = YES;
}

- (IBAction)hidePopUpAction:(id)sender {
    self.offerPointView.hidden = YES;
}


#pragma mark - Helper Method

- (void)makeWebApiCallForLogOut {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiLogout forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [NSUSERDEFAULT setValue:@"" forKey:KUserId];
                [NSUSERDEFAULT synchronize];
                
                AppDelegate * appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appdel initiatelogoutView];
                
                
                //   [self.navigationController popToRootViewControllerAnimated:NO];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


-(void)apiToVerifyUser:(NSString *)status
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiVerifyUser forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:status forKey:KVerifyStatus];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
              //  [[AlertView sharedManager]displayInformativeAlertwithTitle:KSuccess andMessage:strResponseMessage onController:self];
                [NSUSERDEFAULT setValue:[response valueForKey:KIsVerify] forKey:KIsVerify];

               // isVerify = YES;
                [self.settingTableView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


-(void)apiForToggleOnOff:(NSString *)status type:(NSString *)type
{
   // [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiSetting forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:status forKey:KConnectedStatus];
    [dictRequest setValue:type forKey:KType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
      //  [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if ([[response objectForKeyNotNull:KEditPassword expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"editPassword"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"editPassword"];
                }
                if ([[response objectForKeyNotNull:KImageStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"imageTophoto"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"imageTophoto"];
                }
                if ([[response objectForKeyNotNull:KDLocationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"locationSetting"];
                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    [NSUSERDEFAULT setValue:[appDelegate currentLatitude] forKey:KDefaultlatitude];
                    [NSUSERDEFAULT setValue:[appDelegate currentLongitude] forKey:KDefaultlongitude];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"locationSetting"];
                    [NSUSERDEFAULT setValue:@"0" forKey:KDefaultlatitude];
                    [NSUSERDEFAULT setValue:@"0" forKey:KDefaultlongitude];
                }
                if ([[response objectForKeyNotNull:KMobileDataStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"mobileData"];
                    
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"mobileData"];
                }
                if ([[response objectForKeyNotNull:KNotificationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"pushNotification"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"pushNotification"];
                    
                }
                [NSUSERDEFAULT synchronize];
                [self.settingTableView reloadData];
                
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
