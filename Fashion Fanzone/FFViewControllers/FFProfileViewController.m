//
//  FFProfileViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 30/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFProfileViewController.h"
#import "FFFanzoneModelInfo.h"
#import "FFCategoryTableViewCell.h"

static NSString *categoryCellID = @"CategoryCellID";



@interface FFProfileViewController ()<UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate,HeaderProtocolFashionFlow,EditProfileProtocol,PostDetailProtocol >
{
    UIImageView * headerImage;
    UIImageView * headerImage1;
    UIButton * btn;
    UIButton * dropDown;
    UIButton * profileBtn;
    FFHeader *viewHeader;
    UIView * filterView;
    BOOL shouldShowDoubleItem;
    BOOL isLoading;
    UITableView * categoryTableView;
    NSString *flowId;
    FFFanzoneModelInfo *fanzoneInfo;
    BOOL isFullScreen;
    CGRect prevFrame;
    UILabel *headerLabel;
}

@property (nonatomic, strong ) NSMutableArray * storyArray;
@property (nonatomic, strong ) NSMutableArray * flowArray;
@property (nonatomic, strong ) IBOutlet UICollectionView * collectionView;
@property (nonatomic, strong)  UICollectionReusableView *header;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (strong, nonatomic) PAPagination *pagination;
@property (strong, nonatomic) NSString  * bannerImageUrl;
@property (strong, nonatomic) NSString *userProfileUrl;

@end

NSString * const kHeaderIdent = @"Header";

@implementation FFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * userLoggedInID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    
  //  [categoryTableView registerNib:[UINib nibWithNibName:@"FFCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:categoryCellID];
    
    isFullScreen = NO;
   if ([self.concernUser_id isEqualToString:userLoggedInID] || self.concernUser_id==nil) {
        _isUserSelfProfile = YES;
        self.concernUser_id = userLoggedInID;
    }
    [self maangeStrch];
    viewHeader = [[FFHeader alloc] initWithNibName:@"FFHeader" bundle:nil];
    self.flowArray = [[NSMutableArray alloc] init];
    self.storyArray = [NSMutableArray array];
    
    // Add Refresh Control
    // Add Pull To Refresh On Fanzone Table
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(profileRefreshControl) forControlEvents:UIControlEventValueChanged];
    
    // Alloc Pagination Modal
    self.pagination = [[PAPagination alloc] init];
    self.pagination.pageNo = @"1";
    flowId = @"";
    
    [self apiToFetchUserprofileData:@"1"];
    
    fanzoneInfo = [[FFFanzoneModelInfo alloc] init];
    fanzoneInfo.userPostArray = [NSMutableArray array];
   [self makeWebApiCallForGetFanzonecategory];
    [self manageFileterview];
    // Do any additional setup after loading the view.
}



#pragma mark-
#pragma mark Manage FilterView---

-(void)manageFileterview
{
     filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width, 150)];
    UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    filterView.backgroundColor = [UIColor clearColor];
    subView.backgroundColor = [UIColor whiteColor];
    subView.alpha = 0.8;
    filterView.clipsToBounds = YES;
    
    categoryTableView = [[UITableView alloc] initWithFrame:subView.frame style:UITableViewStylePlain];
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
   // [categoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [categoryTableView registerNib:[UINib nibWithNibName:@"FFCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:categoryCellID];

    categoryTableView.backgroundColor = [UIColor clearColor];
    categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    categoryTableView.showsVerticalScrollIndicator = NO;
    categoryTableView.bounces = NO;
    
    [filterView addSubview:subView];
    [filterView addSubview:categoryTableView];
    [self.view addSubview:filterView];
    [self.view bringSubviewToFront:filterView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)maangeStrch
{
    StretchyHeaderCollectionViewLayout *stretchyLayout;
    stretchyLayout = [[StretchyHeaderCollectionViewLayout alloc] init];
    [stretchyLayout setSectionInset:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [stretchyLayout setItemSize:CGSizeMake(300.0, 494.0)];
    [stretchyLayout setHeaderReferenceSize:CGSizeMake(320.0, 160.0)];
    
   // [self.collectionView setCollectionViewLayout:stretchyLayout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 5, 4, 5);
    [self.collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kHeaderIdent];
    

}

#pragma mark - Manage Navigation bar-

-(void)layoutNavigationBar
{
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    headerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width-200, 35)];
    
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width-200, 35)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = AppFont(16);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerImage1.image = [UIImage imageNamed:@"text3"];
    headerImage1.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage1];
    
    
    if (self.isFromConnection) {
        btn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(4, 0, 55, 35) andBackImage:[UIImage imageNamed:@"backBlack"]];
        btn.titleLabel.textColor = [UIColor blackColor];
        [btn setTitle:@"Back" forState:UIControlStateNormal];

    }else {
        btn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(4, 0, 35, 35) andBackImage:[UIImage imageNamed:@"chat"]];
    }
    [btn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.navigationController.navigationBar addSubview:btn];
    
    dropDown = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(80, 23, 20, 20) andBackImage:[UIImage imageNamed:@"dropdown"]];
    UIButton *dropTempButton = [[UIButton alloc]initWithFrame:CGRectMake(80, 15, [UIScreen mainScreen].bounds.size.width-160, 35)];

    [dropTempButton addTarget:self action:@selector(dropdownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:dropDown];
    [self.navigationController.navigationBar addSubview:dropTempButton];
    [self.navigationController.navigationBar addSubview:headerLabel];


    profileBtn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-35, 5, 30, 30) andBackImage:[UIImage imageNamed:@"setting"]];
    [profileBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:profileBtn];
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
    
    [super viewWillDisappear:animated];
    viewHeader.timer = nil;
    [viewHeader.timer invalidate];
    
    self.navigationController.navigationBarHidden = YES;
    [headerImage removeFromSuperview];
    [headerImage1 removeFromSuperview];
    [btn removeFromSuperview];
    [dropDown removeFromSuperview];
    [profileBtn removeFromSuperview];
    [headerLabel removeFromSuperview];
}


#pragma mark - Selector Method
-(void)profileRefreshControl {
    
    [self.refreshControl endRefreshing];
    [self apiToFetchUserprofileData:@"1"];
}


#pragma mark-
#pragma mark TableView Delegate Thods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FFFanzoneModelInfo *tempInfo = [self.flowArray firstObject];
    return tempInfo.categoryArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFCategoryTableViewCell * cell = (FFCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:categoryCellID];
    
    FFFanzoneModelInfo *tempInfo = [self.flowArray firstObject];
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
    cell.categoryTitleLabel.text = [NSString stringWithFormat:@"          %@", tempCatInfo.categoryName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideFilterView];
    FFFanzoneModelInfo *tempInfo = [self.flowArray firstObject];
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
    headerLabel.text = tempCatInfo.categoryName;
    headerImage1.hidden = YES;
    flowId = tempCatInfo.categoryID;
    [self apiToFetchUserprofileData:@"1"];
}

#pragma mark-
#pragma mark //// CollectionViewDelegate Methods-

- (UICollectionReusableView *)collectionView:(UICollectionView *)cv viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (!_header) {
        
        _header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                    withReuseIdentifier:kHeaderIdent
                                                           forIndexPath:indexPath];
        CGRect bounds;
        bounds = [_header bounds];
        _header.backgroundColor = [UIColor clearColor];
        
        viewHeader.delegate = self;
        
        FFFanzoneModelInfo *tempModel = [self.storyArray firstObject];
        viewHeader.detailArray = tempModel.userBannerImageArray;
        viewHeader.frame = CGRectMake(0, 0, windowWidth, 300);
        if (self.isUserSelfProfile) {
            [viewHeader.editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewHeader.editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
        }
        else
        {
            [viewHeader.editButton addTarget:self action:@selector(connectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [viewHeader.editButton setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
        }
         [viewHeader.connectionsBtn addTarget:self action:@selector(showConnections) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader.followingBtn addTarget:self action:@selector(showFollowers) forControlEvents:UIControlEventTouchUpInside];//showStylePoints
        [viewHeader.stylePointsBtn addTarget:self action:@selector(showStylePoints) forControlEvents:UIControlEventTouchUpInside];//
        
        
        [viewHeader.locationButton addTarget:self action:@selector(locationButtonAction) forControlEvents:UIControlEventTouchUpInside];//
        [viewHeader.doubleCellButton addTarget:self action:@selector(showDoubleItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];//

        
        viewHeader.box1.userInteractionEnabled = YES;
        viewHeader.box2.userInteractionEnabled = YES;
        viewHeader.box3.userInteractionEnabled = YES;
        viewHeader.nameLabel.userInteractionEnabled = YES;
        viewHeader.profileImageView.userInteractionEnabled = YES;
        viewHeader.bannerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDoubleItem:)];
        UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDoubleItem:)];
        UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSingleItem:)];
        UITapGestureRecognizer * tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelClicked:)];
        UITapGestureRecognizer * tapUserprofile = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileClicked:)];
        UITapGestureRecognizer * tapUserBanner = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfileClicked:)];
        
        
        [viewHeader.box1 addGestureRecognizer:tap1];
        [viewHeader.box2 addGestureRecognizer:tap2];
        [viewHeader.box3 addGestureRecognizer:tap3];
        [viewHeader.nameLabel addGestureRecognizer:tap4];
        [viewHeader.profileImageView addGestureRecognizer:tapUserprofile];
        [viewHeader.bannerImageView addGestureRecognizer:tapUserBanner];
        [_header addSubview:viewHeader];
        
    }
    
    return _header;
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   return fanzoneInfo.userPostArray.count;

}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
   return CGSizeMake(self.collectionView.bounds.size.width, 300);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFFanzoneModelInfo *tempPostModel = [fanzoneInfo.userPostArray objectAtIndex:indexPath.item];
    
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.fanzoneModal = tempPostModel;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileStoryCell" forIndexPath:indexPath];
    
    FFFanzoneModelInfo *tempPostModel = [fanzoneInfo.userPostArray objectAtIndex:indexPath.item];
    FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];

    [cell.storyImage sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    cell.noOfLikes.text = tempPostModel.likeCount;
    cell.noOfComments.text = tempPostModel.commentCount;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (shouldShowDoubleItem) {
        return CGSizeMake(([[UIScreen mainScreen] bounds].size.width/2)-6, ([[UIScreen mainScreen] bounds].size.width/2)-6);
    }
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width)-2, ([[UIScreen mainScreen] bounds].size.width)-2);
}




- (void)getFashionFlowImageTap:(FFFanzoneModelInfo *)model {
    
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.fanzoneModal = model;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - Custom Delegate Method

- (void)callFanzoneApi {
    
    [self apiToFetchUserprofileData:@"1"];
    
}



#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    
    if ([scrollView isEqual:self.collectionView]) {
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 10.0) {
            if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
                isLoading = NO;
                
                [self apiToFetchUserprofileData:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
                
            }
        }
    }
}

#pragma mark-
#pragma mark - IBAction Methods--

-(void)nameLabelClicked:(UITapGestureRecognizer* )tap
{
    
    FFEditProfileViewController * controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"FFEditProfileViewController"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)showDoubleItem:(UITapGestureRecognizer* )tap
{
    shouldShowDoubleItem = YES;
    [self.collectionView reloadData];
}


- (void)showDoubleItemButtonAction:(UIButton*)sender {
    shouldShowDoubleItem = YES;
    [self.collectionView reloadData];
}


-(void)showSingleItem:(UITapGestureRecognizer* )tap
{
     shouldShowDoubleItem = NO;
     [self.collectionView reloadData];
}
-(void)editBtnClicked:(id)sender
{
    FFEditProfileViewController * controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"FFEditProfileViewController"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)connectBtnClicked:(id)sender
{
    UIButton * button = (UIButton *)sender;
    NSLog(@"%@",viewHeader.editButton.titleLabel.text);
    if ([viewHeader.editButton.titleLabel.text isEqualToString:@"Following"]) {//conenct
       [self apiCallToFollowUnfollowUser:@"conenct" withButtonRefrence:button];
    }
    else
    {
        [self apiCallToFollowUnfollowUser:@"follow" withButtonRefrence:button];
    }
    
}
-(void)chatBtnClicked:(id)button
{
    if (self.isFromConnection) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        FFDirectMessageViewController * controller = (FFDirectMessageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFDirectMessageViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)hideFilterView
{
     filterView.frame = CGRectMake(0, -200, windowWidth, 150);
}
-(void)dropdownBtnClicked:(id)button
{
    

    if (filterView.frame.origin.y!=65) {
        [UIView transitionWithView:filterView duration:0.2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            filterView.frame = CGRectMake(0, 65, windowWidth, 150);
        }completion:nil];
    }
    else
    {
        [self hideFilterView];
    }
}

-(void)settingBtnClicked:(id)button
{
    UIViewController * controler = [self.storyboard instantiateViewControllerWithIdentifier:@"FFSettingsViewController"];
    [self.navigationController pushViewController:controler animated:YES];
}
-(void)showConnections
{
   
    FFConnectionsViewController * controller =  (FFConnectionsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFConnectionsViewController"];
    controller.concernUser_id = self.concernUser_id;
    if (_isUserSelfProfile) {
         controller.concernUser_id = [[NSUserDefaults standardUserDefaults] valueForKey:KUserId];
    }
   
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)showFollowers
{
    FFConnectionsViewController * controller =  (FFConnectionsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFConnectionsViewController"];
    controller.concernUser_id = self.concernUser_id;
    if (_isUserSelfProfile) {
        controller.concernUser_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showStylePoints//
{
    FFStylePointViewController * controller =  (FFStylePointViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFStylePointViewController"];
    controller.concernUser_id = self.concernUser_id;
    if (_isUserSelfProfile) {
        controller.concernUser_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    }
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)locationButtonAction{
    
    [self apiToFetchPostData:@"1"];
}

-(IBAction)fashionBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFFashionViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFFashionViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}
-(IBAction)editorBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFTextEditiorViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFTextEditiorViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}
-(IBAction)ExplorerBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFExploreViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFExploreViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}
-(IBAction)fanzoneBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFMainViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMainViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}
-(IBAction)cameraBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFCameraViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCameraViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}


#pragma mark - Helper Method


- (void)makeWebApiCallForGetFanzonePost:(NSString*)pageNumber {
    
    
}

#pragma mark - Custom Delegate Method

- (void)callProfileApi {
    [self apiToFetchUserprofileData:@"1"];
}


#pragma mark-
#pragma mark Api Call to Follow/Unfollow user-

-(void)apiCallToFollowUnfollowUser:(NSString *)actionString withButtonRefrence:(UIButton*)button//concernUser_id
{
    [self showLoader];
    
    NSString * loginUserId =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiToGetConnectedUser forKey:KAction];
    [dictRequest setValue:loginUserId forKey:KUserId];
    [dictRequest setValue:self.concernUser_id forKey:KOtheruserID];
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
            
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"1"]) {
                [viewHeader.editButton setTitle:@"Following" forState:UIControlStateNormal];
                [viewHeader.editButton setImage:nil forState:UIControlStateNormal];
                viewHeader.editButton.titleLabel.font = AppFont(18);
            }
            if ([[response objectForKeyNotNull:@"status" expectedObj:@""] isEqualToString:@"0"]) {
                
                [viewHeader.editButton setTitle:@"unFollow" forState:UIControlStateNormal];
                [viewHeader.editButton setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
            }
            
            [self apiToFetchUserprofileData:@"1"];
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:strResponseMessage onController:self];

            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


#pragma mark API TO FETCH USER PROFILE DATA-
//***** CP

-(void)apiToFetchUserprofileData:(NSString *)pageNumber
{
    [self showLoader];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiShowProfile forKey:KAction];
    [dictRequest setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]] forKey:KOtheruserID];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [dictRequest setValue:flowId forKey:KFlowID];
    [dictRequest setValue:@"" forKey:KDefaultlatitude];
    [dictRequest setValue:@"" forKey:KDefaultlongitude];
    [dictRequest setValue:pageNumber forKey:KPageNumber];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded)
        {
            [self hideLoader];
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200)
            {
                
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [self.storyArray removeAllObjects];
                    [fanzoneInfo.userPostArray removeAllObjects];
                }
                
                NSDictionary * userData = [response valueForKey:@"userData"];
                NSString * conenctionStatus = [NSString stringWithFormat:@"%@", userData[@"connectionStatus"]];
                viewHeader.nameLabel.text = [[NSString stringWithFormat:@"%@", userData[@"display_name"]] capitalizedString];
                viewHeader.noOfConnections.text = [NSString stringWithFormat:@"%@", userData[@"connectionsCount"]];
                viewHeader.descriptionView.text = [NSString stringWithFormat:@"%@\n%@", userData[@"Bio"],userData[@"url"]];
                
                viewHeader.noOfFollowers.text = [NSString stringWithFormat:@"%@", userData[@"followersCount"]];
                viewHeader.noOfStylePoints.text = [NSString stringWithFormat:@"%@", userData[@"stylePoints"]];//totalNoOfTags
                viewHeader.totalNoOfTags.text = [NSString stringWithFormat:@"%@ TAGS", userData[@"numberOfTags"]];//
             
                _userProfileUrl = userData[@"profilePicture"];
                UIImage * placeHolderImage = [UIImage imageNamed:@"placeholder"];
                if (![viewHeader.profileImageView.image isEqual:placeHolderImage]) {
                    placeHolderImage = viewHeader.profileImageView.image;
                }
                 [viewHeader.profileImageView sd_setImageWithURL:[NSURL URLWithString:userData[@"profilePicture"]] placeholderImage:placeHolderImage];

                if (!self.isUserSelfProfile)
                {
                    if ([conenctionStatus isEqualToString:@"0"]) {
                        [viewHeader.editButton setTitle:@"" forState:UIControlStateNormal];
                        [viewHeader.editButton setImage:[UIImage imageNamed:@"connect"] forState:UIControlStateNormal];
                    }
                    else{
                        [viewHeader.editButton setTitle:@"Following" forState:UIControlStateNormal];
                        [viewHeader.editButton setImage:nil forState:UIControlStateNormal];
                        viewHeader.editButton.titleLabel.font = AppFont(18);
                    }
                }
                
                NSArray *userPostArray = [response objectForKeyNotNull:KUserPost expectedObj:[NSArray array]];

                for (NSDictionary *dict in userPostArray) {
                    [fanzoneInfo.userPostArray addObject:[FFFanzoneModelInfo profilePostResponse:dict]];
                }
                [self.storyArray addObject:[FFFanzoneModelInfo profileResponse:response]];
                FFFanzoneModelInfo *tempModel = [self.storyArray firstObject];
                
                if (tempModel.userBannerImageArray.count) {
                    viewHeader.detailArray = tempModel.userBannerImageArray;
                    [viewHeader initialMethod];
                }
                else {
                    viewHeader.detailArray = tempModel.userBannerImageArray;
                    [viewHeader initialMethod];
                    placeHolderImage = [UIImage imageNamed:@"Banner"];
                    if (![viewHeader.profileImageView.image isEqual:placeHolderImage]) {
                        placeHolderImage = viewHeader.bannerImageView.image;
                    }
                    [viewHeader.bannerImageView sd_setImageWithURL:[NSURL URLWithString:userData[@"bannerPicture"]] placeholderImage:[UIImage imageNamed:@"Banner"]];
                }

                isLoading =YES;
                [self.collectionView reloadData];
                
                
            }else{
                [self.storyArray removeAllObjects];
                [fanzoneInfo.userPostArray removeAllObjects];
                [self.collectionView reloadData];
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
        }
    }];
}


-(void)apiToFetchPostData:(NSString *)pageNumber
{
    [self showLoader];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiNearByLocation forKey:KAction];
    [dictRequest setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]] forKey:KUserId];
    [dictRequest setValue:flowId forKey:KFlowID];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlatitude] forKey:KDefaultlatitude];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlongitude] forKey:KDefaultlongitude];
 
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded)
        {
            [self hideLoader];
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200)
            {
                
               [fanzoneInfo.userPostArray removeAllObjects];
                
                NSArray *userPostArray = [response objectForKeyNotNull:KUserPost expectedObj:[NSArray array]];
                
                for (NSDictionary *dict in userPostArray) {
                    [fanzoneInfo.userPostArray addObject:[FFFanzoneModelInfo profilePostResponse:dict]];
                }
                isLoading =NO;
                [self.collectionView reloadData];
                
                
            }else{
                [self.storyArray removeAllObjects];
                [fanzoneInfo.userPostArray removeAllObjects];
                [self.collectionView reloadData];
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}



- (void)makeWebApiCallForGetFanzonecategory {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiGetFanzoneCategory forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [_flowArray addObject:[FFFanzoneModelInfo fanzoneCategoryFromResponse:response]];
                [categoryTableView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}

-(void)userProfileClicked:(UITapGestureRecognizer*)tap
{

    UIImageView * imgview = (UIImageView*)tap.view;

    if (!isFullScreen) {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            //save previous frame
           prevFrame = imgview.frame;
            viewHeader.showPointsView.hidden = YES;
            if ([imgview isEqual:viewHeader.bannerImageView]) {
               viewHeader.profileImageView.alpha = 0;
            }
            [imgview setFrame:CGRectMake(5, 5, windowWidth-15, viewHeader.frame.size.height-10)];
       
        }completion:^(BOOL finished){
            isFullScreen = YES;
        }];
        return;
    } else {
        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
            [imgview setFrame:prevFrame];
            viewHeader.profileImageView.alpha = 1;

        }completion:^(BOOL finished){
            isFullScreen = NO;
            viewHeader.showPointsView.hidden = NO;
        }];
        return;
    }
    
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
