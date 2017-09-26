//
//  FFDirectMessageContactList.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 16/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFDirectMessageContactList.h"

@interface FFDirectMessageContactList ()<UIImagePickerControllerDelegate , UINavigationControllerDelegate>
@property (nonatomic, strong) IBOutlet UITableView * conenctionTableView;
@property (nonatomic, strong) NSMutableArray * userListArray;
@property (nonatomic, strong) NSMutableArray * receipentArray;
@property (strong, nonatomic) PAPagination *pagination;
@property (strong, nonatomic) NSString *searchText;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UISearchBar * searchbar;
@property (weak, nonatomic) IBOutlet UIButton * PhotoButton;
@property (weak, nonatomic) IBOutlet UIButton * cameraButton;
@property (weak, nonatomic) IBOutlet UIButton * textEditorButton;
@property (weak, nonatomic) IBOutlet UIButton * sendButton;
@property (nonatomic, strong) UIRefreshControl * refreshControl;

@end

@implementation FFDirectMessageContactList

- (void)viewDidLoad {
    [super viewDidLoad];
    _userListArray = [NSMutableArray new];
    _receipentArray = [NSMutableArray new];
    _conenctionTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _pagination = [[PAPagination alloc]init];
    _pagination.pageNo = @"1";
    _searchText = @"";
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.conenctionTableView addSubview:_refreshControl];
    if (_isForwardMessage) {
        _PhotoButton.hidden = YES;
        _cameraButton.hidden = YES;
        _textEditorButton.hidden = YES;
    }
    else
    {
        _sendButton.hidden = YES;
    }
    [self makeWebApiCallForGetAllUsersList:_pagination.pageNo andSearchText:_searchText];
}
- (void)refreshTable {
    //TODO: refresh your data
    [_refreshControl endRefreshing];
    _pagination.pageNo = @"1";
     [self makeWebApiCallForGetAllUsersList:_pagination.pageNo andSearchText:_searchText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIScroll View Delegate Methods
-(void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [self.view endEditing:YES];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= 10.0) {
        if (([_pagination.pageNo integerValue] < [_pagination.maxPageNo integerValue]) && _isLoading) {
            _isLoading = NO;
            
            [self makeWebApiCallForGetAllUsersList:[NSString stringWithFormat:@"%ld",(long)([_pagination.pageNo integerValue]+1)] andSearchText:_searchText];
            
        }
    }
}
#pragma mark- UITableview Delegate methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFMessageListTableCell *cell = (FFMessageListTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FFMessageModal *modelinfo = [_userListArray objectAtIndex:indexPath.row];
    if ([_receipentArray containsObject:modelinfo]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.titleLabel.text = modelinfo.displayName;
    [cell.toUserImage sd_setImageWithURL:[NSURL URLWithString:modelinfo.userProfileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   //_receipentArray
    
    FFMessageModal *modelinfo = [_userListArray objectAtIndex:indexPath.row];
    if ([_receipentArray containsObject:modelinfo]) {
        [_receipentArray removeObject:modelinfo];
    }
    else
    {
        [_receipentArray addObject:modelinfo];
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - UISearchbar Delegate Methods


-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = @"";
    [searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
    _searchText = @"";
    _pagination.pageNo = @"1";
    [self makeWebApiCallForGetAllUsersList:_pagination.pageNo andSearchText:_searchText];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar performSelector:@selector(resignFirstResponder)
                    withObject:nil
                    afterDelay:0];
    
}

-(void)searchBar:(UISearchBar*)searchbar textDidChange:(NSString*)text
{
    if ([text length] == 0)
    {
        
        [searchbar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];
        return;
    }
     _searchText = text;
    _pagination.pageNo = @"1";
     [self makeWebApiCallForGetAllUsersList:_pagination.pageNo andSearchText:_searchText];
    
}


#pragma mark - Service Helper Method

- (void)makeWebApiCallForGetAllUsersList:(NSString*)pageNo andSearchText:(NSString*)searchText{
    
    if (_searchText.length==0) {
        [self showLoader];
    }
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiGetAllUserList forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:pageNo forKey:KPageNumber];
    [dictRequest setValue:searchText forKey:KSearchText];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                if ([_pagination.pageNo isEqualToString:@"1"]) {
                    [_userListArray removeAllObjects];
                    [_receipentArray removeAllObjects];
                }
                
                NSArray *messageArray = [response objectForKeyNotNull:@"usersList" expectedObj:[NSArray array]];
                for (NSDictionary *tempDict in messageArray) {
                    [_userListArray addObject:[FFMessageModal allUserList:tempDict]];
                }
                 _isLoading =YES;
                [self.conenctionTableView reloadData];
                
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

#pragma mark- 
#pragma mark IBAction Methods-

-(IBAction)sendButtonClicked:(id)sender
{
    [self showLoader];
    
    NSMutableArray * tempArray = [NSMutableArray new];
    for (FFMessageModal * modal  in _receipentArray) {
        [tempArray addObject:modal.otherUserId];
    }
    [self updateModalRecipentArray];
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiAddChat forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];//
    [dictRequest setValue:tempArray forKey:KReceiverID]; //message
    [dictRequest setValue:_messageModal.messageTitle forKey:KTitle];
    tempArray = nil;
    if (_messageModal.message.length) {
        [dictRequest setValue:_messageModal.message forKey:KMessages];
        [dictRequest setValue:@"" forKey:KMessagesImage];
        [self fireApiForForwardMessage:dictRequest];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_messageModal.imageUrl]];
            NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [dictRequest setValue:base64 forKey:KMessagesImage];
                [dictRequest setValue:@"" forKey:KMessages];
                [self fireApiForForwardMessage:dictRequest];
            });
        });
        
    }
    
    
   
}

-(void)fireApiForForwardMessage:(NSDictionary*)param
{
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:param AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)cameraButtonClicked:(id)sender
{
    if (_receipentArray.count==0) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Warning!" message:@"Please select recipient." andButtonsWithTitle:[NSArray arrayWithObjects:@"OK", nil] onController:self dismissedWith:^(NSInteger index , NSString * title)
         {
             
         }];
        return;
    }
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
            [self updateModalRecipentArray];
            _modalPost.postTitle = titleField.text;
            FFCameraViewController * cameraControler = (FFCameraViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFCameraViewController"];
            cameraControler.isMessaging = YES;
            cameraControler.modalPost = _modalPost;
            [self.navigationController pushViewController:cameraControler animated:YES];
        }
        
        
    }]];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
    {
    }];
    [alertController addAction:noButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}
-(IBAction)galleryButtonClicked:(id)sender
{
    if (_receipentArray.count==0) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Warning!" message:@"Please select recipient." andButtonsWithTitle:[NSArray arrayWithObjects:@"OK", nil] onController:self dismissedWith:^(NSInteger index , NSString * title)
         {
             
         }];
        return;
    }
    
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
            [self updateModalRecipentArray];
            _modalPost.postTitle = titleField.text;
            UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [imagePicker setDelegate:self];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
        
    }]];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    [alertController addAction:noButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
    
}
-(IBAction)textButtonClicked:(id)sender
{
    if (_receipentArray.count==0) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Warning!" message:@"Please select recipient." andButtonsWithTitle:[NSArray arrayWithObjects:@"OK", nil] onController:self dismissedWith:^(NSInteger index , NSString * title)
         {
             
         }];
        return;
    }
    
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
            [self updateModalRecipentArray];
            _modalPost.postTitle = titleField.text;
            FFTextEditiorViewController * controller = (FFTextEditiorViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFTextEditiorViewController"];
            controller.modalPost = _modalPost;
            controller.isMessaging = YES;
            [self.navigationController pushViewController:controller animated:NO];
        }
    }]];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"Dismiss"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    [alertController addAction:noButton];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion:nil];
    FFImageColourPickerVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFImageColourPickerVC"];
    imageVC.imageObject = img;
    imageVC.isFromCameraClick = YES;
    imageVC.isMessaging = YES;
    imageVC.modalPost = _modalPost;
    [self.navigationController pushViewController:imageVC animated:NO];
}
-(void)updateModalRecipentArray
{
    NSMutableArray * tempArray = [NSMutableArray new];
    for (FFMessageModal * modal  in _receipentArray) {
        [tempArray addObject:modal.otherUserId];
    }
    _modalPost.messageReceipent = [NSArray arrayWithArray:tempArray];
    tempArray = nil;
}
-(void)nilTitleMessage
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Alert!"
                                                                              message: @"Message title needed."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
