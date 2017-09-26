//
//  FFCameraViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFCameraViewController.h"
#import "LLSimpleCamera.h"
#import "FFUtility.h"
#import "FFImageProcess.h"

@interface FFCameraViewController ()
{
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureSession *_captureSession;
    BOOL isSinglePic;
     BOOL isFlashFlow;
    NSInteger imageCount;
    FFImageProcess *imgProcessData;
    NSMutableArray *arrImgs;
}
@property (nonatomic, weak) IBOutlet UIView * headerCustomView;
@property (nonatomic, weak) IBOutlet UIView * cameraLayer;
@property (nonatomic, weak) IBOutlet UIButton * cameraButton ;
@property (nonatomic, weak) IBOutlet UIButton * flashButton ;
@property (nonatomic, weak) IBOutlet UIButton * switchButton ;
@property (nonatomic, weak) IBOutlet UIButton * singlePicButton ;
@property (nonatomic, weak) IBOutlet UIButton * multiPicButton ;
@property (nonatomic, weak) IBOutlet UIButton * darkRoomButton ;
@property (nonatomic, weak) IBOutlet UIButton * optionButton1 ;
@property (nonatomic, weak) IBOutlet UIButton * optionButton2 ;
@property (nonatomic, weak) IBOutlet UIButton * optionButton3 ;


@property (nonatomic, weak) IBOutlet UIImageView * darkroomImage ;


@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;

@property (strong, nonatomic) IBOutlet UIView *headerColorView;

@end

@implementation FFCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singlePicButton.hidden = YES;
    self.multiPicButton.hidden = YES;
    self.darkRoomButton.hidden = YES;
    self.darkroomImage.hidden = YES;
    self.headerCustomView.hidden = NO;
    _cameraLayer.hidden = YES;
    self.cameraButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cameraButton.layer.borderWidth = 4;
    self.cameraButton.layer.cornerRadius = self.cameraButton.frame.size.height/2;
    [self customCamera];
    [self.singlePicButton addTarget:self action:@selector(takeSinglePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.multiPicButton addTarget:self action:@selector(takeMultiplePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.camera start];
    imageCount = 0;
    [[FFUtility sharedInstance] initArr];
    _optionButton2.hidden = YES;
    _optionButton3.hidden = YES;
     isFlashFlow = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)customCamera
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    [self.view sendSubviewToBack:self.camera.view];
    
    
  
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == LLCameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    imageCount = 0;
    arrImgs = [[NSMutableArray alloc]init];;

    [_cameraButton setTitle:@"" forState:UIControlStateNormal];
    [super viewWillAppear:YES];
    if (!_isMessaging) {
       //  [self takeSinglePic:nil];
    }
   
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) { //hide status bar
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
       // [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }

}
- (void)viewWillDisappear:(BOOL)animated
{
    imageCount = 0;

    [super viewWillDisappear:animated];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark-
#pragma mark IBAction methods **********

-(IBAction)optionButtonClicekd:(id)sender
{
    UIButton * senderBtn = (UIButton*)sender;
    NSString * title = senderBtn.titleLabel.text;
    NSArray * rry = [title componentsSeparatedByString:@" "];
    if (rry.count==1) {
        [_optionButton1 setTitle:[NSString stringWithFormat:@"v %@", rry[0]] forState:UIControlStateNormal];
        title = rry[0];
    }
    else
    {
       [_optionButton1 setTitle:[NSString stringWithFormat:@"v %@", rry[1]] forState:UIControlStateNormal];
        title = rry[1];
    }
    if ([senderBtn isEqual:_optionButton1]) {
        // option close option
        if (_optionButton2.isHidden) {
            _optionButton2.hidden = NO;
            _optionButton3.hidden = NO;
        }
        else
        {
            _optionButton2.hidden = YES;
            _optionButton3.hidden = YES;
        }
    }
    else
    {
        if ([title isEqualToString:@"FLASH-FLOW"]) {
            [_optionButton2 setTitle:@"CAMERA" forState:UIControlStateNormal];
            [_optionButton3 setTitle:@"DARKROOM" forState:UIControlStateNormal];
        }
        if ([title isEqualToString:@"DARKROOM"]) {
            [_optionButton2 setTitle:@"FLASH-FLOW" forState:UIControlStateNormal];
            [_optionButton3 setTitle:@"CAMERA" forState:UIControlStateNormal];
        }
        if ([title isEqualToString:@"CAMERA"]) {
            [_optionButton2 setTitle:@"FLASH-FLOW" forState:UIControlStateNormal];
            [_optionButton3 setTitle:@"DARKROOM" forState:UIControlStateNormal];
        }
         [self manageFlowWithTitle:title];
    }
}

-(void)manageFlowWithTitle:(NSString*)title
{
    _optionButton2.hidden = YES;
    _optionButton3.hidden = YES;
    isFlashFlow = NO;
    if ([title isEqualToString:@"FLASH-FLOW"]) {
        isFlashFlow = YES;
    }
    if ([title isEqualToString:@"DARKROOM"]) {
        
        NSMutableArray *arr = [[FFUtility sharedInstance] multipleImgArr];
        FFDarkRoomViewController * controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"FFDarkRoomViewController"];
        controller.preclickedImageArray = arr;
        controller.isFromCameraClick = isFlashFlow;
        [self.navigationController pushViewController:controller animated:NO];
        _optionButton2.hidden = YES;
        _optionButton3.hidden = YES;
    }
    if ([title isEqualToString:@"CAMERA"]) {
        isSinglePic = NO;
    }
}
-(IBAction)takeSinglePic:(id)sender
{
    self.multiPicButton.hidden = NO;
    isSinglePic = YES;
     self.singlePicButton.hidden = YES;
    self.darkRoomButton.hidden = YES;
    self.darkroomImage.hidden = YES;
}
-(IBAction)takeMultiplePic:(id)sender
{
    self.singlePicButton.hidden = NO;
    isSinglePic = NO;
     self.multiPicButton.hidden = YES;
    self.darkRoomButton.hidden = NO;
    self.darkroomImage.hidden = NO;
}
-(IBAction)callBack:(id)sender
{
   
    [self.navigationController popViewControllerAnimated:NO];
}
/* camera button methods */

- (IBAction)switchButtonPressed:(UIButton *)button
{
   [UIView transitionWithView:button duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    }completion:nil];
    
    [self.camera togglePosition];
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (IBAction)flashButtonPressed:(UIButton *)button
{
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (IBAction)snapButtonPressed:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    
        if (imageCount == 10) {
            
            [[AlertView sharedManager] presentAlertWithTitle:nil message:@"You can take only 10 images at a time." andButtonsWithTitle:[NSArray arrayWithObject:@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString * title)
             {
                 
             }];
            return;
        }
    
            [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
                if(!error) {
                    self.darkRoomButton.hidden = NO;
                    if (isSinglePic) {
                        _modalPost.postImage = nil;
                        _modalPost.postImageArray = nil; //
                        FFImageColourPickerVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFImageColourPickerVC"];
                        imageVC.imageObject = image;
                        imageVC.isFromCameraClick = YES;
                        if (_isMessaging) {
                            imageVC.isMessaging = YES;
                            imageVC.modalPost = _modalPost;
                        }
                        [weakSelf.navigationController pushViewController:imageVC animated:NO];
                    }
                    else
                    {
                        _modalPost.postImage = nil;
                        _modalPost.postImageArray = nil;
                        imageCount += 1;
                        if (imageCount == 0) {
                            [button setTitle:@"" forState:UIControlStateNormal];
                        } else {
                            imgProcessData = [[FFImageProcess alloc]init];
                            imgProcessData.oldImage = image;
                            [arrImgs addObject:imgProcessData];
                            [[FFUtility sharedInstance] saveMultipleImg:arrImgs];
                            [button setTitle:[@(imageCount) stringValue] forState:UIControlStateNormal];
                        }
                    }
                }
                else {
                    NSLog(@"An error has occured: %@", error);
                }
            } exactSeenImage:YES];
    
 
}

- (IBAction)darkButtonPressed:(UIButton *)button
{
    NSMutableArray *arr = [[FFUtility sharedInstance] multipleImgArr];
    FFDarkRoomViewController * controller  = [self.storyboard instantiateViewControllerWithIdentifier:@"FFDarkRoomViewController"];
    controller.preclickedImageArray = arr;
    controller.isFromCameraClick = isFlashFlow;
    [self.navigationController pushViewController:controller animated:NO];
}

/* other lifecycle methods */

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.camera.view.frame = self.view.frame;
    
}


@end
