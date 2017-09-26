//
//  FFAddToFlowViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 18/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFAddToFlowViewController.h"
#import "FFFanzoneModelInfo.h"

@interface FFAddToFlowViewController ()<UITableViewDelegate, UITableViewDataSource, GPPSignInDelegate,UICollectionViewDelegate>
@property (nonatomic, weak)IBOutlet UICollectionView * collectionview;
@property (nonatomic, weak)IBOutlet UILabel * guestFlowLabel;

@property (nonatomic, strong) NSMutableArray *flowDataArray;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *publishButton;
@property (strong, nonatomic) IBOutlet UIImageView *fashionFlowImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *fashionFlowView;

@end

@implementation FFAddToFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    _flowDataArray = [[NSMutableArray alloc]init];
    self.collectionview.contentInset = UIEdgeInsetsMake(4, 6, 4,5);
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
    
    // Add Tap Gesture on TableView
    self.fashionFlowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnfashionFlowImage:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.fashionFlowView addGestureRecognizer:tapGesture1];
    [self makeWebApiCallForGetFanzonecategory];
    if (!self.isFromCameraClick) {
        self.fashionFlowView.hidden = YES;
        self.fashionFlowImageView.hidden = YES;
    }
    if (!_modalPost) {
        _modalPost = [FFPostModal new];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) { //hide the status bar....
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    if (self.flowDataArray.count){
        FFFanzoneModelInfo *tempInfo = [self.flowDataArray firstObject];
        return tempInfo.guserArray.count;
    }
    return 0;
}



-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFAddFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"guestCell" forIndexPath:indexPath];
    
    FFFanzoneModelInfo *tempInfo = [self.flowDataArray firstObject];
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.guserArray objectAtIndex:indexPath.item];
    cell.backgroundButton.tag = indexPath.item + 200;
    [cell.backgroundButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.bgAddView.userInteractionEnabled = YES;
    cell.backgroundColor = [UIColor blackColor];
    [cell.profileimage sd_setImageWithURL:[NSURL URLWithString:tempCatInfo.guestUserImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    cell.decriptionLabel.text = tempCatInfo.categoryName;
    cell.nameLabel.text = tempCatInfo.guestUserName;
    
    if ([_modalPost.postFlow isEqualToString:tempCatInfo.categoryName]) {
       
        cell.backgroundButton.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundButton.alpha = 0.5;
    }
   else
   {
       cell.backgroundButton.alpha = 1.0;
       cell.backgroundButton.backgroundColor = [UIColor clearColor];
   }
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger cellWidth = self.collectionview.frame.size.height;
    
    return CGSizeMake(90, cellWidth);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionview) {
        CGPoint currentCellOffset = self.collectionview.contentOffset;
        currentCellOffset.x += self.collectionview.frame.size.width / 2;
        NSIndexPath *indexPath = [self.collectionview indexPathForItemAtPoint:currentCellOffset];
        [self.collectionview scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }
}


#pragma mark-
#pragma mark TableView Delegate Methods-


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.flowDataArray.count){
        FFFanzoneModelInfo *tempInfo = [self.flowDataArray firstObject];
        return tempInfo.categoryArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFFlowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"flowTableCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    FFFanzoneModelInfo *tempInfo = [_flowDataArray firstObject];
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = tempCatInfo.categoryName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFFanzoneModelInfo *tempInfo = [_flowDataArray firstObject];
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.categoryArray objectAtIndex:indexPath.row];
    self.fashionFlowView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0  blue:255.0/255.0  alpha:0.52];
    _modalPost.postFlow = tempCatInfo.categorySlugName;
    [_collectionview reloadData];
}


#pragma mark-
#pragma mark IBaction Methods--



-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cameraButtonClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFCameraViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

-(IBAction)publishButtoClicked:(id)sender
{
    
    if (_modalPost.postFlow.length) {
        if (_isFromTextEditor) {
            [self callEditorApi];
        }
        else{
            [self makeWebApiCallForPublishFanzonePost];
        }
       
    }else{
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"" andMessage:@"Please select any category." onController:self];
    }
}

-(IBAction)facebookShare:(id)sender
{
    UIImage * imageToPst=_modalPost.postImage;
    if (!imageToPst) {
        if (_modalPost.postImageArray.count>0) {
            imageToPst=_modalPost.postImageArray[0];
        }
    }
    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controllerSLC setInitialText:[NSString stringWithFormat:@"%@\n%@", _modalPost.postTitle , _modalPost.postCatptions]];
    [controllerSLC addImage:imageToPst];
    [self presentViewController:controllerSLC animated:YES completion:Nil];
    
}

-(IBAction)twitterShare:(id)sender
{
    UIImage * imageToPst=_modalPost.postImage;
    if (!imageToPst) {
        if (_modalPost.postImageArray.count>0) {
            imageToPst=_modalPost.postImageArray[0];
        }
    }
    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controllerSLC setInitialText:[NSString stringWithFormat:@"%@\n%@", _modalPost.postTitle , _modalPost.postCatptions]];
    [controllerSLC addImage:imageToPst];
    [self presentViewController:controllerSLC animated:YES completion:Nil];
    
}

-(IBAction)googlePlusShare:(id)sender
{
    UIImage * imageToPst=_modalPost.postImage;
    if (!imageToPst) {
        if (_modalPost.postImageArray.count>0) {
            imageToPst=_modalPost.postImageArray[0];
        }
    }
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    // Set any prefilled text that you might want to suggest
    [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@\n%@", _modalPost.postTitle , _modalPost.postCatptions]];
    [shareBuilder attachImage:imageToPst];
    
    
    BOOL canOpen = [shareBuilder open];
    if (!canOpen) {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.clientID = KGooglePlusClientID;
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];
        signIn.delegate = self;
        [signIn authenticate];
        
    }
    
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@", error, auth);
    if (error) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Google plus login error" message:error.description andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             
         }];
    } else {
        [self googlePlusShare:nil];
    }
}


#pragma mark - Selector Method

- (void)buttonAction:(UIButton *)sender {
    
    FFFanzoneModelInfo *tempInfo = [self.flowDataArray firstObject];
    sender.backgroundColor = [UIColor lightGrayColor];
    sender.alpha = 0.5;
    FFFanzoneModelInfo *tempCatInfo = [tempInfo.guserArray objectAtIndex:sender.tag-200];
    _modalPost.postFlow = tempCatInfo.categoryName;
    [_collectionview reloadData];
    [_tableView reloadData];
}


#pragma mark - tap Getsure Method

-(void)tapOnfashionFlowImage:(UITapGestureRecognizer *)gesture {
    
    self.fashionFlowView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0  blue:255.0/255.0  alpha:0.70];
    _modalPost.postFlow = @"flash-flow";
    [_collectionview reloadData];
    [_tableView reloadData];
}

#pragma mark - Helper Method

- (void)makeWebApiCallForPublishFanzonePost {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiFanzonePublish forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    if (self.modalPost.postImage != nil) {
        self.modalPost.postImage = [FFUtility resizeImage: self.modalPost.postImage];
        NSData *dataProfileImg = [NSData dataWithData:UIImageJPEGRepresentation(self.modalPost.postImage , 1.0)];
        [imageArray addObject:dataProfileImg];
    }else if (self.modalPost.postImageArray.count) {
        
        for (int index = 0; index < self.modalPost.postImageArray.count ; index++) {
            UIImage * imge = [self.modalPost.postImageArray objectAtIndex:index];
            NSData *dataProfileImg = [NSData dataWithData:UIImageJPEGRepresentation([FFUtility resizeImage: imge] , 1.0)];
            [imageArray addObject:dataProfileImg];
        }
    }
    if (self.modalPost.gifImageData) {
        [imageArray removeAllObjects];
        [imageArray addObject:self.modalPost.gifImageData];
    }
    [dictRequest setValue:imageArray forKey:KPublishImage];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlatitude] forKey:KDefaultlatitude];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlongitude] forKey:KDefaultlongitude];
    [dictRequest setValue:self.modalPost.postCatptions forKey:KCaption];
    [dictRequest setValue:self.modalPost.postTitle forKey:KTitle];
    [dictRequest setValue:_modalPost.postFlow forKey:KCategoryName];
    [dictRequest setValue:@"" forKey:KHtmlFanzoneContent];
    
    [[ServiceHelper_AF3 instance] makeMultipartWebApiCallWithParametersForMultipleFile:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if ([NSUSERDEFAULT boolForKey:@"imageTophoto"]) {
                    if (self.modalPost.postImage != nil) {
                        UIImageWriteToSavedPhotosAlbum(self.modalPost.postImage, nil, nil, nil);
                        
                    }else if (self.modalPost.postImageArray.count) {
                        
                        for (int index = 0; index < self.modalPost.postImageArray.count ; index++) {
                            
                            UIImageWriteToSavedPhotosAlbum([self.modalPost.postImageArray objectAtIndex:index], nil, nil, nil);
                        }
                    }
                }
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FFFashionViewController class]]||[controller isKindOfClass:[FFMainViewController class]]||[controller isKindOfClass:[FFExploreViewController class]]||[controller isKindOfClass:[FFTextEditiorViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                }];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}

#pragma mark-
#pragma mark Call Editor Api-

-(void)callEditorApi
{
    [self showLoader];
    [_textDitorDict setValue:[NSUSERDEFAULT valueForKey:KDefaultlatitude] forKey:KDefaultlatitude];
    [_textDitorDict setValue:[NSUSERDEFAULT valueForKey:KDefaultlongitude] forKey:KDefaultlongitude];
    [_textDitorDict setValue:_modalPost.postFlow forKey:KCategoryName];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:_textDitorDict AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    for (UIViewController * controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[FFFashionViewController class]]||[controller isKindOfClass:[FFMainViewController class]]||[controller isKindOfClass:[FFExploreViewController class]]||[controller isKindOfClass:[FFTextEditiorViewController class]]) {
                            [self.navigationController popToViewController:controller animated:YES];
                            return;
                        }
                    }
                }];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
    
}
- (void)makeWebApiCallForGetFanzonecategory {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiGetFanzoneCategory forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [_flowDataArray addObject:[FFFanzoneModelInfo fanzoneCategoryFromResponse:response]];
                [self.collectionview reloadData];
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
