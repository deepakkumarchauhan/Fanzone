//
//  FFConnectionListViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFConnectionListViewController.h"

@interface FFConnectionListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray * recentConnectionsArray;
@property (nonatomic, strong) NSArray * connectionsArray;
@property (nonatomic, strong) NSMutableArray * FollowersArray;

@end

@implementation FFConnectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tbleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    NSLog(@"****** viewWillAppear ******");
    self.navigationController.navigationBar.hidden = NO;
    
    switch (self.index) {
        case 0:
        {
            [self fetchConnectionRecentData];
        };break;
        case 1:
        {
            [self fetchAllConnectionsData];
        };break;
        case 2:
        {
            [self fetchConnectionFollowingData];
        };break;
        default:
            break;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
#pragma mark TabelView Deelegate methods----



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.index) {
        case 0:return _recentConnectionsArray.count;break;
        case 1:return _connectionsArray.count;break;
        default:break;
    }
    return _FollowersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     FFConnectionListCell * cell =[tableView dequeueReusableCellWithIdentifier:@"connection"];
    cell.textlabel.font = AppFont(13);
   if (self.index==0) {
        
        FFConnectionModal * modal = [_recentConnectionsArray objectAtIndex:indexPath.row];
        NSString * stringText = [modal.message capitalizedString];
        NSString * bubstring = [[stringText componentsSeparatedByString:@"-"] objectAtIndex:0];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, bubstring.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        UIImage * img;
        switch ([modal.iconStatus integerValue]) {
            case 0:img=[UIImage imageNamed:@"follows"];break;
            case 1:img=[UIImage imageNamed:@"connected"];break;
            case 2:img=[UIImage imageNamed:@"reachedOut"];break;
            default:
                break;
        }
        cell.textlabel.attributedText = mat;
        [cell.messageImageView sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.userprofileImageview.image = img;
        cell.followingButton.hidden = YES;
    }
    
    if (self.index==1) {
        FFConnectionModal * modal = [_connectionsArray objectAtIndex:indexPath.row];
        NSString * stringText = [modal.displayName capitalizedString];
       NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        cell.textlabel.attributedText = mat;
        
        cell.userprofileImageview.tag = indexPath.row+200;
        UITapGestureRecognizer * tapOnProfileOne =[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileConnectionImageOnetapped:)];
        cell.userprofileImageview.userInteractionEnabled  = YES;
        [cell.userprofileImageview addGestureRecognizer:tapOnProfileOne];
        
        [cell.userprofileImageview sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.messageImageView.image = nil;
        cell.followingButton.hidden = YES;
    }
     if (self.index==2) {
         FFConnectionModal * modal = [_FollowersArray objectAtIndex:indexPath.row];
         NSString * stringText = [modal.displayName capitalizedString];
         NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
         cell.textlabel.attributedText = mat;
         
         cell.userprofileImageview.tag = indexPath.row+300;
         UITapGestureRecognizer * tapOnProfileOne =[[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileFollowerImageOnetapped:)];
         cell.userprofileImageview.userInteractionEnabled  = YES;
         [cell.userprofileImageview addGestureRecognizer:tapOnProfileOne];
         
         [cell.userprofileImageview sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:[UIImage imageNamed:@"placeholder"]];
         cell.messageImageView.image = nil;
         cell.followingButton.hidden = NO;
         cell.followingButton.tag = indexPath.row;
         [cell.followingButton addTarget:self action:@selector(followingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
          cell.followingButton.titleLabel.font = AppFont(13);
          cell.followingButton.hidden = YES;
         
     }
    
    return cell;
}

// option to remove user from follow list
-(void)followingButtonClicked:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    FFConnectionModal * modal = [_FollowersArray objectAtIndex:tag];
    [self apiToUnfollowAnyUser:modal.otherUserID];
}
-(void)fetchConnectionRecentData
{
    if (_recentConnectionsArray.count==0) {
        
        [self getRecentList];
        [_tbleView reloadData];
    }
}

-(void)fetchAllConnectionsData
{
    if (_connectionsArray.count==0) {
        [self getConnectionList];
         [_tbleView reloadData];
    }
}

-(void)fetchConnectionFollowingData
{
    if (_FollowersArray.count==0) {
        [self getFollowersList];
         [_tbleView reloadData];
    }
}


- (void)profileConnectionImageOnetapped:(UITapGestureRecognizer *)gesture {
    
    UIImageView * imgView = (UIImageView *)gesture.view;
    NSInteger tag = imgView.tag;
    FFConnectionModal * modal = [_connectionsArray objectAtIndex:tag-200];

    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.isFromConnection = YES;
    profile.concernUser_id = modal.otherUserID;
    [self.navigationController pushViewController:profile animated:NO];

}

- (void)profileFollowerImageOnetapped:(UITapGestureRecognizer *)gesture {
    
    UIImageView * imgView = (UIImageView *)gesture.view;
    NSInteger tag = imgView.tag;
    FFConnectionModal * modal = [_FollowersArray objectAtIndex:tag-300];
    
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.isFromConnection = YES;
    profile.concernUser_id = modal.otherUserID;
    [self.navigationController pushViewController:profile animated:NO];

}


#pragma mark-
#pragma mark APi to get recent Data-

-(void)getRecentList
{
    [self showLoader];
    if (!self.concernUser_id) {
        self.concernUser_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]]; // if there is no user id thhen login user id else bring user id from previous screen
    }
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetRecentList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _recentConnectionsArray = [FFConnectionModal parseConenctionRecentData:response];
                if(_recentConnectionsArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
                [_tbleView reloadData];
                
            }else{
               [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
        }
    }];
}


#pragma mark-
#pragma mark APi to get Connection Data-
-(void)getConnectionList
{
    [self showLoader];
    if (!self.concernUser_id) {
        self.concernUser_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]]; // if there is no user id thhen login user id else bring user id from previous screen
    }
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetConnectionList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _connectionsArray = [FFConnectionModal parseConenctionData:response];
                if(_connectionsArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
           [_tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
        }
    }];
}
#pragma mark-
#pragma mark APi to get Connection Followers Data-

-(void)getFollowersList
{
    [self showLoader];
    if (!self.concernUser_id) {
        self.concernUser_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]]; // if there is no user id thhen login user id else bring user id from previous screen
    }
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetConnecctionFollowersList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _FollowersArray =  [NSMutableArray arrayWithArray:[FFConnectionModal parseConenctionFollowersData:response]] ;
                if(_FollowersArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
                    
                [_tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
        }
    }];
}

#pragma mark-
#pragma mark APi toUnfollow any user-

-(void)apiToUnfollowAnyUser:(NSString*)unfollowuserId
{
    [self showLoader];
    
    NSString * loginUserId =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiToGetConnectedUser forKey:KAction];
    [dictRequest setValue:loginUserId forKey:KUserId];
    [dictRequest setValue:unfollowuserId forKey:KOtheruserID];
    [dictRequest setValue:@"0" forKey:KConnectedStatus];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            NSString *strStatusMessage = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            if ([strStatusMessage isEqualToString:@"200"]) {
                
            }
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"1"]) {
                
            }
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"0"]) {
                
            }
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:strResponseMessage onController:self];
            
            
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
