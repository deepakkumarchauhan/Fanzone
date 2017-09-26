//
//  FFBannerUploadViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFBannerUploadViewController.h"
#import "FFSignUpConcratulateViewController.h"
#import "Macro.h"

@interface FFBannerUploadViewController ()<TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation FFBannerUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _photoView.layer.borderWidth = 1.0;
    _photoView.layer.borderColor = [UIColor colorWithRed:181.0/255.0f green:87.0/255.0f blue:139.0/255.0f alpha:1].CGColor;
    _photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(cropImage:)];
    [_photoImageView addGestureRecognizer:tap];
    self.activityIndicatorView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cropImage:(UITapGestureRecognizer*)gesture
{
    
    if (self.photoImageView.image == nil) {
        [AlertView actionSheet:@"Fashion Fanzone" message:@"" andButtonsWithTitle:@[@"Camera",@"Gallery"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
            
            if (index!=2) {
                UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
                imagePicker.sourceType = (index == 0)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
                [imagePicker setDelegate:self];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            
        }];
        
    }else {
    UIImageView * imageview = (UIImageView*)gesture.view;
    if (imageview.image) {
        TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:imageview.image];
        cropController.delegate = self;
        [self presentViewController:cropController animated:YES completion:nil];
    }
  }
}


#pragma mark--- Ibaction methods----

-(IBAction)uploadPhotoBtn:(id)sender
{
    [self uploadImage:nil];
}

-(IBAction)continueBtnClicked:(id)sender
{
    [self makeWebApiCallForLogIn];
    
}
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--- get Photo ----

-(IBAction)uploadImage:(id)sender
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Fashion Fanzone" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
     image = [[FFUtility sharedInstance] croppIngimageByImageName:image toRect:CGRectMake(0, 0, cropRect.size.width/2, cropRect.size.height/2)];
    _photoImageView.image = image ;
    self.userInfoObj.bannerPhotoImage = image;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.photoImageView.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(self.photoImageView.frame.origin.x, self.photoImageView.frame.origin.y + 64, self.photoImageView.frame.size.width, self.photoImageView.frame.size.height) completion:^{
        self.photoImageView.hidden = NO;
        
    }];
    
}



#pragma mark - Helper Method

- (void)makeWebApiCallForLogIn {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiSignUp forKey:apiAction];
    [dictRequest setValue:_userInfoObj.passwordString forKey:KPassword];
    [dictRequest setValue:_userInfoObj.passwordString forKey:KConfirmPassword];
    [dictRequest setValue:_userInfoObj.userNameString forKey:KUserName];
    [dictRequest setValue:_userInfoObj.firstNameString forKey:KFirstName];
    [dictRequest setValue:_userInfoObj.lastNameString forKey:KLastName];
    [dictRequest setValue:_userInfoObj.emailAddressString forKey:KEmail];
    [dictRequest setValue:@"ios" forKey:KDeviceType];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDeviceToken] forKey:KDeviceToken];
    
    if (_userInfoObj.bannerPhotoImage != nil) {
        NSData *dataBannerImg = UIImageJPEGRepresentation(_userInfoObj.bannerPhotoImage, 0.1);
        [dictRequest setValue:[dataBannerImg base64EncodedString] forKey:KBannerImage];
    }
    if (_userInfoObj.userPhotoImage != nil) {
        NSData *dataProfileImg = UIImageJPEGRepresentation(_userInfoObj.userPhotoImage, 0.1);
        [dictRequest setValue:[dataProfileImg base64EncodedString] forKey:KUserImage];
    }
    [dictRequest setValue:_userInfoObj.userType forKey:KUserType];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {

                [NSUSERDEFAULT setValue:[NSString stringWithFormat:@"%@",[response valueForKey:KIsVerify]] forKey:KIsVerify];

                if ([[response objectForKeyNotNull:KEditPassword expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"editPassword"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"editPassword"];
                }
                if ([[response objectForKeyNotNull:KImageStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"imageTophoto"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"imageTophoto"];
                }
                if ([[response objectForKeyNotNull:KDLocationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"locationSetting"];

                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"locationSetting"];
                }
                if ([[response objectForKeyNotNull:KMobileDataStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"mobileData"];

                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"mobileData"];
                }
                if ([[response objectForKeyNotNull:KNotificationStatus expectedObj:@""] isEqualToString:@"1"]) {
                    [NSUSERDEFAULT setBool:YES  forKey:@"pushNotification"];
                }else{
                    [NSUSERDEFAULT setBool:NO  forKey:@"pushNotification"];

                }
                [NSUSERDEFAULT setValue:[response objectForKeyNotNull:KUserId expectedObj:@""] forKey:KUserId];
                [NSUSERDEFAULT setValue:[response objectForKeyNotNull:KUserType expectedObj:@""] forKey:KUserType];
                [NSUSERDEFAULT setValue:[response valueForKey:KUserImage] forKey:KUserImage];

                FFSignUpConcratulateViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"congratulationIdentifier"];
                [self.navigationController pushViewController:objVc animated:YES];
                
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
    
    [self.continueButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.continueButton.enabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    
    [self.continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.continueButton.enabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}



@end
