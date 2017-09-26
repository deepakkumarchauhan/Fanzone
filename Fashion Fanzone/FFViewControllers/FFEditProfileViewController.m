//
//  FFEditProfileViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 28/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFEditProfileViewController.h"

@interface FFEditProfileViewController ()<UITextViewDelegate,TOCropViewControllerDelegate>
{
    UIImageView * headerImage;
    UIButton * button;
    UIButton * doneButton;
    UIImageView * tempImageView;
    NSMutableArray *userData;
    FFUserDetailSectionHeader * header;
    NSInteger profilePictueIndex;
}


@property (nonatomic, weak)IBOutlet UITableView * tbleView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFEditProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    userData = [NSMutableArray array];
    
    header = [[FFUserDetailSectionHeader alloc] initWithNibName:@"FFUserDetailSectionHeader" bundle:nil];
    NSInteger viewHeight = 350;
    if (MainScreenHeight>568) {
        viewHeight = 250;
    }
    header.userNameTextFeilds.userInteractionEnabled = self.isFromUserName;
    [header setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, viewHeight)];
    self.tbleView.tableHeaderView = header;
    self.tbleView.rowHeight = 50;
    self.tbleView.estimatedRowHeight = 50.0 ;
    self.tbleView.rowHeight = UITableViewAutomaticDimension;
    header.connectionBtn.hidden = YES;
    
    UITapGestureRecognizer * bannerGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeBannerImage:)];
    UITapGestureRecognizer * profileGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfileImage:)];
    header.bannerView.userInteractionEnabled = YES;
    header.profileImageView.userInteractionEnabled = YES;
    [header.bannerView addGestureRecognizer:bannerGesture];
    [header.profileImageView addGestureRecognizer:profileGesture];
    
    [self apiToFetchUserprofileData];
    
}
-(void)changeBannerImage:(UITapGestureRecognizer *)gesture
{
    UIImageView * imgView = (UIImageView *)gesture.view;
    tempImageView = imgView;
    profilePictueIndex = 1;
    [self getPhoto];
}
-(void)changeProfileImage:(UITapGestureRecognizer *)gesture
{
    UIImageView * imgView = (UIImageView *)gesture.view;
    tempImageView = imgView;
    profilePictueIndex = 2;
    [self getPhoto];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self layoutNavigationBar];
}
-(void)layoutNavigationBar
{
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"backBlack"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 5, 60, 30)];
    [self.navigationController.navigationBar addSubview:button];
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setFrame:CGRectMake(MainScreenWidth-65, 5, 60, 30)];
    [self.navigationController.navigationBar addSubview:doneButton];
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [headerImage removeFromSuperview];
    [button removeFromSuperview];
    [doneButton removeFromSuperview];
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
        case 2:
        {
            return modelInfo.achievementArray.count;
        }
            break;
        case 3:
        {
            return modelInfo.flowArray.count;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFEditproTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EditDetail"];
    cell.editTextView .scrollEnabled = NO;
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.editTextView.delegate = self;
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    
    switch (indexPath.section) {
        case 0: {
            cell.editTextView.tag = 100;
            cell.textLabelDetails.text = @"Crative Fashion magazine Based in NY and London, working with foremost talent and established knowledge to further creativity in the fashion industry.";
            cell.textLabelDetails.hidden = YES;
            cell.editTextView.text = modelInfo.bio;
            cell.editTextView.hidden = NO;
            cell.editTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        }
            break;
        case 1: {
            cell.editTextView.tag = 101;
            cell.textLabelDetails.text = @"FashionFanzine.com";
            cell.textLabelDetails.hidden = YES;
            cell.editTextView.text = modelInfo.userUrl;
            cell.editTextView.hidden = NO;
            cell.editTextView.autocorrectionType = UITextAutocorrectionTypeNo;

        }
            break;
        case 2: {
            cell.editTextView.hidden = YES;
            cell.textLabelDetails.hidden = NO;
            FFFanzoneModelInfo *modelTempInfo = [modelInfo.achievementArray objectAtIndex:indexPath.row];
            cell.textLabelDetails.text = modelTempInfo.connectionsCount;

        }
            break;
        case 3: {
            cell.editTextView.hidden = YES;
            cell.textLabelDetails.hidden = NO;
            FFFanzoneModelInfo *modelTempInfo = [modelInfo.flowArray objectAtIndex:indexPath.row];
            cell.textLabelDetails.text = modelTempInfo.flowName;
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark TableView delegate----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    if (section == 2) {
        if (modelInfo.achievementArray.count)
            return 20;
        else
            return 0;
    }
    if (section == 3) {
        if (modelInfo.flowArray.count)
            return 20;
        else
            return 0;
    }
    return 20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];

    if (section==0) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        UILabel * label = [[UILabel alloc] initWithFrame:view.frame];
        label.text = @"      Bio";
        label.font  = AppFont(15);
        [view addSubview:label];
        
        
    }
    if (section==1) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        UILabel * label = [[UILabel alloc] initWithFrame:view.frame];
        label.text = @"      URL";
        label.font  = AppFont(15);
        [view addSubview:label];
        
        
    }
    if (section==2) {
        
        if (modelInfo.achievementArray.count)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        else
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];

        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 150, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"achivement"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    if (section==3) {
        
        if (modelInfo.flowArray.count)
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        else
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 0, 80, 20)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageNamed:@"flow"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    if (indexPath.section == 3) {
        if (modelInfo.flowArray.count == indexPath.row+1) {
            FFCreateFlowViewController *createFlowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCreateFlowViewController"];
            [self.navigationController pushViewController:createFlowVC animated:YES];
        }
    }
    
}


#pragma mark - UITextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    if (textView.tag == 100) {
        modelInfo.bio = textView.text;
    }else{
        modelInfo.userUrl = textView.text;
    }
    
}

#pragma mark-
#pragma mark IBAction Methods-

-(void)doneButtonClicked
{
    
    
    [self apiToUpdateUserprofileData];
}

-(void)callBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-
#pragma mark get Photo For Edit Profile---



-(void)getPhoto
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Fanzone" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:NO completion:^{
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }];
}


#pragma mark - Cropper Delegate Method

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    image = [[FFUtility sharedInstance] croppIngimageByImageName:image toRect:CGRectMake(0, 0, cropRect.size.width/2, cropRect.size.height/2)];
    
    tempImageView.image = image;
    
    if (profilePictueIndex == 1)
        modelInfo.editBannerImage = image;
    else
        modelInfo.editProfileImage = image;

    self.navigationItem.rightBarButtonItem.enabled = YES;
    tempImageView.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(tempImageView.frame.origin.x, tempImageView.frame.origin.y + 64, tempImageView.frame.size.width, tempImageView.frame.size.height) completion:^{
        tempImageView.hidden = NO;
        
    }];
    
}



#pragma mark API TO FETCH USER PROFILE DATA-
//***** CP

-(void)apiToFetchUserprofileData
{
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiUserProfile forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [userData addObject:[FFFanzoneModelInfo fanzoneUserDetailResponse:response]];
                
                FFFanzoneModelInfo *modelInfo = [userData firstObject];
                
                FFFanzoneModelInfo *modelTempInfo = [[FFFanzoneModelInfo alloc]init];
                FFFanzoneModelInfo *modelBannerTempInfo = [modelInfo.userBannerImageArray firstObject];

                modelTempInfo.flowName = @"+MANAGE FLOW";
                [modelInfo.flowArray addObject:modelTempInfo];
                
                header.userNameTextFeilds.text = modelInfo.userName;
                header.noOfFolloerws.text = modelInfo.followersCount;
                header.noIfStypePoints.text = modelInfo.stylePoints;
                header.noOfConnections.text = modelInfo.connectionsCount;
                
                [header.profileImageView sd_setImageWithURL:[NSURL URLWithString:modelInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
                [header.bannerView sd_setImageWithURL:[NSURL URLWithString:modelBannerTempInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
                
                modelInfo.editProfileImage = header.profileImageView.image;
                modelInfo.editBannerImage = header.bannerView.image;
                
                
                if ([modelInfo.isVerify isEqualToString:@"1"]) {
                    header.verifiedLabel.text = @"Verified";
                }else{
                    header.verifiedLabel.text = @"Not Verified";
                }
                
                [self.tbleView reloadData];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}



-(void)apiToUpdateUserprofileData
{
    [self showLoader];
    
    FFFanzoneModelInfo *modelInfo = [userData firstObject];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiUpdateUserProfile forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    [dictRequest setValue:modelInfo.bio forKey:KBio];
    [dictRequest setValue:modelInfo.userUrl forKey:KUrl];
    
    if (modelInfo.editProfileImage != [UIImage imageNamed:@"placeholder"]) {
        NSData *dataBannerImg = UIImageJPEGRepresentation(modelInfo.editProfileImage, 0.1);
        [dictRequest setValue:[dataBannerImg base64EncodedString] forKey:KUserImage];
    }
    if (modelInfo.editBannerImage != [UIImage imageNamed:@"Banner"]) {
        NSData *dataBannerImg = UIImageJPEGRepresentation(modelInfo.editBannerImage, 0.1);
        [dictRequest setValue:[dataBannerImg base64EncodedString] forKey:KBannerImage];
    }
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                NSDictionary *userDict = [response objectForKeyNotNull:@"data" expectedObj:[NSDictionary dictionary]];
                [NSUSERDEFAULT setValue:[userDict valueForKey:KProfileImage] forKey:KUserImage];

                [[AlertView sharedManager] presentAlertWithTitle:@"Success!" message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok",nil] onController:self dismissedWith:^(NSInteger index, NSString * titlestring){
                    
                    [self.delegate callProfileApi];
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
