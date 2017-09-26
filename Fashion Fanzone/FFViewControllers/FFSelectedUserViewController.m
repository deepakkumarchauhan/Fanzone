//
//  FFSelectedUserViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 19/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFSelectedUserViewController.h"
#import "FFSelectedUserTableViewCell.h"
#import "Macro.h"

static NSString *cellId = @"SelectedUserCellId";

@interface FFSelectedUserViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *connectionsArray;
    NSMutableArray *filterArray;

}

@property (strong, nonatomic) IBOutlet UITableView *tebleView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFSelectedUserViewController


#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialMethod];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

#pragma mark - Custom Method

- (void)initialMethod {
    
    // Alloc Array
    connectionsArray = [NSMutableArray array];
    filterArray = [NSMutableArray array];

    
    self.tebleView.estimatedRowHeight = 35.0;
    
    [self makeWebApiCallForGetUserList];
}


#pragma mark - UISearchBar Action


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length) {
        [connectionsArray removeAllObjects]; // clearing filter array
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF.displayName contains[c] %@",searchText]; // Creating filter condition
        connectionsArray = [NSMutableArray arrayWithArray:[filterArray filteredArrayUsingPredicate:filterPredicate]];
        
        [self.tebleView reloadData];// filtering result
    }
    
}


#pragma mark - UItableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return connectionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    FFSelectedUserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    FFConnectionModal *modelInfo = [connectionsArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = modelInfo.displayName;
    if (modelInfo.isSelect)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    

    return cell;
}


#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFConnectionModal *modelInfo = [connectionsArray objectAtIndex:indexPath.row];
    modelInfo.isSelect = !modelInfo.isSelect;
    [self.tebleView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;;
}


#pragma mark - Selector Method
- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)doneButtonAction:(id)sender {
    
    NSMutableArray *userArray = [NSMutableArray array];
    
    for (FFConnectionModal *model in connectionsArray) {
        if (model.isSelect) {
            [userArray addObject:model];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate selectedUser:userArray :self.viewPermission];
    }];
}


#pragma mark - Memory Management Method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)makeWebApiCallForGetUserList {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiGetConnectionList forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                connectionsArray = [FFConnectionModal parseConenctionData:response];
                filterArray = [FFConnectionModal parseConenctionData:response];

                [self.tebleView reloadData];
                
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
