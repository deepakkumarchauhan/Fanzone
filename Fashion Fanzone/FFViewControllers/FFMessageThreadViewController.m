//
//  FFMessageThreadViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 20/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMessageThreadViewController.h"

@interface FFMessageThreadViewController ()<UITableViewDelegate> {
    
    BOOL isLoading;

}
@property (nonatomic, weak) IBOutlet UITableView * threadTableView;
@property (nonatomic, weak) IBOutlet UILabel * chatTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel * recepntNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView * recepntProfileImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong)  NSMutableArray * messaegListArray;
@property (nonatomic, strong) UIRefreshControl * refreshControl;

@property (strong, nonatomic) PAPagination *pagination;
@end

@implementation FFMessageThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messaegListArray = [NSMutableArray new];
    _threadTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [_recepntProfileImageView sd_setImageWithURL:[NSURL URLWithString:_messageModal.userProfileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _recepntNameLabel.text = _messageModal.displayName;
    self.chatTitleLabel.text = _messageModal.messageTitle;
    NSLog(@"thread user %@", _messageModal);
    
    
    // Add Pull To Refresh On Fanzone Table
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.threadTableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshThreadTable) forControlEvents:UIControlEventValueChanged];
    
    // Alloc Pagination Modal
    self.pagination = [[PAPagination alloc] init];
    self.pagination.pageNo = @"1";

    
    [self getMessagelist:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableview Delegate methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _messaegListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFMessageListTableCell *cell = (FFMessageListTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FFMessageModal * modelinfo = [_messaegListArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = modelinfo.senderName;
    [cell.fromUserImage sd_setImageWithURL:[NSURL URLWithString:modelinfo.senderImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.toUserImage sd_setImageWithURL:[NSURL URLWithString:modelinfo.imageUrl] placeholderImage:nil];
    cell.indicatorArraowImageView.image = [UIImage imageNamed:@"chatBack"];
    
    cell.toUserImage.tag = indexPath.row + 100;
    cell.fromUserImage.tag = indexPath.row + 100;

    UITapGestureRecognizer * tapOnProfileReceiver =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImageReceivertapped:)];
    cell.toUserImage.userInteractionEnabled  = YES;
    [cell.toUserImage addGestureRecognizer:tapOnProfileReceiver];
    
    UITapGestureRecognizer * tapOnProfileSender =[[ UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(profileImageSendertapped:)];
    cell.fromUserImage.userInteractionEnabled  = YES;
    [cell.fromUserImage addGestureRecognizer:tapOnProfileSender];


    
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:cell.titleLabel.text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
    cell.titleLabel.attributedText = mat;
    cell.descriptionsLabel.text = modelinfo.textMessage;
    NSString * sender = [NSString stringWithFormat:@"%@", modelinfo.senderID];
    NSString * selfUser = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:KUserId]];
    
    if ([sender isEqualToString:selfUser]) {
        cell.indicatorArraowImageView.image = [UIImage imageNamed:@"chatForward"];
    }
    if (modelinfo.message.length==0) {
        cell.descriptionsLabel.text = @"Image";
    }else
        cell.descriptionsLabel.text = modelinfo.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FFMessageModal *modelinfo = [[FFMessageModal alloc]init];
    modelinfo.chatArray = [NSMutableArray array];
    modelinfo.chatArray = [self.messaegListArray mutableCopy];
    modelinfo.userProfileImage = self.messageModal.userProfileImage;
    modelinfo.displayName = self.messageModal.displayName;
    modelinfo.stylePoints = self.messageModal.stylePoints;

    FFMessageDiscriptionController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMessageDiscriptionController"];
    objVc.modelInfo = modelinfo;
    objVc.pageIndex = indexPath.row;
    objVc.isFromThread = YES;
    [self.navigationController pushViewController:objVc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0;
}


#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    
        NSInteger currentOffset = scrollView.contentOffset.y;
        NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - currentOffset <= 10.0) {
            if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && isLoading) {
                isLoading = NO;
                
                [self getMessagelist:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)]];
                
        }
    }
}



#pragma mark - Selector Method
-(void)refreshThreadTable {
    
    [self.refreshControl endRefreshing];
    [self getMessagelist:@"1"];
}

#pragma mark-
#pragma mark ImageGesture methods-

- (void)profileImageReceivertapped:(UITapGestureRecognizer *)gesture {
    
    UIImageView * imgView = (UIImageView *)gesture.view;
    NSInteger tag = imgView.tag;
    FFMessageModal * modal = [_messaegListArray objectAtIndex:tag-100];
    
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.isFromConnection = YES;
    profile.concernUser_id = modal.receiverID;
    [self.navigationController pushViewController:profile animated:NO];
    
}

- (void)profileImageSendertapped:(UITapGestureRecognizer *)gesture {
    
    UIImageView * imgView = (UIImageView *)gesture.view;
    NSInteger tag = imgView.tag;
    FFMessageModal * modal = [_messaegListArray objectAtIndex:tag-100];
    
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = NO;
    profile.isFromConnection = YES;
    profile.concernUser_id = modal.senderID;
    [self.navigationController pushViewController:profile animated:NO];
    
}



-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)newMessageButtonClicked:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Message title needed."
                                                                              message: @"Please provide a title for new message."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"title";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * titleField = textfields[0];
        if ((titleField.text==nil ) || [titleField.text isEqualToString:@""]) {
            [self  nilTitleMessage];
        }
        else
        {
            FFPostModal * modal = [[FFPostModal alloc] init];
            modal.postTitle = titleField.text;
            FFDirectMessageContactList * list = (FFDirectMessageContactList*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFDirectMessageContactList"];
            list.modalPost = modal;
            [self.navigationController pushViewController:list animated:YES];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}
-(void)nilTitleMessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Alert!"
                                                                              message: @"Message title needed."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark-
#pragma mark GetMessageList For Particular--

-(void)getMessagelist:(NSString *)pageNumber //
{
    
    [self showLoader];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiUserMessageList forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];//receiverID
    [dictRequest setValue:_messageModal.otherUserId forKey:KReceiverID];
    [dictRequest setValue:pageNumber forKey:KPageNumber];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                NSArray *messageArray = [response objectForKeyNotNull:@"messageThread" expectedObj:[NSArray array]];
                
                _pagination = [PAPagination getPaginationInfoFromDict:[response objectForKeyNotNull:KPagination expectedObj:[NSDictionary dictionary]]];
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [_messaegListArray removeAllObjects];
                }

                for (NSDictionary *tempDict in messageArray) {
                    FFMessageModal * modal = [FFMessageModal userThreadList:tempDict];
                    [_messaegListArray addObject:modal];
                }
                isLoading =YES;

                [self.threadTableView reloadData];
                
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
