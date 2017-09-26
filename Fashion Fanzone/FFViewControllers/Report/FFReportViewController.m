//
//  FFReportViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFReportViewController.h"
#import "FFReportTableViewCell.h"
#import "Macro.h"

static NSString *cellId = @"reportCellId";

@interface FFReportViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    
    NSMutableArray *reportArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet FFTextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textViewheightConstraint;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@end

@implementation FFReportViewController


#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}


#pragma mark - Custom Method
-(void)initialSetUp {
    
    // Alloc Array
   NSArray *reportTempArray = [[NSArray alloc] initWithObjects:@"Spam or abuse",@"An issue with Fashion Fanzone App",@"General Feedback", nil];
    reportArray = [NSMutableArray array];
    
    // Hide TextView
    self.textViewheightConstraint.constant = 0.0;
    self.feedbackTextView.hidden = NO;
    self.feedbackTextView.placeholderText = @"Write your feedback..";

    for (int index = 0; index <= 2; index++) {
        
        FFUserInfo *userInfo = [[FFUserInfo alloc] init];
        userInfo.isSelect = NO;
        userInfo.titleText = [reportTempArray objectAtIndex:index];
        [reportArray addObject:userInfo];
    }
    
    self.tableView.estimatedRowHeight = 10;
}


#pragma mark - UITableView Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [reportArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFReportTableViewCell *cell = (FFReportTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    FFUserInfo *userInfo = [reportArray objectAtIndex:indexPath.row];
    
    // Set Email Text
    cell.reportTitleLabel.text = userInfo.titleText;
    
    if (userInfo.isSelect)
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
    
    FFUserInfo *userInfo = [reportArray objectAtIndex:indexPath.row];

    if (indexPath.row != 2) {
        for (FFUserInfo *userTempInfo in reportArray) {
            userTempInfo.isSelect = NO;
        }
        userInfo.isSelect = YES;
        
        [self.tableView reloadData];
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 20)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 100, 20)];
    titleLabel.font = [UIFont fontWithName:@"AvantGarde-Book" size:13];
    titleLabel.text = @"Report:";
    [sectioView addSubview:titleLabel];
    return sectioView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0;
}


#pragma mark - UIButton Action
- (IBAction)reportButtonAction:(id)sender {
    
//    FFUserInfo *userInfo = [reportArray objectAtIndex:2];
    
    BOOL isAnySelected = NO;
    for (FFUserInfo *userTempInfo in reportArray) {
        if (userTempInfo.isSelect) {
            isAnySelected = YES;
            break;
        }
    }
    
    if (!isAnySelected) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please select any option." onController:self];
    }
    else {
        [self apiToReportProblem];

    }
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)apiToReportProblem
{
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiReportProblem forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:TRIM_SPACE(self.feedbackTextView.text) forKey:KMessages];
    
    for (FFUserInfo *userTempInfo in reportArray) {
        if (userTempInfo.isSelect) {
            [dictRequest setValue:userTempInfo.titleText forKey:KReportProblem];
            break;
        }
    }
    
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
    [self.reportButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    [self.reportButton setTitle:@"Report Problem" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
