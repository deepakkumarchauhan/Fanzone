//
//  FFOfferViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 28/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFOfferViewController.h"
#import "Macro.h"
#import "FFOfferTableViewCell.h"

static NSString *offerCellIdentifer = @"offerCellId";

@interface FFOfferViewController () {
    
    NSMutableArray *offerListArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIView *offerPointView;
@property (strong, nonatomic) IBOutlet UILabel *offerTitleLabel;

@end

@implementation FFOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.estimatedRowHeight = 45.0;
    offerListArray = [NSMutableArray array];
    self.offerPointView.hidden = YES;
    
    [self apiForOfferList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInviteButtonAction:(id)sender {
    self.offerPointView.hidden = YES;
}

- (IBAction)hideButtonAction:(id)sender {
    self.offerPointView.hidden = YES;
}
- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- UITable Delegate and DataSource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return offerListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFOfferTableViewCell *offerCell = [self.tableView dequeueReusableCellWithIdentifier:offerCellIdentifer];
    FFFanzoneModelInfo *tempInfo = [offerListArray objectAtIndex:indexPath.row];
    offerCell.titleOfferLabel.text = tempInfo.offerTitle;

    return offerCell;
}

#pragma mark -******************* UITableViewDelegate methods ****************-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FFFanzoneModelInfo *tempInfo = [offerListArray objectAtIndex:indexPath.row];
    self.offerTitleLabel.text = tempInfo.offerDescription;
    [self performSelector:@selector(showPopOver) withObject:nil afterDelay:.5];

}


-(void)showPopOver{
    _offerPointView.hidden = NO;
}


#pragma mark - Service Helper Method

-(void)apiForOfferList
{
     [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiOffer forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
          [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                NSArray *tempData = [response objectForKeyNotNull:kOffers expectedObj:[NSArray array]];

                for (NSDictionary *tempDict in tempData) {
                    [offerListArray addObject:[FFFanzoneModelInfo offerListResponse:tempDict]];
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
