//
//  FFPrivateAccountViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFPrivateAccountViewController.h"
#import "Macro.h"

static NSString *cellId = @"privateAccountCellId";

@interface FFPrivateAccountViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    NSMutableArray *privateArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFPrivateAccountViewController


#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}


#pragma mark - Custom Method
-(void)initialSetUp {
    
    // Alloc Array
    privateArray = [NSMutableArray array];
    
    NSArray *privateTempArray = [[NSArray alloc] initWithObjects:@"Who can see your Flash Flow",@"Who can see your Posts",@"Who can see your bio?",@"Who can send Direct Messages", nil];
    
    NSArray *subCatArray = [[NSMutableArray alloc] initWithObjects:@"All",@"None",@"Connections", nil];
    
    self.tableView.estimatedRowHeight = 30.0;
    for (int sectionIndex = 0; sectionIndex < privateTempArray.count; sectionIndex++) {
        
        FFUserInfo *userTempInfo = [[FFUserInfo alloc] init];
        userTempInfo.privateSubCategoryArray = [NSMutableArray array];
        userTempInfo.isSelect = NO;
        userTempInfo.titleText = [privateTempArray objectAtIndex:sectionIndex];

        for (int index = 0; index < subCatArray.count; index++){
            FFUserInfo *userSubCatTempInfo = [[FFUserInfo alloc] init];
            userSubCatTempInfo.isSelect = NO;
            userSubCatTempInfo.titleText = [subCatArray objectAtIndex:index];
            [userTempInfo.privateSubCategoryArray addObject:userSubCatTempInfo];
        }
        
        [privateArray addObject:userTempInfo];
    }
    
    [self makeWebApiCallToGetPrivateAccount];
    
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [privateArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FFUserInfo *userInfo = [privateArray objectAtIndex:section];
    
    if (userInfo.isSelect)
        return (section < 2)?[userInfo.privateSubCategoryArray count]:[userInfo.privateSubCategoryArray count]-1;
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFPrivateAccountTableViewCell *cell = (FFPrivateAccountTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    FFUserInfo *userInfo = [privateArray objectAtIndex:indexPath.section];
    FFUserInfo *userSubCatInfo = [userInfo.privateSubCategoryArray objectAtIndex:indexPath.row];

    // Set Email Text
    cell.accountTitleLabel.text = userSubCatInfo.titleText;

    if (userSubCatInfo.isSelect)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FFUserInfo *userInfo = [privateArray objectAtIndex:indexPath.section];
    FFUserInfo *userSubCatInfo = [userInfo.privateSubCategoryArray objectAtIndex:indexPath.row];
    
    for (FFUserInfo *tempSubcatInfo in userInfo.privateSubCategoryArray) {
        
        tempSubcatInfo.isSelect = NO;
    }    
    userSubCatInfo.isSelect = !userSubCatInfo.isSelect;
    
    [self.tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FFUserInfo *userInfo = [privateArray objectAtIndex:section];

    UIView *sectioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 35)];
    UIButton *sectioViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 35)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, MainScreenWidth-32, 35)];
    titleLabel.font = [UIFont fontWithName:@"AvantGarde-Book" size:13];
    sectioViewButton.tag = section+100;
    titleLabel.text = userInfo.titleText;
    [sectioViewButton addTarget:self action:@selector(sectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [sectioView addSubview:titleLabel];
    [sectioView addSubview:sectioViewButton];

    return sectioView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0;
}


#pragma mark - Selector Method
- (void)sectionButtonAction:(UIButton *)sender {
    
    FFUserInfo *userInfo = [privateArray objectAtIndex:sender.tag-100];
    
//    for (FFUserInfo *tempInfo in privateArray) 
//        tempInfo.isSelect = NO;
    
    userInfo.isSelect = !userInfo.isSelect;
    
    [self.tableView reloadData];

}


#pragma mark - UIButton Action 
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonAction:(id)sender {
    
    BOOL isSuccess = NO;
    for (int index = 0; index<=3; index++) {
        FFUserInfo *userInfo = [privateArray objectAtIndex:index];
        for (FFUserInfo *tempSubcatInfo in userInfo.privateSubCategoryArray) {
            if (tempSubcatInfo.isSelect) {
                isSuccess = YES;
                break;
            }
        }
    }
   
    if (isSuccess) {
        
        [self makeWebApiCallToUpdateprivateAccount];

//        [[AlertView sharedManager] presentAlertWithTitle:@"Success!" message:@"Account update successfully." andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
    }else
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please select any option." onController:self];

}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Service Helper Method

- (void)makeWebApiCallToUpdateprivateAccount {
    
    [self showLoader];
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *postArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *bioDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *messageDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *categoryDict = [[NSMutableDictionary alloc] init];
    
    
    FFUserInfo *userCategoInfo = [privateArray objectAtIndex:0];
    FFUserInfo *userPostInfo = [privateArray objectAtIndex:1];
    FFUserInfo *userBioInfo = [privateArray objectAtIndex:2];
    FFUserInfo *userMessageInfo = [privateArray objectAtIndex:3];
    
    
    for (FFUserInfo *userInfo in userCategoInfo.privateSubCategoryArray) {
        if (userInfo.isSelect) {
            
            if ([userInfo.titleText isEqualToString:@"All"]) {
                [categoryDict setValue:@"1" forKey:@"Every"];
                [categoryDict setValue:@"0" forKey:@"None"];
                [categoryDict setValue:@"0" forKey:@"Connection"];
            }else if ([userInfo.titleText isEqualToString:@"None"]) {
                
                [categoryDict setValue:@"0" forKey:@"Every"];
                [categoryDict setValue:@"1" forKey:@"None"];
                [categoryDict setValue:@"0" forKey:@"Connection"];
            }
            else if ([userInfo.titleText isEqualToString:@"Connections"]) {
                [categoryDict setValue:@"0" forKey:@"Every"];
                [categoryDict setValue:@"0" forKey:@"None"];
                [categoryDict setValue:@"1" forKey:@"Connection"];
            }
        }
    }
    
    
    for (FFUserInfo *userInfo in userPostInfo.privateSubCategoryArray) {
        if (userInfo.isSelect) {
            
            if ([userInfo.titleText isEqualToString:@"All"]) {
                [postDict setValue:@"1" forKey:@"Every"];
                [postDict setValue:@"0" forKey:@"None"];
                [postDict setValue:@"0" forKey:@"Connection"];
                
            }else if ([userInfo.titleText isEqualToString:@"None"]) {
                [postDict setValue:@"0" forKey:@"Every"];
                [postDict setValue:@"1" forKey:@"None"];
                [postDict setValue:@"0" forKey:@"Connection"];
            }
            else if ([userInfo.titleText isEqualToString:@"Connections"]) {
                [postDict setValue:@"0" forKey:@"Every"];
                [postDict setValue:@"0" forKey:@"None"];
                [postDict setValue:@"1" forKey:@"Connection"];
            }
        }
    }
    
    
    for (FFUserInfo *userInfo in userBioInfo.privateSubCategoryArray) {
        if (userInfo.isSelect) {
            
            if ([userInfo.titleText isEqualToString:@"All"]) {
                [bioDict setValue:@"1" forKey:@"Every"];
                [bioDict setValue:@"0" forKey:@"None"];
                [bioDict setValue:@"0" forKey:@"Connection"];
            }else if ([userInfo.titleText isEqualToString:@"None"]) {
                [bioDict setValue:@"0" forKey:@"Every"];
                [bioDict setValue:@"1" forKey:@"None"];
                [bioDict setValue:@"0" forKey:@"Connection"];
            }
            else if ([userInfo.titleText isEqualToString:@"Connections"]) {
                [bioDict setValue:@"0" forKey:@"Every"];
                [bioDict setValue:@"0" forKey:@"None"];
                [bioDict setValue:@"1" forKey:@"Connection"];
            }
        }
    }
    
    
    for (FFUserInfo *userInfo in userMessageInfo.privateSubCategoryArray) {
        if (userInfo.isSelect) {
            
            if ([userInfo.titleText isEqualToString:@"All"]) {
                [messageDict setValue:@"1" forKey:@"Every"];
                [messageDict setValue:@"0" forKey:@"None"];
                [messageDict setValue:@"0" forKey:@"Connection"];
            }else if ([userInfo.titleText isEqualToString:@"None"]) {
                [messageDict setValue:@"0" forKey:@"Every"];
                [messageDict setValue:@"1" forKey:@"None"];
                [messageDict setValue:@"0" forKey:@"Connection"];
            }
            else if ([userInfo.titleText isEqualToString:@"Connections"]){
                [messageDict setValue:@"0" forKey:@"Every"];
                [messageDict setValue:@"0" forKey:@"None"];
                [messageDict setValue:@"1" forKey:@"Connection"];
            }
        }
    }
    
    
    //    for (FFUserInfo *userInfo in userCategoInfo.privateSubCategoryArray) {
    //        if (userInfo.isSelect) {
    //
    //            if ([userInfo.titleText isEqualToString:@"All"]) {
    //                [categoryDict setValue:@"every" forKey:@"CATEGORY"];
    //            }else if ([userInfo.titleText isEqualToString:@"None"])
    //                [categoryDict setValue:@"none" forKey:@"CATEGORY"];
    //            else if ([userInfo.titleText isEqualToString:@"Connections"])
    //                [categoryDict setValue:@"connection" forKey:@"CATEGORY"];
    //        }
    //    }
    //
    //
    //    for (FFUserInfo *userInfo in userPostInfo.privateSubCategoryArray) {
    //        if (userInfo.isSelect) {
    //
    //            if ([userInfo.titleText isEqualToString:@"All"]) {
    //                [postDict setValue:@"every" forKey:@"POST"];
    //            }else if ([userInfo.titleText isEqualToString:@"None"])
    //                [postDict setValue:@"none" forKey:@"POST"];
    //            else if ([userInfo.titleText isEqualToString:@"Connections"])
    //                [postDict setValue:@"connection" forKey:@"POST"];
    //        }
    //    }
    //
    //
    //    for (FFUserInfo *userInfo in userBioInfo.privateSubCategoryArray) {
    //        if (userInfo.isSelect) {
    //
    //            if ([userInfo.titleText isEqualToString:@"All"]) {
    //                [bioDict setValue:@"every" forKey:@"BIO"];
    //            }else if ([userInfo.titleText isEqualToString:@"None"])
    //                [bioDict setValue:@"none" forKey:@"BIO"];
    //            else if ([userInfo.titleText isEqualToString:@"Connections"])
    //                [bioDict setValue:@"connection" forKey:@"BIO"];
    //        }
    //    }
    //
    //
    //    for (FFUserInfo *userInfo in userMessageInfo.privateSubCategoryArray) {
    //        if (userInfo.isSelect) {
    //
    //            if ([userInfo.titleText isEqualToString:@"All"]) {
    //                [messageDict setValue:@"every" forKey:@"MESSAGE"];
    //            }else if ([userInfo.titleText isEqualToString:@"None"])
    //                [messageDict setValue:@"none" forKey:@"MESSAGE"];
    //            else if ([userInfo.titleText isEqualToString:@"Connections"])
    //                [messageDict setValue:@"connection" forKey:@"MESSAGE"];
    //        }
    //    }
    //
    //    [postArray addObject:postDict];
    //    [postArray addObject:bioDict];
    //    [postArray addObject:messageDict];
    //    [postArray addObject:categoryDict];
    
    [dictRequest setValue:postDict forKey:@"POST"];
    [dictRequest setValue:bioDict forKey:@"BIO"];
    [dictRequest setValue:messageDict forKey:@"MESSAGE"];
    [dictRequest setValue:categoryDict forKey:@"CATEGORY"];
    
    [dictRequest setValue:apiSetAccountSetting forKey:KAction];
    //  [dictRequest setValue:postArray forKey:KType];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
    
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
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


- (void)makeWebApiCallToGetPrivateAccount {
    
     [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiAccountSetting forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
         [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                FFUserInfo *userInfoAtZerosIndex = [privateArray objectAtIndex:0];
                FFUserInfo *userInfoAtOneIndex = [privateArray objectAtIndex:1];
                FFUserInfo *userInfoAtTwoIndex = [privateArray objectAtIndex:2];
                FFUserInfo *userInfoAtThreeIndex = [privateArray objectAtIndex:3];
                
                NSArray *privateArr = [response objectForKeyNotNull:@"account_setting" expectedObj:[NSDictionary dictionary]];
                
                NSMutableArray *privateTempArray = [NSMutableArray array];
                for (NSDictionary *dict in privateArr) {
                    [privateTempArray addObject:[FFUserInfo userInfoGetPrivateAccountResponse:dict]];
                }
                
                
                if (privateTempArray.count) {
                    FFUserInfo *userInfoZeroIndex = [privateTempArray objectAtIndex:0];
                    
                    if ([userInfoZeroIndex.connectionType isEqualToString:@"POST"] ) {
                        
                        if ([userInfoZeroIndex.name isEqualToString:@"connection"]){
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtOneIndex.privateSubCategoryArray objectAtIndex:2];
                            userInfoAtZeroIndex.isSelect = YES;
                            
                        }
                        else if ([userInfoZeroIndex.name isEqualToString:@"none"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtOneIndex.privateSubCategoryArray objectAtIndex:1];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                        else if ([userInfoZeroIndex.name isEqualToString:@"every"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtOneIndex.privateSubCategoryArray objectAtIndex:0];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                    }
                    
                    
                    FFUserInfo *userInfoOneIndex = [privateTempArray objectAtIndex:1];
                    if ([userInfoOneIndex.connectionType isEqualToString:@"BIO"] ) {
                        
                        if ([userInfoOneIndex.name isEqualToString:@"connection"]){
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtTwoIndex.privateSubCategoryArray objectAtIndex:2];
                            userInfoAtZeroIndex.isSelect = YES;
                            
                        }
                        else if ([userInfoOneIndex.name isEqualToString:@"none"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtTwoIndex.privateSubCategoryArray objectAtIndex:1];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                        else if ([userInfoOneIndex.name isEqualToString:@"every"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtTwoIndex.privateSubCategoryArray objectAtIndex:0];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                    }
                    
                    
                    FFUserInfo *userInfoTwoIndex = [privateTempArray objectAtIndex:2];
                    if ([userInfoTwoIndex.connectionType isEqualToString:@"MESSAGE"] ) {
                        
                        if ([userInfoTwoIndex.name isEqualToString:@"connection"]){
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtThreeIndex.privateSubCategoryArray objectAtIndex:2];
                            userInfoAtZeroIndex.isSelect = YES;
                            
                        }
                        else if ([userInfoTwoIndex.name isEqualToString:@"none"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtThreeIndex.privateSubCategoryArray objectAtIndex:1];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                        else if ([userInfoTwoIndex.name isEqualToString:@"every"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtThreeIndex.privateSubCategoryArray objectAtIndex:0];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                    }
                    
                    
                    FFUserInfo *userInfoThreeIndex = [privateTempArray objectAtIndex:3];
                    if ([userInfoThreeIndex.connectionType isEqualToString:@"CATEGORY"] ) {
                        
                        if ([userInfoThreeIndex.name isEqualToString:@"connection"]){
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtZerosIndex.privateSubCategoryArray objectAtIndex:2];
                            userInfoAtZeroIndex.isSelect = YES;
                            
                        }
                        else if ([userInfoThreeIndex.name isEqualToString:@"none"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtZerosIndex.privateSubCategoryArray objectAtIndex:1];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                        else if ([userInfoThreeIndex.name isEqualToString:@"every"]) {
                            FFUserInfo *userInfoAtZeroIndex = [userInfoAtZerosIndex.privateSubCategoryArray objectAtIndex:0];
                            userInfoAtZeroIndex.isSelect = YES;
                        }
                    }
                }
                [self.tableView reloadData];

                
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
