//
//  FFMembersViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMembersViewController.h"
#import "FFFanzoneModelInfo.h"
#import "FFConnectUserTableViewCell.h"


@interface FFMembersViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UITableView * memberTableView;
@end

static NSString *cellIUserConnectdentifier = @"connectionUserCellId";

@implementation FFMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _memberTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [_memberTableView registerNib:[UINib nibWithNibName:@"FFConnectUserTableViewCell" bundle:nil] forCellReuseIdentifier:cellIUserConnectdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark IBAction Methods- 

-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-
#pragma mark TableView Delegate Methods-

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFanzoneModelInfo * tempInfoModel = _dataSourceArray[indexPath.row];
    FFConnectUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIUserConnectdentifier];
    userCell.selectionStyle = UITableViewCellSelectionStyleNone;
    userCell.nameLabel.text = [tempInfoModel.userName uppercaseString];
    userCell.stylePointsLabel.text = [NSString stringWithFormat:@"(%@) Style Points",tempInfoModel.stylePoints];
    [userCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    userCell.connectButton.tag = indexPath.row;
    
    if ([tempInfoModel.status integerValue]==1) {
        [userCell.connectButton setImage:nil forState:UIControlStateNormal];
        [userCell.connectButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
    }
    else
    {
        [userCell.connectButton setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
        [userCell.connectButton setTitle:@"" forState:UIControlStateNormal];
        
    }
    [userCell.connectButton addTarget:self action:@selector(connectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return userCell;
}

-(void)connectionButtonClicked:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    FFFanzoneModelInfo * tempInfoModel = _dataSourceArray[tag];
    if ([tempInfoModel.status integerValue]==1) {
        //follow---make unfollow
        [self apiCallToFollowUnfollowUser:@"conenct" withIndex:tag];
    }
    else
    {
       // unfollow----make follow
        [self apiCallToFollowUnfollowUser:@"follow"  withIndex:tag];

    }
}



-(void)apiCallToFollowUnfollowUser:(NSString *)actionString withIndex:(NSInteger)index//concernUser_id
{
    [self showLoader];
    
    NSString * loginUserId =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    FFFanzoneModelInfo * tempInfoModel = _dataSourceArray[index];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiToGetConnectedUser forKey:KAction];
    [dictRequest setValue:loginUserId forKey:KUserId];
    [dictRequest setValue:tempInfoModel.postAddUserId forKey:KOtheruserID];
    if ([actionString isEqualToString:@"follow"]) {
        [dictRequest setValue:@"1" forKey:KConnectedStatus];
    }
    else
    {
        [dictRequest setValue:@"0" forKey:KConnectedStatus];
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
          //  NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"1"]) {
                tempInfoModel.status = @"1";
            }
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"0"]) {
                tempInfoModel.status = @"0";
            }
            [self.delegate callExploreSearchApi];
            [self.memberTableView reloadData];
            
           // [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:strResponseMessage onController:self];
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}



#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    self.view.userInteractionEnabled = NO;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

-(void)hideLoader{
    self.view.userInteractionEnabled = YES;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

@end
