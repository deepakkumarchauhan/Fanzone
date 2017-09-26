//
//  FFUploadPhotoViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFUploadPhotoViewController.h"
#import "FFBannerUploadViewController.h"
#import "Macro.h"

@interface FFUploadPhotoViewController ()<TOCropViewControllerDelegate>

@end

@implementation FFUploadPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup af loading the view.
    _photoView.layer.borderWidth = 1.0;
    _photoView.layer.borderColor = [UIColor colorWithRed:181.0/255.0f green:87.0/255.0f blue:139.0/255.0f alpha:1].CGColor;
    _photoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(cropImage:)];
    [_photoImageView addGestureRecognizer:tap];
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

#pragma mark--- IBAction methods----
-(IBAction)uploadPhotoBtn:(id)sender {
    [self uploadImage:nil];
}

-(IBAction)continueBtnClicked:(id)sender {
    
    FFBannerUploadViewController *objVc = [self.storyboard instantiateViewControllerWithIdentifier:@"bannerPhotoIdentifier"];
    objVc.userInfoObj = self.userInfoObj;
    [self.navigationController pushViewController:objVc animated:YES];

}

#pragma mark--- get Photo ----
-(IBAction)uploadImage:(id)sender {
    
    [AlertView actionSheet:@"Fashion Fanzone" message:@"" andButtonsWithTitle:@[@"Camera",@"Gallery"] dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if (index!=2) {
            UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
            imagePicker.sourceType = (index == 0)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
            [imagePicker setDelegate:self];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
       
    }];
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
    self.userInfoObj.userPhotoImage = image;

    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.photoImageView.hidden = YES;
    [cropViewController dismissAnimatedFromParentViewController:self withCroppedImage:image toFrame:CGRectMake(self.photoImageView.frame.origin.x, self.photoImageView.frame.origin.y + 64, self.photoImageView.frame.size.width, self.photoImageView.frame.size.height) completion:^{
        self.photoImageView.hidden = NO;
        
    }];
    
}


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
