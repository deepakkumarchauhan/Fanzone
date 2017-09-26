//
//  FFExploreSearchListView.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 09/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFExploreSearchListView.h"
#import "FFFanzoneTableViewCell.h"
#import "FFEditorialExploreTableViewCell.h"
#import "FFEditorialSearchCollectionViewCell.h"
#import "Macro.h"

static NSString *cellIUserConnectdentifier = @"connectionUserCellId";
static NSString *cellEditorialIdentifier = @"exploreEditorialTableCellId";
static NSString *cellAllPostsIdentifier = @"singleCell";

@interface FFExploreSearchListView ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource,MemberProtocol> {
    
    NSMutableArray *sourceArray;
    UITableView *exploreTableView;
    UIActivityIndicatorView *activityIndicatorView;
    NSString *searchExploreText;
}
@property (nonatomic, strong) NSMutableArray * searchedDataArray;

@end
@implementation FFExploreSearchListView


- (void)initialize
{
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((windowWidth/2)-15, windowHeight/4, 30, 30)];
    activityIndicatorView.color = [UIColor colorWithRed:0/255.0 green:213.0/255.0 blue:251.0/255.0 alpha:1.0];
    exploreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
    exploreTableView.delegate = self;
    exploreTableView.dataSource = self;
    exploreTableView.estimatedRowHeight = 311.0 ;
    exploreTableView.rowHeight = UITableViewAutomaticDimension;
    
    // Alloc Mutable Array
    sourceArray = [NSMutableArray array];
    
    [self addSubview:exploreTableView];
    [self addSubview:activityIndicatorView];
    activityIndicatorView.hidden = YES;
  //Register TableViewCell
    [exploreTableView registerNib:[UINib nibWithNibName:@"FFConnectUserTableViewCell" bundle:nil] forCellReuseIdentifier:cellIUserConnectdentifier];
    [exploreTableView registerNib:[UINib nibWithNibName:@"FFEditorialExploreTableViewCell" bundle:nil] forCellReuseIdentifier:cellEditorialIdentifier];
    [exploreTableView registerNib:[UINib nibWithNibName:@"FFFanzoneTableViewCell" bundle:nil] forCellReuseIdentifier:cellAllPostsIdentifier];
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if(self)
    {
        [self initialize];
    }
    return self;
}



#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _searchedDataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dict = _searchedDataArray[indexPath.section];
    if ([dict[@"arrayType"] isEqualToString:@"editorialArray"]) {
        return 230;
        
    }
    if ([dict[@"arrayType"] isEqualToString:@"userPostArray"]) {
        return 350;
    }
    if ([dict[@"arrayType"] isEqualToString:@"userDetailArray"]) {
        return 80;
    }
    return 0;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    NSDictionary * dict = _searchedDataArray[section];
    NSArray * rry = dict[@"dataArray"];
    if ([dict[@"arrayType"] isEqualToString:@"editorialArray"]) {
        return 1;
        
    }
    if ([dict[@"arrayType"] isEqualToString:@"userPostArray"]) {
        if(rry.count>=1)return 1;
    }
    if ([dict[@"arrayType"] isEqualToString:@"userDetailArray"]) {
        if(rry.count>=3)return 3;
    }
    return rry.count;
    
  
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary * dict = _searchedDataArray[indexPath.section];
    if ([dict[@"arrayType"] isEqualToString:@"editorialArray"]) {
       
        FFEditorialExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellEditorialIdentifier];
        [cell.exploreCollectionView registerNib:[UINib nibWithNibName:@"FFEditorialSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"searchExploreCollectionViewCellId"];
        cell.exploreCollectionView.delegate = self;
        cell.exploreCollectionView.dataSource = self;
        [cell.exploreCollectionView reloadData];
        return cell;
        
    }
    if ([dict[@"arrayType"] isEqualToString:@"userPostArray"]) {
        FFFanzoneTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellAllPostsIdentifier];
        
        NSArray * dataArray = dict[@"dataArray"];
        FFFanzoneModelInfo * tempInfoModel = dataArray[indexPath.row];
        NSArray * postArray = tempInfoModel.userPostArray;
        FFFanzoneModelInfo *tempBannerInfo;
        if (postArray.count>0) {
            tempBannerInfo = postArray[indexPath.row];
        }
        
        [userCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [userCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:tempBannerInfo.bannerImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
        userCell.profileImageView.tag = indexPath.row;
        userCell.descriptionLabel.text = tempInfoModel.fanzoneDescription;
        userCell.descriptionLabel.font =  AppFont(14);
        userCell.profileImageView.userInteractionEnabled  = YES;
        userCell.commentCount.text = tempInfoModel.commentCount;
        userCell.nameLabel.text = tempInfoModel.userName;
        userCell.stylePointLabel.text = [NSString stringWithFormat:@"(%@) Style points",tempInfoModel.stylePoints];
        userCell.likeCount.text = tempInfoModel.likeCount;
        userCell.photoImageBtn.tag = indexPath.row + 100;
     
        return userCell;
        
    }
    if ([dict[@"arrayType"] isEqualToString:@"userDetailArray"]) {
        NSArray * dataArray = dict[@"dataArray"];
        FFFanzoneModelInfo * tempInfoModel = dataArray[indexPath.row];
        FFConnectUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIUserConnectdentifier];
        
        userCell.connectButton.tag = indexPath.row + 100;
        userCell.profileImageView.tag = indexPath.row + 200;
        
        userCell.nameLabel.text = [tempInfoModel.userName uppercaseString];
        userCell.stylePointsLabel.text = [NSString stringWithFormat:@"(%@) Style Points",tempInfoModel.stylePoints];
        [userCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        UITapGestureRecognizer * tapOnProfileOne =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImageOnetapped:)];
        userCell.profileImageView.userInteractionEnabled  = YES;
        [userCell.profileImageView addGestureRecognizer:tapOnProfileOne];
        
        [userCell.connectButton addTarget:self action:@selector(connectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([tempInfoModel.status integerValue]==1) {
            [userCell.connectButton setImage:nil forState:UIControlStateNormal];
            [userCell.connectButton setTitle:@"FOLLOWING" forState:UIControlStateNormal];
        }
        else
        {
            [userCell.connectButton setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
            [userCell.connectButton setTitle:@"" forState:UIControlStateNormal];
        }
        return userCell;
    }
    return 0;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView;
    
    sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionHeaderView.frame.origin.x + 22,sectionHeaderView.frame.origin.y+5, sectionHeaderView.frame.size.width, sectionHeaderView.frame.size.height)];
    
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(sectionHeaderView.frame.size.width-75,sectionHeaderView.frame.origin.y+8, 70, 30)];
    moreLabel.text = @"More>";
    moreLabel.textColor = [UIColor blackColor];
    moreLabel.font = AppFont(16);
    headerLabel.font = AppFont(18);
    headerLabel.backgroundColor = [UIColor clearColor];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    [sectionHeaderView addSubview:headerLabel];
    [sectionHeaderView addSubview:moreLabel];
    UIButton *headerButton = [[UIButton alloc] initWithFrame:moreLabel.frame];
    headerButton.backgroundColor = [UIColor clearColor];

    NSDictionary * dict = _searchedDataArray[section];
    if ([dict[@"arrayType"] isEqualToString:@"editorialArray"]) {
        headerLabel.text = @"Editorial";
        headerLabel.textAlignment = NSTextAlignmentLeft;
        [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
        headerLabel.textColor = [UIColor blackColor];
        [headerButton addTarget:self action:@selector(moreEditorial:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView addSubview:headerButton];
        return sectionHeaderView;
        
    }
    if ([dict[@"arrayType"] isEqualToString:@"userPostArray"]) {
        headerLabel.text = @"Posts";
        headerLabel.textAlignment = NSTextAlignmentLeft;
        [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
        headerLabel.textColor = [UIColor blackColor];
        [headerButton addTarget:self action:@selector(moreUserPost:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView addSubview:headerButton];
        return sectionHeaderView;
    }
    if ([dict[@"arrayType"] isEqualToString:@"userDetailArray"]) {
        headerLabel.text = @"Members";
        headerLabel.textAlignment = NSTextAlignmentLeft;
        [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
        headerLabel.textColor = [UIColor blackColor];
        [headerButton addTarget:self action:@selector(moreUserDetail:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView addSubview:headerButton];
        return sectionHeaderView;
    }
    
    
    return sectionHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}



#pragma mark - UICollectionView delegate


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 30);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.bounds.size.width, 30);
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
   if (tempModel.editorialArray.count >= 2) {
        return 2;
    }
    return tempModel.editorialArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
   FFEditorialSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchExploreCollectionViewCellId" forIndexPath:indexPath];
    FFFanzoneModelInfo *tempInfoModel = [tempModel.editorialArray objectAtIndex:indexPath.item];
    
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.bannerImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    cell.nameLabel.text = tempInfoModel.fanzoneTitle;


    return cell;
}



-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];

    FFFanzoneModelInfo *obj_detail = [tempModel.editorialArray objectAtIndex:indexPath.item];
    CGSize finalSize = CGSizeMake(obj_detail.imageWidth.integerValue, obj_detail.imageHeight.integerValue);
    int numberOfCellInRow = 3;
    CGFloat cellWidth =0;
    CGFloat height = 0;
    
    if (finalSize.width > finalSize.height)
    {
        //landscape
        numberOfCellInRow = 1;
        cellWidth =  [[UIScreen mainScreen] bounds].size.width;
        height = cellWidth * 0.5;
        return CGSizeMake(cellWidth, height);
    }
    else
    {
        //portrait
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth-10, cellWidth*1.1);
        return size;
    }
    
    
    return CGSizeMake(cellWidth-20, height);
}


-(void)callSearchApi:(NSString *)searchText withViewController:(UIViewController*)controller;
 {
     self.controller = controller;
     searchExploreText = searchText;
     [self makeWebApiCallForGetExplore:@"1" searchText:searchText];
}

#pragma mark - Custom Delegate Method

-(void)callExploreSearchApi {
    
    [self makeWebApiCallForGetExplore:@"1" searchText:searchExploreText];
}


#pragma mark - Selector Method
- (void)connectButtonAction:(UIButton *)sender {
    

    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                            toView:exploreTableView];
    NSIndexPath *tappedIP = [exploreTableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary * dict = _searchedDataArray[tappedIP.section];
    NSArray * dataArray = dict[@"dataArray"];
    FFFanzoneModelInfo * tempInfoModel = dataArray[tappedIP.row];
    
    if ([tempInfoModel.status integerValue]==1) {
        //follow---make unfollow
        [self apiCallToFollowUnfollowUser:@"conenct" obj:tempInfoModel];
    }
    else
    {
        // unfollow----make follow
        [self apiCallToFollowUnfollowUser:@"follow"  obj:tempInfoModel];
        
    }

}

- (void)profileImageOnetapped:(UITapGestureRecognizer *)gesture {
    
    
    CGPoint buttonPosition = [gesture locationInView:exploreTableView];
    NSIndexPath *tappedIP = [exploreTableView indexPathForRowAtPoint:buttonPosition];
    
//    
//    UIImageView * view = (UIImageView *)gesture.view;
//    NSInteger indexTapped = view.tag-200;
    
    NSDictionary * dict = _searchedDataArray[tappedIP.section];
    NSArray * dataArray = dict[@"dataArray"];
    FFFanzoneModelInfo * tempInfoModel = dataArray[tappedIP.row];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FFProfileViewController * myController = (FFProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    myController.isUserSelfProfile = NO;
    myController.concernUser_id = tempInfoModel.postAddUserId;
    [self.controller.navigationController pushViewController: myController animated:NO];
    
}

#pragma mark - Service Helper Method

- (void)makeWebApiCallForGetExplore :(NSString *)pageNumber searchText:(NSString *)searchText {
    
     [self showLoader];
    _searchedDataArray = nil;
    _searchedDataArray = [NSMutableArray new];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiSearchPost forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
     [dictRequest setValue:searchText forKey:KSearchText];
[dictRequest setValue:pageNumber forKey:KPageNumber];
    
    
        [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
         [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            if (strResponseCode.integerValue == 200) {
                [sourceArray addObject:[FFFanzoneModelInfo fanzoneFetchExploreSearchFromResponse:response]];
                
                FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
                if (tempModel.editorialArray.count>0) {
                    NSMutableDictionary * dict = [NSMutableDictionary new];
                    [dict setObject:@"editorialArray" forKey:@"arrayType"];
                    [dict setObject:tempModel.editorialArray forKey:@"dataArray"];
                    [_searchedDataArray addObject:dict];
                }
                if (tempModel.userPostArray.count>0) {
                    NSMutableDictionary * dict = [NSMutableDictionary new];
                    [dict setObject:@"userPostArray" forKey:@"arrayType"];
                    [dict setObject:tempModel.userPostArray forKey:@"dataArray"];
                    [_searchedDataArray addObject:dict];
                }
                if (tempModel.userDetailArray.count>0) {
                    NSMutableDictionary * dict = [NSMutableDictionary new];
                    [dict setObject:@"userDetailArray" forKey:@"arrayType"];
                    [dict setObject:tempModel.userDetailArray forKey:@"dataArray"];
                    [_searchedDataArray addObject:dict];
                }
                
                [exploreTableView reloadData];
                NSLog(@"%@",sourceArray);
                
                
            }else{
                // [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:[APPDELEGATE w]];
                
            }
            
        }else{
            // [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}



#pragma mark - Activity Indicator Helper Method

- (void)showLoader {

    self.userInteractionEnabled = NO;
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
}

-(void)hideLoader{

    self.userInteractionEnabled = YES;
    activityIndicatorView.hidden = YES;
    [activityIndicatorView stopAnimating];
}

#pragma mark-
#pragma mark IBAtion Methods-

-(IBAction)moreUserDetail:(id)sender
{
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FFMembersViewController * myController = (FFMembersViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FFMembersViewController"];
    myController.delegate = self;
    myController.dataSourceArray = tempModel.userDetailArray;
    [self.controller.navigationController pushViewController: myController animated:NO];
    
}
-(IBAction)moreEditorial:(id)sender
{
    for (UIViewController * controller in self.controller.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFFashionViewController class]]) {
            [self.controller.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"FFFashionViewController"];
    [self.controller.navigationController pushViewController: myController animated:NO];
}
-(IBAction)moreUserPost:(id)sender
{
    for (UIViewController * controller in self.controller.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFMainViewController class]]) {
            [self.controller.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"FFMainViewController"];
    [self.controller.navigationController pushViewController: myController animated:NO];
}


-(void)apiCallToFollowUnfollowUser:(NSString *)actionString obj:(FFFanzoneModelInfo *)info//concernUser_id
{
    [self showLoader];
    
    NSString * loginUserId =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiToGetConnectedUser forKey:KAction];
    [dictRequest setValue:loginUserId forKey:KUserId];
    [dictRequest setValue:info.postAddUserId forKey:KOtheruserID];
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
                info.status = @"1";
            }
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"0"]) {
                info.status = @"0";
            }
            [self makeWebApiCallForGetExplore:@"1" searchText:searchExploreText];
            
            // [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:strResponseMessage onController:self];
            
        }else{
           // [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


@end
