//
//  FFMainViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMainViewController.h"
#import "FBLikeLayout.h"
#import "ImageCollectionViewCell.h"
#import "FFUtility.h"
#import "FFFanzoneModelInfo.h"
#import "AlertView.h"
#import "Macro.h"
#import "FFVursesTableViewCell.h"
#import "FFPortraitTableViewCell.h"
#import "FFCategoryTableViewCell.h"

static NSString *categoryCellID = @"CategoryCellID";

static NSString *cellId = @"versusCell";

@interface FFMainViewController ()<  UITableViewDelegate, UITableViewDataSource,PostDetailProtocol>
{
    UIImageView * headerImage;
    UIImageView * headerImage1;
    UIButton * btn;
    UIButton * dropDown;
    UIButton * profileBtn;
    UIView * filterView;
    UITableView * filterTableView;
    BOOL isLoading;
    NSString *flowId;
    UILabel *headerLabel;
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *fanzoneTableView;
@property (nonatomic, strong) NSMutableArray * flowArray;
@property (nonatomic, strong) NSMutableArray * sourceArray;
@property (nonatomic, strong) NSMutableArray * vsArray;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (strong, nonatomic) PAPagination *pagination;


@end

@implementation FFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}



- (void)initialSetup { //
    
    self.fanzoneTableView.estimatedRowHeight = 311.0 ;
    self.fanzoneTableView.rowHeight = UITableViewAutomaticDimension;
    [self.fanzoneTableView registerClass:[FFFanzoneTableViewCell class] forCellReuseIdentifier:@"singleCell"];
    UINib *cellNib = [UINib nibWithNibName:@"FFFanzoneTableViewCell" bundle:nil];
    [self.fanzoneTableView registerNib:cellNib forCellReuseIdentifier:@"singleCell"];
    [self.fanzoneTableView registerClass:[FFVursesTableViewCell class] forCellReuseIdentifier:@"versusCell"];
    cellNib = [UINib nibWithNibName:@"FFVursesTableViewCell" bundle:nil];
    [self.fanzoneTableView registerNib:cellNib forCellReuseIdentifier:@"versusCell"];
    cellNib = [UINib nibWithNibName:@"FFPortraitTableViewCell" bundle:nil];
    [self.fanzoneTableView registerNib:cellNib forCellReuseIdentifier:@"portrait"];
    
    self.flowArray = [NSMutableArray array];
    self.sourceArray = [NSMutableArray array];
    self.vsArray = [NSMutableArray array];
    
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-20, 4, 4, 4);
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
    
    [self manageFileterview];
    
    // Add Pull To Refresh On Fanzone Table
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.fanzoneTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshFanzoneTable) forControlEvents:UIControlEventValueChanged];
    
    // Alloc Pagination Modal
    self.pagination = [[PAPagination alloc] init];
    self.pagination.pageNo = @"1";
    flowId = @"";
    [self makeWebApiCallForGetFanzonecategory];
    [self makeWebApiCallForGetFanzonePost:self.pagination.pageNo];
    
}


#pragma mark--- Manage Filetr View---


-(void)manageFileterview
{
    filterView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width, 150)];
    UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    filterView.backgroundColor = [UIColor clearColor];
    subView.backgroundColor = [UIColor whiteColor];
    subView.alpha = 0.8;
    filterView.clipsToBounds = YES;
    
    filterTableView = [[UITableView alloc] initWithFrame:subView.frame style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    
    [filterTableView registerNib:[UINib nibWithNibName:@"FFCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:categoryCellID];

   // [filterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.showsVerticalScrollIndicator = NO;
    filterTableView.bounces = NO;
    filterTableView.tag = 111;
    [filterView addSubview:subView];
    [filterView addSubview:filterTableView];
    [self.view addSubview:filterView];
    [self.view bringSubviewToFront:filterView];
    
}
#pragma mark- LayoutNavigation Controller---


-(void)layoutNavigationBar
{
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    headerImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width-200, 35)];
    headerImage1.image = [UIImage imageNamed:@"text3"];
    headerImage1.contentMode = UIViewContentModeScaleAspectFit;
    
    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, [UIScreen mainScreen].bounds.size.width-200, 35)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = AppFont(16);
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationController.navigationBar addSubview:headerImage1];
    [self.navigationController.navigationBar addSubview:headerLabel];

    
    btn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(4, 0, 35, 35) andBackImage:[UIImage imageNamed:@"chat"]];
    [btn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
    
    dropDown = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(80, 23, 20, 20) andBackImage:[UIImage imageNamed:@"dropdown"]];
    UIButton *dropTempBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 15, [UIScreen mainScreen].bounds.size.width-200, 35)];
    [dropTempBtn addTarget:self action:@selector(dropdownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:dropDown];
    [self.navigationController.navigationBar addSubview:dropTempBtn];
    
    profileBtn.layer.cornerRadius = profileBtn.layer.frame.size.width/2;
    profileBtn.layer.masksToBounds = YES;
    
    NSString *str = [NSUSERDEFAULT valueForKey:KUserImage];
    profileBtn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, 1, 40, 40) andBackImage:[UIImage imageNamed:@"placeholder"]];
    [profileBtn sd_setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [profileBtn addTarget:self action:@selector(profileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    self.navigationController.navigationBarHidden = YES;
    [headerImage removeFromSuperview];
    [headerImage1 removeFromSuperview];
    [btn removeFromSuperview];
    [dropDown removeFromSuperview];
    [profileBtn removeFromSuperview];
    [headerLabel removeFromSuperview];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////manage layouts for number of image sina row .....we are taking ait as two


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(![self.collectionView.collectionViewLayout isKindOfClass:[FBLikeLayout class]]){
        FBLikeLayout *layout = [FBLikeLayout new];
        layout.minimumInteritemSpacing = 4;
        layout.singleCellWidth = (MIN(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)-self.collectionView.contentInset.left-self.collectionView.contentInset.right-8)/2.0;
        layout.maxCellSpace = 3;
        layout.forceCellWidthForMinimumInteritemSpacing = YES;
        layout.fullImagePercentageOfOccurrency = 50;
        self.collectionView.collectionViewLayout = layout;
        
        [self.collectionView reloadData];
    }
}


#pragma mark- ***** TableView Delegate Methods ***********---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag==111) {
        if (self.flowArray.count) {
            FFFanzoneModelInfo *tempInfo = [self.flowArray firstObject];
            return tempInfo.categoryArray.count;
        }else
            return 0;
    }
    else {
        if (self.vsArray.count) {
            return _sourceArray.count+1;
        }
        return _sourceArray.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//
{
    if ([tableView isEqual:filterTableView]) {
        FFCategoryTableViewCell * cell = (FFCategoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:categoryCellID];

        FFFanzoneModelInfo *tempInfo = [self.flowArray firstObject];
        FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
        cell.categoryTitleLabel.text = [NSString stringWithFormat:@"          %@", tempCatInfo.categoryName];
        return cell;
    }
    else {
        
        if (self.vsArray.count && indexPath.row == 0) {
            FFVursesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            cell.backgroundColor = [UIColor whiteColor];
            
            FFFanzoneModelInfo *tempFirstInfo = [self.vsArray firstObject];
            FFFanzoneModelInfo *tempFirstImageInfo = [tempFirstInfo.userPostArray firstObject];
            
            FFFanzoneModelInfo *tempSecondInfo = [self.vsArray lastObject];
            FFFanzoneModelInfo *tempSecondImageInfo = [tempSecondInfo.userPostArray firstObject];
            
            [cell.photoImageView1 sd_setImageWithURL:[NSURL URLWithString:tempFirstImageInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
            [cell.profileImageView1 sd_setImageWithURL:[NSURL URLWithString:tempFirstInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.descriptionLabel1.text = tempFirstInfo.fanzoneDescription;
            cell.firstLikeVsLabel.text = tempFirstInfo.likeCount;
            cell.firstCommentVsLabel.text = tempFirstInfo.commentCount;
            cell.nameLabel1.text = tempFirstInfo.guestUserName;
            cell.stylePointLabel1.text = [NSString stringWithFormat:@"(%@) Style points",tempFirstInfo.stylePoints];
            [cell.photoImage2Btn addTarget:self action:@selector(photoFirstButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [cell.photoImageView2 sd_setImageWithURL:[NSURL URLWithString:tempSecondImageInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
            [cell.profileImageView2 sd_setImageWithURL:[NSURL URLWithString:tempSecondInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.descriptionLabel2.text = tempSecondInfo.fanzoneDescription;
            cell.secondVsLikeLabel.text = tempSecondInfo.likeCount;
            cell.secondVsCommentLabel.text = tempSecondInfo.commentCount;
            cell.nameLabel2.text = tempSecondInfo.guestUserName;
            cell.stylePointLabel2.text = [NSString stringWithFormat:@"(%@) Style points",tempSecondInfo.stylePoints];
            [cell.photoImage1Btn addTarget:self action:@selector(photoSecondButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
             UITapGestureRecognizer * tapOnProfileOne =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImageOnetapped:)];
            cell.profileImageView1.userInteractionEnabled  = YES;
            [cell.profileImageView1 addGestureRecognizer:tapOnProfileOne];
             UITapGestureRecognizer * tapOnProfileTwo =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImageTwotapped:)];
            cell.profileImageView2.userInteractionEnabled  = YES;
            [cell.profileImageView2 addGestureRecognizer:tapOnProfileTwo];
            
            return cell;
            
        }else {
            FFFanzoneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"singleCell"];
            cell.backgroundColor = [UIColor whiteColor]; //
            
            NSLog(@"%ld",(long)indexPath.row);
            
            FFFanzoneModelInfo *tempInfo = [_sourceArray objectAtIndex:(self.vsArray.count)?indexPath.row-1:indexPath.row];
            FFFanzoneModelInfo *userTempInfo = [tempInfo.userPostArray firstObject];
            if (![userTempInfo.img_type isEqualToString:@"landscape"]) {
                FFPortraitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"portrait"];
                cell.backgroundColor = [UIColor whiteColor];
                [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:userTempInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
                [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                cell.profileImageView.tag = indexPath.row;
                cell.descriptionLabel.text = tempInfo.fanzoneDescription;
                UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImagetapped:)];
                cell.profileImageView.userInteractionEnabled  = YES;
                cell.commentCount.text = tempInfo.commentCount;
                cell.nameLabel.text = tempInfo.guestUserName;
                cell.stylePointLabel.text = [NSString stringWithFormat:@"(%@) Style points",tempInfo.stylePoints];
                cell.likeCount.text = tempInfo.likeCount;
                [cell.profileImageView addGestureRecognizer:tap];
                cell.photoImageBtn.tag = indexPath.row + 100;
                [cell.photoImageBtn addTarget:self action:@selector(postDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            
            [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:userTempInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
            
            [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            cell.profileImageView.tag = indexPath.row;
            cell.descriptionLabel.text = tempInfo.fanzoneDescription;
            UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImagetapped:)];
            cell.profileImageView.userInteractionEnabled  = YES;
            cell.commentCount.text = tempInfo.commentCount;
            cell.nameLabel.text = tempInfo.guestUserName;
            cell.stylePointLabel.text = [NSString stringWithFormat:@"(%@) Style points",tempInfo.stylePoints];
            cell.likeCount.text = tempInfo.likeCount;
            [cell.profileImageView addGestureRecognizer:tap];
            cell.photoImageBtn.tag = indexPath.row + 100;
            [cell.photoImageBtn addTarget:self action:@selector(postDetailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideFilterView];
    
    if (tableView.tag == 111) {
        FFFanzoneModelInfo *tempInfo = [_flowArray firstObject];
        FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
        flowId = tempCatInfo.categoryID;
        headerLabel.text = tempCatInfo.categoryName;
        headerImage1.hidden = YES;
        [self makeWebApiCallForGetFanzonePost:@"1"];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==111)
        return 45.0;
    NSLog(@"%ld",(long)indexPath.row);
    FFFanzoneModelInfo *tempInfo;
    
    if (self.vsArray.count){
        if (indexPath.row != 0) {
            tempInfo = [_sourceArray objectAtIndex:indexPath.row-1];
        }
    }
    else
        tempInfo = [_sourceArray objectAtIndex:indexPath.row];
    FFFanzoneModelInfo *userTempInfo = [tempInfo.userPostArray firstObject];
    if (self.vsArray.count && indexPath.row == 0) {
        return 295.0;
    }
    else if(![userTempInfo.img_type isEqualToString:@"landscape"]) {
        return 400;
    }
    return ((indexPath.row %2 == 0)? 295.0 : 307.0);
}

-(void)hideFilterView
{
    filterView.frame = CGRectMake(0, -200, [UIScreen mainScreen].bounds.size.width, 150);
}

-(void)dropdownBtnClicked:(id)button
{
    
    if (filterView.frame.origin.y!=65) {
        [UIView transitionWithView:filterView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            filterView.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 150);
        }completion:nil];
    }
    else
    {
        [self hideFilterView];
    }
    
}


#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    
    if(![scrollView isEqual:filterTableView]) {
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 10.0) {
            if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
                isLoading = NO;
                
                [self makeWebApiCallForGetFanzonePost:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
                
            }
        }
    }
}


#pragma mark-
#pragma mark IBAction Methods-

-(void)postDetailBtnClicked:(UIButton *)sender//
{
    NSLog(@"%ld",(long)sender.tag);
    FFFanzoneModelInfo *tempInfo = [_sourceArray objectAtIndex:(self.vsArray.count)?sender.tag-101:sender.tag-100];
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.postId = tempInfo.publishId;
    detail.delegate = self;
    detail.fanzoneModal = tempInfo;
    [self.navigationController pushViewController:detail animated:YES];
}

-(IBAction)chatBtnClicked:(id)sender
{
    FFDirectMessageViewController * controller = (FFDirectMessageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFDirectMessageViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)profileBtnClicked:(id)sender//
{
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = YES;
    [self.navigationController pushViewController:profile animated:NO];
    
}

-(IBAction)editorButtonClicked:(id)sender//
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

-(IBAction)fashionBtnClicked:(id)sender//
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
-(IBAction)caneraBtnClicked:(id)sender//FFCameraViewController
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
-(IBAction)exploreBtnClicked:(id)sender//
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
-(void)profileImagetapped:(UITapGestureRecognizer*)gesture
{
    UIImageView * view = (UIImageView *)gesture.view;
    NSInteger indexTapped = view.tag;
    FFFanzoneModelInfo *tempInfo = [_sourceArray objectAtIndex:indexTapped];
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.concernUser_id = tempInfo.postAddUserId;
    [self.navigationController pushViewController:profile animated:NO];
    
}
- (void)profileImageOnetapped:(UIGestureRecognizer *)gesture {
    
    FFFanzoneModelInfo *tempInfo = [self.vsArray firstObject];
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.concernUser_id = tempInfo.postAddUserId;
    [self.navigationController pushViewController:profile animated:NO];
    
}

- (void)profileImageTwotapped:(UIGestureRecognizer *)gesture {
    
    FFFanzoneModelInfo *tempInfo = [self.vsArray lastObject];
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.concernUser_id = tempInfo.postAddUserId;
    [self.navigationController pushViewController:profile animated:NO];
    
}

#pragma mark - Selector Method
-(void)refreshFanzoneTable {
    
    [self.refreshControl endRefreshing];
    [self makeWebApiCallForGetFanzonePost:@"1"];
}

- (void)photoFirstButtonAction:(UIButton *)sender {
    
    FFFanzoneModelInfo *tempInfo = [self.vsArray firstObject];
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.postId = tempInfo.publishId;
    detail.delegate = self;
    detail.fanzoneModal = tempInfo;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)photoSecondButtonAction:(UIButton *)sender {
    
    FFFanzoneModelInfo *tempInfo = [self.vsArray lastObject];
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.postId = tempInfo.publishId;
    detail.delegate = self;
    detail.fanzoneModal = tempInfo;
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - Custom Delegate Method

- (void)callFanzoneApi {
    
    [self makeWebApiCallForGetFanzonePost:@"1"];
}


#pragma mark - Helper Method

- (void)makeWebApiCallForGetFanzonePost:(NSString*)pageNumber {
    
    [self showLoader];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetFanzone forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:flowId forKey:KFlowID];
    [dictRequest setValue:pageNumber forKey:KPageNumber];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            if (strResponseCode.integerValue == 200) {
                NSArray *tempData = [response objectForKeyNotNull:kPostList expectedObj:[NSArray array]];
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [_sourceArray removeAllObjects];
                }
                for (NSDictionary *tempDict in tempData) {
                    [_sourceArray addObject:[FFFanzoneModelInfo fanzoneListFromResponse:tempDict]];
                }
                
                [self.vsArray removeAllObjects];
                NSArray *vsData = [response objectForKeyNotNull:kVsPost expectedObj:[NSArray array]];
                for (NSDictionary *tempDict in vsData) {
                    [self.vsArray addObject:[FFFanzoneModelInfo profilePostResponse:tempDict]];
                }
                
                isLoading =YES;
                [self.fanzoneTableView reloadData];
            }else{
                [_sourceArray removeAllObjects];
                [self.fanzoneTableView reloadData];
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
                [filterTableView reloadData];
                
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
