//
//  FFprofileDetailViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 31/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFprofileDetailViewController.h"
#import "FFCreateFlowViewController.h"

@interface FFprofileDetailViewController ()<UITableViewDelegate, UITableViewDataSource, EditProfileProtocol>
{
    UIImageView * headerImage;
    UIButton * button;
    NSMutableArray *userData;
    FFUserDetailSectionHeader * header;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFprofileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    header = [[FFUserDetailSectionHeader alloc] initWithNibName:@"FFUserDetailSectionHeader" bundle:nil];
    
    userData = [NSMutableArray array];
    
    if (self.isEditOption) {
        [header.editBtn setImage:nil forState:UIControlStateNormal];
        [header.editBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
        [header.editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [header.editBtn setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];//
        [header.editBtn addTarget:self action:@selector(connectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger viewHeight = 340;
    if (MainScreenHeight>568) {
        viewHeight = 250;
    }
    [header setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight)];
    self.tableView.tableHeaderView = header;
    self.tableView.rowHeight = 50;
    self.tableView.estimatedRowHeight = 50.0 ;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self apiToFetchUserprofileData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutNavigationBar {
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"backBlack"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 5, 60, 30)];
    [self.navigationController.navigationBar addSubview:button];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self layoutNavigationBar];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [headerImage removeFromSuperview];
    [button removeFromSuperview];
    
}


#pragma mark -*************** Table View DataSource Methods *****************-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return modelInfo.achievementArray.count;
        }
            break;
        case 2:
        {
            if (self.isEditOption) {
                return modelInfo.flowArray.count;
            }
            return modelInfo.flowArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"userDetail"];
    cell.editTextView.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    if (indexPath.section==0) {
        
        if (userData.count) {
            cell.textLabelDetails.text = [NSString stringWithFormat:@"%@. \n\n%@",modelInfo.bio,modelInfo.userUrl];
        }else
            cell.textLabelDetails.text = @"";

    }
    
    if (indexPath.section==1) {
        FFFanzoneModelInfo *modelTempInfo = [modelInfo.achievementArray objectAtIndex:indexPath.row];
        cell.textLabelDetails.text = modelTempInfo.achievementName;
    }
    
    if (indexPath.section==2) {
        
        FFFanzoneModelInfo *modelTempInfo = [modelInfo.flowArray objectAtIndex:indexPath.row];
        cell.textLabelDetails.text = modelTempInfo.flowName;
        
    }
    
    return cell;
}

#pragma mark TableView delegate----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    if (section == 1) {
        if (modelInfo.achievementArray.count)
            return 20;
        else
            return 0;
    }
    if (section == 2) {
        if (modelInfo.flowArray.count)
            return 20;
        else
            return 0;
    }
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    FFFanzoneModelInfo *modelInfo = [userData firstObject];

    if (section==0) {
        return  [[UIView alloc] initWithFrame:CGRectZero];
    }
    if (section==1) {
        if (modelInfo.achievementArray.count)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        else
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];

        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 150, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"achivement"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    if (section==2) {
        if (modelInfo.flowArray.count)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        else
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 80, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"flow"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    if (indexPath.section == 2) {
        if (modelInfo.flowArray.count == indexPath.row+1) {
            FFCreateFlowViewController *createFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCreateFlowViewController"];
            [self.navigationController pushViewController:createFlowVC animated:YES];
        }
    }
    
    }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


#pragma mark - Custom Delegate Method

- (void)callProfileApi {
    [self apiToFetchUserprofileData];
}


#pragma mark--- IBAction & Selector Methods---
-(void)callBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editBtnClicked {
    FFEditProfileViewController * controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"FFEditProfileViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)connectBtnClicked:(UIButton *)btn {
    //    [btn setImage:nil forState:UIControlStateNormal];
    //    [btn setTitle:@"FOLLOWING" forState:UIControlStateNormal];
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
                
                [userData removeAllObjects];
                
                [userData addObject:[FFFanzoneModelInfo fanzoneUserDetailResponse:response]];
                
                FFFanzoneModelInfo *modelInfo = [userData firstObject];
                
                FFFanzoneModelInfo *modelTempInfo = [[FFFanzoneModelInfo alloc]init];
                FFFanzoneModelInfo *modelBannerTempInfo = [modelInfo.userBannerImageArray firstObject];

                
                modelTempInfo.flowName = @"+MANAGE FLOW";
                [modelInfo.flowArray addObject:modelTempInfo];
                header.userNameTextFeilds.text = modelInfo.userName;
                header.noOfFolloerws.text = modelInfo.followersCount;
                header.noIfStypePoints.text = modelInfo.stylePoints;
                header.noOfConnections.text = modelInfo.connectionsCount;
                header.nameLabel.text = modelInfo.userName;
                
                [header.profileImageView sd_setImageWithURL:[NSURL URLWithString:modelInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [header.bannerView sd_setImageWithURL:[NSURL URLWithString:modelBannerTempInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
                
                
                if (modelInfo.isVerify) {
                    header.verifiedLabel.text = @"Verified";
                }else{
                    header.verifiedLabel.text = @"Not Verified";
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
