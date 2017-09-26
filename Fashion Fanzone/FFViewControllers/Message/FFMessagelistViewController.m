//
//  FFMessagelistViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMessagelistViewController.h"
#import "FFMessageListTableCell.h"
#import "Macro.h"

@interface FFMessagelistViewController () {
    
    NSMutableArray *messageListArray;
    NSMutableArray *requestListArray;
    
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@end

@implementation FFMessagelistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Alloc Array
    messageListArray = [NSMutableArray array];
    requestListArray = [NSMutableArray array];
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableview addSubview:_refreshControl];
    [self makeWebApiCallForGetMessageList];
    // Do any additional setup after loading the view.
}
- (void)refreshTable {
    //TODO: refresh your data
    [_refreshControl endRefreshing];
    
    [self makeWebApiCallForGetMessageList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UITableview Delegate methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_index==1) {
        return requestListArray.count;
    }
    return messageListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFMessageListTableCell *cell = (FFMessageListTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor * color = [UIColor redColor];
    FFMessageModal * modelinfo = nil;
    if (_index==1) {
        modelinfo = [requestListArray objectAtIndex:indexPath.row];
    }
    else
    {
        modelinfo = [messageListArray objectAtIndex:indexPath.row];
    }
    FFMessageModal *modelChatInfo = [modelinfo.chatArray firstObject];
    if ([modelChatInfo.isRead isEqualToString:@"1"]) {
        color = [UIColor blackColor];
    }
    cell.indicatorArraowImageView.image = [UIImage imageNamed:@"chatBack"];
    NSString * sender = [NSString stringWithFormat:@"%@", modelChatInfo.senderID];
    NSString * selfUser = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    if ([sender isEqualToString:selfUser]) {
        cell.indicatorArraowImageView.image = [UIImage imageNamed:@"chatForward"];
        color = [UIColor blackColor];
    }
    cell.titleLabel.text = modelinfo.displayName;
    [cell.fromUserImage sd_setImageWithURL:[NSURL URLWithString:modelinfo.userProfileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.toUserImage sd_setImageWithURL:[NSURL URLWithString:modelinfo.imageUrl] placeholderImage:nil];
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, mat.length)];
    cell.titleLabel.attributedText = mat;
    cell.descriptionsLabel.text = modelinfo.textMessage;
    if (modelChatInfo.message.length==0) {
        cell.descriptionsLabel.text = @"Image";
    }else
        cell.descriptionsLabel.text = modelChatInfo.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFMessageModal *modelinfo;
    if (_index==1) {
        modelinfo = [requestListArray objectAtIndex:indexPath.row];
    }
    else
    {
         modelinfo = [messageListArray objectAtIndex:indexPath.row];
    }
   
    FFMessageModal *modelChatInfo = [modelinfo.chatArray firstObject];
   
    NSString * sender = [NSString stringWithFormat:@"%@", modelChatInfo.senderID];
    NSString * selfUser = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
     if ([sender isEqualToString:selfUser]) {
         FFMessageThreadViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMessageThreadViewController"];
         objVc.messageModal = modelinfo;
         [self.navigationController pushViewController:objVc animated:YES];
         return;
     }
    if ([modelChatInfo.isRead isEqualToString:@"0"]) {
        FFMessageDiscriptionController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMessageDiscriptionController"];
        objVc.modelInfo = modelinfo;
        [self.navigationController pushViewController:objVc animated:YES];
    }
    else
    {
        FFMessageThreadViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMessageThreadViewController"];
        objVc.messageModal = modelinfo;
        [self.navigationController pushViewController:objVc animated:YES];
    }
}


#pragma mark- IBAction Methods--

-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)newMessageButtonClicked:(id)sender
{
    
}
-(IBAction)ongoingBtnClicked:(id)sender
{
    NSString * text = @"ONGOING";
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    [self.onGoingChatBtn setAttributedTitle:mat forState:UIControlStateNormal];
    
    text = @"REQUESTS";
    mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    [self.requestChatBtn setAttributedTitle:mat forState:UIControlStateNormal];
}
-(IBAction)requestBtnClicked:(id)sender
{
    NSString * text = @"REQUESTS";
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    [self.requestChatBtn setAttributedTitle:mat forState:UIControlStateNormal];
    
    text = @"ONGOING";
    mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    [self.onGoingChatBtn setAttributedTitle:mat forState:UIControlStateNormal];
}



#pragma mark - Service Helper Method

- (void)makeWebApiCallForGetMessageList {
    
    [self showLoader];
    
    [requestListArray removeAllObjects];
    [messageListArray removeAllObjects];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetMessageList forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                NSArray *messageArray = [response objectForKeyNotNull:@"messageList" expectedObj:[NSArray array]];
                for (NSDictionary *tempDict in messageArray) {
                    FFMessageModal * modal = [FFMessageModal userMessageList:tempDict];
                    if ([[NSString stringWithFormat:@"%@", modal.userConnectionStatus] isEqualToString:@"1"]) {
                        [messageListArray addObject:modal];
                    }
                    else{
                        [requestListArray addObject:modal];
                    }
                }
                [self.tableview reloadData];
                
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
