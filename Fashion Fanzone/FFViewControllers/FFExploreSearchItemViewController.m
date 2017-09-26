//
//  FFExploreSearchItemViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 09/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFExploreSearchItemViewController.h"
#import "FFFanzoneTableViewCell.h"
#import "FFEditorialExploreTableViewCell.h"
#import "FFEditorialSearchCollectionViewCell.h"
#import "Macro.h"

static NSString *cellIUserConnectdentifier = @"connectionUserCellId";
static NSString *cellEditorialIdentifier = @"exploreEditorialTableCellId";
static NSString *cellAllPostsIdentifier = @"singleCell";

@interface FFExploreSearchItemViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *sourceArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FFExploreSearchItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sourceArray = [NSMutableArray array];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 300.0;
    }else if(indexPath.section == 1){
        return 100;
    }
    else
        return ((indexPath.row %2 == 0)? 295.0 : 307.0);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
    
    if (section == 0) {
        return tempModel.editorialArray.count;
    }else if(section == 1){
        return tempModel.userDetailArray.count;
    }
    else
        return tempModel.userPostArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
    
    if (indexPath.section == 0) {
        
        FFEditorialExploreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellEditorialIdentifier];
        [cell.exploreCollectionView registerNib:[UINib nibWithNibName:@"FFEditorialSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"searchExploreCollectionViewCellId"];
        cell.exploreCollectionView.delegate = self;
        cell.exploreCollectionView.dataSource = self;
        
        return cell;
    }
    else if (indexPath.section == 1) {
        
        FFConnectUserTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellIUserConnectdentifier];
        FFFanzoneModelInfo *tempInfoModel = [tempModel.userDetailArray objectAtIndex:indexPath.row];
        FFFanzoneModelInfo *tempImageModel = [tempInfoModel.userPostArray firstObject];
        userCell.nameLabel.text = tempInfoModel.userName;
        userCell.stylePointsLabel.text = [NSString stringWithFormat:@"(%@) Style Points",tempImageModel.stylePoints];
        [userCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        
        return userCell;
    }
    else  {
        
        FFFanzoneTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:cellAllPostsIdentifier];
        FFFanzoneModelInfo *tempInfoModel = [tempModel.userPostArray objectAtIndex:indexPath.row];
        FFFanzoneModelInfo *tempImageModel = [tempInfoModel.userPostArray firstObject];
        [userCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:tempImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
        [userCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        userCell.profileImageView.tag = indexPath.row;
        userCell.descriptionLabel.text = tempInfoModel.fanzoneDescription;
        userCell.profileImageView.userInteractionEnabled  = YES;
        userCell.commentCount.text = tempInfoModel.commentCount;
        userCell.nameLabel.text = tempInfoModel.guestUserName;
        userCell.stylePointLabel.text = [NSString stringWithFormat:@"(%@) Style points",tempInfoModel.stylePoints];
        userCell.likeCount.text = tempInfoModel.likeCount;
       userCell.photoImageBtn.tag = indexPath.row + 100;
   
        return userCell;
    }
    
    
    return 0;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView;
    sectionHeaderView = [[UIView alloc] initWithFrame:
                         CGRectMake(0, 0, tableView.frame.size.width, 45)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:
                            CGRectMake(sectionHeaderView.frame.origin.x + 22,sectionHeaderView.frame.origin.y+5, sectionHeaderView.frame.size.width, sectionHeaderView.frame.size.height)];
    
    headerLabel.backgroundColor = [UIColor clearColor];
    [sectionHeaderView addSubview:headerLabel];
    switch (section) {
        case 0:
            headerLabel.text = @"Editorial";
            headerLabel.textAlignment = NSTextAlignmentLeft;
            [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
            headerLabel.textColor = [UIColor blackColor];
            return sectionHeaderView;
        case 1:
            headerLabel.text = @"Members";
            headerLabel.textAlignment = NSTextAlignmentLeft;
            [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
            headerLabel.textColor = [UIColor blackColor];
            return sectionHeaderView;
        case 2:
            headerLabel.text = @"Posts";
            headerLabel.textAlignment = NSTextAlignmentLeft;
            [sectionHeaderView setBackgroundColor: [UIColor clearColor]];
            headerLabel.textColor = [UIColor blackColor];
            return sectionHeaderView;
        default:
            break;
    }
    return sectionHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}



#pragma mark - UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
    return tempModel.editorialArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFanzoneModelInfo *tempModel = [sourceArray firstObject];
    FFEditorialSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchExploreCollectionViewCellId" forIndexPath:indexPath];
    FFFanzoneModelInfo *tempInfoModel = [tempModel.editorialArray objectAtIndex:indexPath.item];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    [cell.profileImageView sd_setImageWithURL:[NSURL URLWithString:tempInfoModel.profileImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
    cell.nameLabel.text = tempInfoModel.userName;
    
    
    return cell;
}



-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width/3)-1, ([[UIScreen mainScreen] bounds].size.width/2)-1);
}


#pragma mark - Service Helper Method

- (void)makeWebApiCallForGetExplore :(NSString *)pageNumber {
    
   NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiSearchPost forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:@"f" forKey:KSearchText];
    [dictRequest setValue:pageNumber forKey:KPageNumber];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
    if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            if (strResponseCode.integerValue == 200) {
                
             [sourceArray addObject:[FFFanzoneModelInfo fanzoneFetchExploreSearchFromResponse:response]];
                [self.tableView reloadData];
               // NSLog(@"%@",sourceArray);
            }
        }
    }];
}



@end
