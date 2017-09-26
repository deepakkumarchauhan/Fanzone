//
//  FFInteractionHistoryViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFInteractionHistoryViewController.h"
#import "Macro.h"

static NSString *cellId = @"interactionHistoryCellId";

@interface FFInteractionHistoryViewController ()<UITextFieldDelegate> {
    
    NSMutableArray *historyArray;
    BOOL isLoading;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) PAPagination *pagination;

@end

@implementation FFInteractionHistoryViewController


#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}


#pragma mark - Custom Method
-(void)initialSetUp {
    
    // Alloc Array
    historyArray = [NSMutableArray array];
    
    
    // Alloc Pagination Modal
    self.pagination = [[PAPagination alloc] init];
    self.pagination.pageNo = @"1";
    
    [self apiToFetchIntractionHistory:@"1"];
}


#pragma mark - UICollectionView Datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return historyArray.count;
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FFInteractionHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    FFFanzoneModelInfo *modelInfo = [historyArray objectAtIndex:indexPath.item];
    FFFanzoneModelInfo *modelUserPostInfo = [modelInfo.userPostArray firstObject];
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:modelUserPostInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    cell.nameLabel.text = modelInfo.fanzoneDescription;
    
    return cell;
}


#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FFPostDetailViewController * detail = (FFPostDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFPostDetailViewController"];
    
    FFFanzoneModelInfo *modelInfo = [historyArray objectAtIndex:indexPath.item];
    detail.fanzoneModal = modelInfo;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width/3)-1, ([[UIScreen mainScreen] bounds].size.width/3)-1);
}

#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
            isLoading = NO;
            
            [self apiToFetchIntractionHistory:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
            
        }
    }
}


#pragma mark - UIButton Action
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Helper Method

-(void)apiToFetchIntractionHistory:(NSString *)pageNumber
{
    [self showLoader];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiInteractionHistory forKey:KAction];
    [dictRequest setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:KUserId]] forKey:KUserId];
    [dictRequest setValue:pageNumber forKey:KPageNumber];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];

        if (suceeded)
        {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200)
            {
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [historyArray removeAllObjects];
                }
                
                NSArray *userPostArray = [response objectForKeyNotNull:KInteractionList expectedObj:[NSArray array]];
                
                for (NSDictionary *dict in userPostArray) {
                    [historyArray addObject:[FFFanzoneModelInfo profilePostResponse:dict]];
                }
                
                isLoading =NO;
                [self.collectionView reloadData];
                
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
