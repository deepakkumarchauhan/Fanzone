//
//  FFFashionViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 24/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFFashionViewController.h"
#import "FFUtility.h"
#import "FBLikeLayout.h"
#import "FFFashionCollectionViewCell.h"
#import "AlertView.h"
#import "FFFanzoneModelInfo.h"
#import "FFImportContactViewController.h"


@interface FFFashionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate,FFContactDelegate>
{
    UILabel * lbl;
    UIImageView * headerImage1;
    UIImageView * headerImage;
    UIButton * btn;
    UIButton * profileBtn;
    BOOL isLoading;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView * stylePointView;
@property (strong, nonatomic) IBOutlet UITextField * stylePoinField;
@property (nonatomic, strong) NSMutableArray * sourceArray;
@property (strong, nonatomic) PAPagination *pagination;
@property (nonatomic, strong) UIRefreshControl * refreshControl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIView *stylePointSubView;

-(IBAction)sendINVITIVE:(id)sender;
@end

@implementation FFFashionViewController

-(void)showPopOver{
    _stylePointView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _stylePointView.hidden = YES;
    
    self.collectionView.contentInset = UIEdgeInsetsMake(-20, 4, 4, 4);
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
    
    
    // Add Pull To Refresh On Fanzone Table
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(editorialCollectionView) forControlEvents:UIControlEventValueChanged];
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.stylePointView addGestureRecognizer:singleFingerTap];

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
    // [self.navigationController.navigationBar addSubview:headerImage1];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 35)];
    lbl.text = @"EDITORIAL";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font =  AppFont(23) ;   ///[UIFont systemFontOfSize:25];
    [self.navigationController.navigationBar addSubview:lbl];
    
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self layoutNavigationBar];
    NSInteger appStartCount = [[NSUserDefaults standardUserDefaults] integerForKey:KAppStartCount];   //check for pop every 5th time app lounches
    if (appStartCount==5) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:KAppStartCount];
        [[NSUserDefaults  standardUserDefaults] synchronize];
        [self performSelector:@selector(showPopOver) withObject:nil afterDelay:1.5];
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    _pagination = [[PAPagination alloc]init];
    _pagination.pageNo = @"1";
    
    _sourceArray = [[NSMutableArray alloc]init];
    [self makeWebApiCallForGetEidtorial:_pagination.pageNo];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [lbl removeFromSuperview];
    [headerImage removeFromSuperview];
    [headerImage1 removeFromSuperview];
    [btn removeFromSuperview];
    [profileBtn removeFromSuperview];
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
    } else {
        //[self.collectionView.collectionViewLayout invalidateLayout];
    }
    
}


-(NSString *) sampleImagesBundlePath{
    return [[NSBundle mainBundle] pathForResource:@"SampleImages" ofType:@"bundle"];
}

#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 30);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 30);
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if(!view)
        view = [[UICollectionReusableView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFFashionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fashionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
FFFanzoneModelInfo *obj_detail = [_sourceArray objectAtIndex:indexPath.row];
    
    [cell.storyImageView sd_setImageWithURL:[NSURL URLWithString:obj_detail.bannerImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:obj_detail.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
cell.titleLabel.text = obj_detail.fanzoneTitle;
    cell.titleLabel.text = [cell.titleLabel.text uppercaseString];
    [cell.contentView bringSubviewToFront:cell.profileImageView];
    
    cell.profileImageView.userInteractionEnabled = YES;
    cell.profileImageView.tag = indexPath.row +1000;
    UITapGestureRecognizer * tap =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImagetapped:)];
    
    [cell.profileImageView addGestureRecognizer:tap];
    
    
    
    
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  FFFanzoneModelInfo *obj_detail = [_sourceArray objectAtIndex:indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FFFanzoneModelInfo *obj_detail = [_sourceArray objectAtIndex:indexPath.row];

     FFEditorialDetailViewController * profile = (FFEditorialDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFEditorialDetailViewControllerID"];
    profile.obj_detail = obj_detail;
    [self.navigationController pushViewController:profile animated:YES];
   
}


#pragma mark -  UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *textFieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textFieldString.length > 60)
        return NO;
    
    return YES;
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint p = [recognizer locationInView:self.view];
    if (!(CGRectContainsPoint(self.stylePointSubView.layer.frame, p)))
        self.stylePointView.hidden = YES;
}



#pragma mark - Selector Method
-(void)editorialCollectionView {
    
    [self.refreshControl endRefreshing];
    [self makeWebApiCallForGetEidtorial:@"1"];
}


#pragma mark IBAction Methods

-(IBAction)sendINVITIVE:(id)sender
{
    [self.view endEditing:YES];
    if (!TRIM_SPACE(self.stylePoinField.text).length) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter email address." onController:self];
    }
    else if (![TRIM_SPACE(self.stylePoinField.text) isValidEmail]) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid email address." onController:self];
    }else {
        [self makeWebApiCallSendInvitation];
    }
}


-(IBAction)chatBtnClicked:(id)sender//profileBtnClicked
{
      [self performSegueWithIdentifier:@"messageList" sender:self];
   
}
-(IBAction)profileBtnClicked:(id)sender//
{
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = YES;
    [self.navigationController pushViewController:profile animated:NO];
}
-(IBAction)dropdownBtnClicked:(id)sender
{
    
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

-(IBAction)caneraBtnClicked:(id)sender//
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

- (IBAction)importContactButtonAction:(id)sender {
    
    FFImportContactViewController *objVc = (FFImportContactViewController *)[[FFImportContactViewController alloc]initWithNibName:@"FFImportContactViewController" bundle:nil];
    objVc.delegate = self;
    [self.navigationController pushViewController:objVc animated:YES];
    
}

- (void)selectionButtonClicked:(NSString *)emailAddress{
    
    self.stylePoinField.text = emailAddress;
}




#pragma mark-
#pragma mark ProfielImage Tapped--

-(void)profileImagetapped:(UITapGestureRecognizer*)gesture  //open user profile
{
}

#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
            isLoading = NO;
            
                [self makeWebApiCallForGetEidtorial:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
            
        }
    }
}


#pragma mark - Helper Method

- (void)makeWebApiCallSendInvitation {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiSendInvitation forKey:KAction];
    [dictRequest setValue:self.stylePoinField.text forKey:KEmail];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Success!" andMessage:strResponseMessage onController:self];
                self.stylePointView.hidden = YES;
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}

- (void)makeWebApiCallForGetEidtorial :(NSString *)pageNumber {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiEditorial forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:pageNumber forKey:KPageNumber];
    [dictRequest setValue:@"10" forKey:KPageSize];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [_sourceArray removeAllObjects];
                }
                
                if (response && [response isKindOfClass:[NSDictionary class]]) {
                    NSArray *arrayEditorial = [response objectForKeyNotNull:KEditorail expectedObj:[NSArray array]];
                    if (arrayEditorial && [arrayEditorial isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dict_data in arrayEditorial) {
                            [_sourceArray addObject:[FFFanzoneModelInfo fanzoneGetEditorialFromResponse:dict_data]];
                        }
                        isLoading =YES;
                        [self.collectionView reloadData];
                    }
                }
                
                
            }else{
                [_sourceArray removeAllObjects];
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [_sourceArray removeAllObjects];
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
