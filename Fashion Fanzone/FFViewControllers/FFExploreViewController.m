//
//  FFExploreViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFExploreViewController.h"
#import "FFExploreCollectionViewCell.h"
#import "FFUtility.h"
#import "FFExploreSearchListView.h"
#import "AlertView.h"


@interface FFExploreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate>
{
    UIImageView * headerImage;
    UIButton * btn;
    UIButton * profileBtn;
    NSMutableArray * recentSearchdataArray;
    NSArray * suggetionDataArray;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField * searchTextField;
@property (weak, nonatomic) IBOutlet UITableView * searchTable;
@property (nonatomic, strong) NSMutableArray * sourceArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) PAPagination *pagination;
@property (strong, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation FFExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Explore");
    
    self.searchTable.hidden = YES;
    self.searchTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.collectionView.contentInset = UIEdgeInsetsMake(-10, 12  , 10, 10);
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
    
    UITapGestureRecognizer * tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    self.view.userInteractionEnabled = YES;
    tapp.delegate = self;
   // [self.view addGestureRecognizer:tapp];
    
    self.bottomView.hidden = YES;
    _sourceArray = [[NSMutableArray alloc] init];
    _pagination = [[PAPagination alloc]init];
    _pagination.pageNo = @"1";
    [self makeWebApiCallForGetExplore:_pagination.pageNo];

}


-(void)viewTap:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:NO];
    [self.searchTextField resignFirstResponder];
}
#pragma mark-
#pragma mark UItapGesture Delegate  Methods---
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer
                                                                                                                       *)otherGestureRecognizer
{  return YES;
}

#pragma mark- LayoutNavigation Controller---


-(void)layoutNavigationBar
{
     headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(120, 0, [UIScreen mainScreen].bounds.size.width-240, 30)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    
     btn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(4, 0, 35, 35) andBackImage:[UIImage imageNamed:@"chat"]];
    [btn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
   
    profileBtn.layer.cornerRadius = profileBtn.layer.frame.size.width/2;
    profileBtn.layer.masksToBounds = YES;
    
    NSString *str = [NSUSERDEFAULT valueForKey:KUserImage];
    profileBtn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, 1, 40, 40) andBackImage:[UIImage imageNamed:@"placeholder"]];
    [profileBtn sd_setImageWithURL:[NSURL URLWithString:str] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [profileBtn addTarget:self action:@selector(profileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:profileBtn];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [profileBtn removeFromSuperview];
    [btn removeFromSuperview];
}


#pragma mark- TextField Delegates---
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"Find Fashion"]) {
        textField.text = @"";
    }
    self.bottomView.hidden = YES;

    NSArray * arry = [[NSUserDefaults standardUserDefaults] valueForKey:RecentSearchObjectkey];
    [recentSearchdataArray removeAllObjects];
    recentSearchdataArray = [NSMutableArray arrayWithArray:arry];
    [self.searchTable reloadData];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   /// [self searchBtnClicked:nil];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     self.searchTable.hidden = NO;
    return YES;
}

#pragma mark--- *********  Searching Zone ***********

-(void)doSearchingForText:(NSString *)searchText
{
    
}


#pragma mark---- ****** Searching Table Delegates *********** ///
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Recent";
    }
     return @"Suggestions";
   
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
   
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor darkGrayColor]];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (recentSearchdataArray.count>0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (recentSearchdataArray.count>0) {
        if (section==0) {
           return  recentSearchdataArray.count;
        }
        if (section==1) {
            return  suggetionDataArray.count;
        }
        
    }
    return  suggetionDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFExploreSearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"searchTableCell"];
    if (indexPath.section==0) {
        cell.crossBtn.tag = indexPath.row;
        cell.crossBtn.hidden = NO;
        [cell.crossBtn addTarget:self action:@selector(searchCrossBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.symbolImageView.image = [UIImage imageNamed:@"time"];
        cell.resultLabel.text = recentSearchdataArray[indexPath.row];
    }
    else
    {
        cell.crossBtn.hidden = YES;
        cell.symbolImageView.image = [UIImage imageNamed:@"search"];
        cell.resultLabel.text = suggetionDataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.view endEditing:YES];

    self.searchTable.hidden = YES;
    FFExploreSearchListView *subView = [[FFExploreSearchListView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.bottomView.frame.size.height)];//self.searchTable.frame
    
    [subView callSearchApi:(indexPath.section == 0)?recentSearchdataArray[indexPath.row]:suggetionDataArray[indexPath.row] withViewController:self];
    
    self.searchTextField.text = (indexPath.section == 0)?recentSearchdataArray[indexPath.row]:suggetionDataArray[indexPath.row];
    
    [subView setBackgroundColor:[UIColor blackColor]];
    [self.bottomView addSubview:subView];
    self.bottomView.hidden = NO;
    [self.view bringSubviewToFront:self.bottomView];

}

-(void)searchCrossBtnClicked:(UIButton*)crossBtn
{
    NSInteger index = crossBtn.tag;
    if (recentSearchdataArray.count>index) {
        [recentSearchdataArray removeObjectAtIndex:index];
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchdataArray forKey:RecentSearchObjectkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.searchTable reloadData];
}



#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;
    //return 10;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 10);
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if(!view)
        view = [[UICollectionReusableView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    FFFanzoneModelInfo *modelInfo = [_sourceArray objectAtIndex:indexPath.item];
    
    FFFanzoneModelInfo *modelImageInfo = [modelInfo.userPostArray firstObject];

    [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:modelImageInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];

    cell.storyNameLabel.text = modelInfo.fanzoneDescription;
    cell.cellBtn.tag = indexPath.item;
    [cell.cellBtn addTarget:self action:@selector(exploreItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    return CGSizeMake(self.collectionView.frame.size.width-10, 150);
}

 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
 {
 return 10; // This is the minimum inter item spacing, can be more
 }
 
 
 
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
 {
 return 5;
 }
 - (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 return UIEdgeInsetsMake(10, 20, 20, 20);
 }

-(void)exploreItemClicked:(UIButton*)clickedBtn
{
    NSInteger tag = clickedBtn.tag;
    
    FFFanzoneModelInfo *modelInfo = [_sourceArray objectAtIndex:tag];
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    detail.fanzoneModal = modelInfo;
    detail.postId = modelInfo.publishId;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark-
#pragma mark IBAction Methods-

-(IBAction)searchBtnClicked:(id)sender
{

    [self.view endEditing:YES];
    NSString * searchedText = _searchTextField.text;
    if (searchedText.length>0) {
        NSArray * arry = [[NSUserDefaults standardUserDefaults] valueForKey:RecentSearchObjectkey];
        [recentSearchdataArray removeAllObjects];
        recentSearchdataArray = [NSMutableArray arrayWithArray:arry];
        if (recentSearchdataArray.count>=5) {
            [recentSearchdataArray replaceObjectAtIndex:0 withObject:searchedText];
        }
        else
        {
            [recentSearchdataArray addObject: searchedText];
        }
        [[NSUserDefaults standardUserDefaults] setObject:recentSearchdataArray forKey:RecentSearchObjectkey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.searchTable reloadData];
    }
    FFExploreSearchListView *subView = [[FFExploreSearchListView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, self.bottomView.frame.size.height)];//self.searchTable.frame
    [subView callSearchApi:searchedText withViewController:self];
    [subView setBackgroundColor:[UIColor blackColor]];
    [self.bottomView addSubview:subView];
    self.bottomView.hidden = NO;
    [self.view bringSubviewToFront:self.bottomView];
    
    
}
-(IBAction)chatBtnClicked:(id)sender//profileBtnClicked
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
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(IBAction)cameraBtnClicked:(id)sender//
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



#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
            isLoading = NO;
            
            [self makeWebApiCallForGetExplore:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
            
        }
    }
}



- (void)makeWebApiCallForGetExplore :(NSString *)pageNumber {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiExplore forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:pageNumber forKey:KPageNumber];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    NSArray *arrayEditorial = [response objectForKeyNotNull:KExplores expectedObj:[NSArray array]];
                    if (arrayEditorial && [arrayEditorial isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dict_data in arrayEditorial) {
                            [_sourceArray addObject:[FFFanzoneModelInfo fanzoneGetExploreFromResponse:dict_data]];
                        }
                        isLoading =YES;
                        [self.collectionView reloadData];
                    }
                }
                
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
