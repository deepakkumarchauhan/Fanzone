//
//  FFStylelistViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFStylelistViewController.h"

@interface FFStylelistViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray * recentStypePointArray;
@property (nonatomic, strong) NSArray * stylePointGivenArray;
@property (nonatomic, strong) NSArray * recievedStylePointArray;
@end

@implementation FFStylelistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tbleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    NSLog(@"****** viewWillAppear ******");
    self.navigationController.navigationBar.hidden = NO;
    
    switch (self.index) {
        case 0:
        {
            [self fetchRecentstylePoints];
        };break;
        case 1:
        {
            [self fetchGivenStylePoints];
        };break;
        case 2:
        {
            [self fetchRecivedstylePoints];
        };break;
        default:
            break;
    }
    
}

#pragma mark-
#pragma mark TabelView Deelegate methods----



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.index) {
        case 0:return _recentStypePointArray.count;break;
        case 1:return _stylePointGivenArray.count;break;
        default:
            break;
    }
    return _recievedStylePointArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FFStylePointTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"stypepoint"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.index==0)
    {
        FFConnectionModal * modal = [_recentStypePointArray objectAtIndex:indexPath.row];
        NSString * stringText = [modal.message capitalizedString];
        NSString * bubstring = [[stringText componentsSeparatedByString:@"-"] objectAtIndex:0];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, bubstring.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        UIImage * img;
        switch ([modal.iconStatus integerValue]) {
            case 0:img=[UIImage imageNamed:@"follows"];break;
            case 1:img=[UIImage imageNamed:@"connected"];break;
            case 2:img=[UIImage imageNamed:@"reachedOut"];break;
            default:
                break;
        }
        cell.textlabel.attributedText = mat;
        [cell.messageImageView sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:img];
        cell.stylePointCount.text = modal.stylePointCount;
        cell.textlabel.font = AppFont(14);
        cell.stylePointCount.font = AppFont(15);
    }
    if(self.index==1)
    {
        FFConnectionModal * modal = [_stylePointGivenArray objectAtIndex:indexPath.row];
        NSString * stringText = [modal.message capitalizedString];
        NSString * bubstring = [[stringText componentsSeparatedByString:@"-"] objectAtIndex:0];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, bubstring.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        UIImage * img;
        switch ([modal.iconStatus integerValue]) {
            case 0:img=[UIImage imageNamed:@"follows"];break;
            case 1:img=[UIImage imageNamed:@"connected"];break;
            case 2:img=[UIImage imageNamed:@"reachedOut"];break;
            default:
                break;
        }
        cell.textlabel.attributedText = mat;
        [cell.messageImageView sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:img];
        cell.stylePointCount.text = modal.stylePointCount;
        cell.textlabel.font = AppFont(14);
        cell.stylePointCount.font = AppFont(15);
    }
    if(self.index==2)
    {
        FFConnectionModal * modal = [_recievedStylePointArray objectAtIndex:indexPath.row];
        NSString * stringText = [modal.message capitalizedString];
        NSString * bubstring = [[stringText componentsSeparatedByString:@"-"] objectAtIndex:0];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, bubstring.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        UIImage * img;
        switch ([modal.iconStatus integerValue]) {
            case 0:img=[UIImage imageNamed:@"follows"];break;
            case 1:img=[UIImage imageNamed:@"connected"];break;
            case 2:img=[UIImage imageNamed:@"reachedOut"];break;
            default:
                break;
        }
        cell.textlabel.attributedText = mat;
        [cell.messageImageView sd_setImageWithURL:[NSURL URLWithString:modal.profilePicture] placeholderImage:img];
        cell.stylePointCount.text = modal.stylePointCount;
        cell.textlabel.font = AppFont(14);
        cell.stylePointCount.font = AppFont(15);
    }
    
    
    
    
    
    return cell;
}
-(void)fetchRecentstylePoints
{
    if (_recentStypePointArray.count==0) {
        [self fireApiToGetRecentStylePoints];
        [_tbleView reloadData];
    }
}
-(void)fetchGivenStylePoints
{
    if (_stylePointGivenArray.count==0) {
        [self fireApiToGetGivenStylePoints];
        [_tbleView reloadData];
    }
}
-(void)fetchRecivedstylePoints
{
    if (_recievedStylePointArray.count==0) {
        [self fireApiToGetRecievedStylePoints];
        [_tbleView reloadData];
    }
}



#pragma mark-
#pragma mark FireApi To get Recent Style Points-



-(void)fireApiToGetRecentStylePoints//
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetRecentStylePointList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _recentStypePointArray = [FFConnectionModal parseRecentstylePointData:response];
                if(_recentStypePointArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
                [_tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
        }
    }];
}
#pragma mark-
#pragma mark FireApi To get Given Style Points-



-(void)fireApiToGetGivenStylePoints//getGivenStylePointsList
{
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetGivenStylePointList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _stylePointGivenArray = [FFConnectionModal parseGivenStylePointData:response];
                if(_stylePointGivenArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
                [_tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
        }
    }];
}
#pragma mark-
#pragma mark FireApi To get Received Style Points-



-(void)fireApiToGetRecievedStylePoints
{
    [self showLoader];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetRecivedStylePointList forKey:KAction];
    [dictRequest setValue:self.concernUser_id forKey:KUserId];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                _recievedStylePointArray = [FFConnectionModal parseRecievedStylePointData:response];
                if(_recievedStylePointArray.count==0)
                {
                    [[AlertView sharedManager]displayInformativeAlertwithTitle:KAlert andMessage:@"No data found." onController:self];
                }
                [_tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                [_tbleView reloadData];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            [_tbleView reloadData];
            
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
