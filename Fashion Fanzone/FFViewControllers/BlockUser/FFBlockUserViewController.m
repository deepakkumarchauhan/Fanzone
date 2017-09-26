//
//  FFBlockUserViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFBlockUserViewController.h"
#import "FFBlockUserTableViewCell.h"
#import "Macro.h"

static NSString *cellId = @"blockUserCellId";

@interface FFBlockUserViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    NSMutableArray *userListArray;
}

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFBlockUserViewController


#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}


#pragma mark - Custom Method
-(void)initialSetUp {
    
    // Alloc Model Class
    userListArray = [NSMutableArray array];
    
    self.tableView.estimatedRowHeight = 50.0;
    
    [self apiToFetchBlockUserList];
}


#pragma mark - UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userListArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFBlockUserTableViewCell *cell = (FFBlockUserTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    FFBlockUserInfo *blockInfo = [userListArray objectAtIndex:indexPath.row];
    
    // Set Email Text
    cell.emailLabel.text = blockInfo.email;
    
    // Set Button Tag
    cell.unblockButton.tag = indexPath.row+200;
    
    [cell.unblockButton addTarget:self action:@selector(unblockButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - Selector Method
- (void)unblockButtonAction:(UIButton *)sender{
    
    // Remove Object At Index
    [[AlertView sharedManager] presentAlertWithTitle:@"Are you sure!" message:@"You want to unblock this user?" andButtonsWithTitle:@[@"Yes",@"No"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if (index == 0) {
            FFBlockUserInfo *blockInfo = [userListArray objectAtIndex:sender.tag-200];

            [self apiToBlockUnblockUser:@"0" blockID:blockInfo.email];
        }
    }];
}


#pragma mark - UIButton Action
- (IBAction)addButtonAction:(id)sender {
    
    
    if (TRIM_SPACE(self.emailTextField.text).length) {
        // Add Text
        [self apiToBlockUnblockUser:@"1" blockID:@""];
    }
    else {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter username/email." onController:self];
    }
}

- (IBAction)backButtobAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Service Helper Method

-(void)apiToFetchBlockUserList
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetBlockUserList forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [userListArray removeAllObjects];
                
                NSArray *tempArray = [response objectForKeyNotNull:KBlockUserList expectedObj:[NSArray array]];
                
                for (NSDictionary *dict in tempArray) {
                  [userListArray addObject:[FFBlockUserInfo blockUserListFromResponse:dict]];
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


-(void)apiToBlockUnblockUser:(NSString *)status blockID:(NSString *)email
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiBlockUnblockUser forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:([status isEqualToString:@"1"])?TRIM_SPACE(self.emailTextField.text):email forKey:@"emailID/UserName"];
    [dictRequest setValue:status forKey:KBlockStatus];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KSuccess andMessage:strResponseMessage onController:self];
                self.emailTextField.text = @"";
                [self apiToFetchBlockUserList];
                
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


#pragma mark - Memory Warning Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
