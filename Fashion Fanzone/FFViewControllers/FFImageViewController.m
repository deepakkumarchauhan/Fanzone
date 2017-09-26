//
//  FFImageViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFImageViewController.h"

@interface FFImageViewController ()
{
    NSString * optionString;
}
@property (nonatomic, weak) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIView * headerView;
@property (nonatomic, weak) IBOutlet UIButton * constrastButton;
@property (nonatomic, weak) IBOutlet UIButton * brightnessButton;
@property (nonatomic, weak) IBOutlet UIButton * colourButton;
@property (nonatomic, weak) IBOutlet UIButton * publishButton;
@property (nonatomic, weak) IBOutlet UISlider * sliderView;
@property (nonatomic, weak) IBOutlet UIButton *  sendButton;
@property (nonatomic, weak) IBOutlet UIImageView *  nextIcon;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFImageViewController

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    optionString = @"";
    _imageView.image = _image;
    if (!_image) {
        _imageView.image = [UIImage imageNamed:@"user"];
        _image = [UIImage imageNamed:@"user"];
    }
    if (_isMessaging) {
        _sendButton.hidden = NO;
        _nextIcon.hidden = NO;
        _publishButton.hidden = YES;
        [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        _sendButton.hidden = YES;
        _nextIcon.hidden = YES;
        _publishButton.hidden = NO;
    }
    
    // Set Initial Brightness selected
    [self setInitialBrightnessSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
}

- (void)setInitialBrightnessSelected {
    
    optionString = KBrightness;
    _sliderView.value = 0.5;
    [[FFImageProcess sharedInstance] setOldImage:_image] ;
    [self makeAllButtonWhiteColour];
    [self setButton:_brightnessButton colourWithColour:[UIColor colorWithRed:85.0/255.0f green:215.0/255.0f blue:255.0/255.0f alpha:1]];

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark-
#pragma mark IBAction methods **********
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)hideAllControles:(id)sender
{
    if (_constrastButton.frame.origin.x==1) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _constrastButton.frame;
            frame.origin.x = -100;
            _constrastButton.frame = frame;
            frame = _brightnessButton.frame;
            frame.origin.x = -100;
            _brightnessButton.frame = frame;
            
            frame = _colourButton.frame;
            frame.origin.x = -100;
            _colourButton.frame = frame; //publishButton
            
            frame = _publishButton.frame;
            frame.origin.y = MainScreenHeight+10;
            _publishButton.frame = frame; //publishButton
            
            frame = _sliderView.frame;
            frame.origin.y =   MainScreenHeight+10;
            _sliderView.frame = frame; //publishButton
            
            frame = _headerView.frame;
            frame.origin.y =   -100;
            _headerView.frame = frame; //publishButton
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = _constrastButton.frame;
            frame.origin.x = 1;
            _constrastButton.frame = frame;
            
            frame = _brightnessButton.frame;
            frame.origin.x = 1;
            _brightnessButton.frame = frame;
            
            frame = _colourButton.frame;
            frame.origin.x = 1;
            _colourButton.frame = frame;
            
            frame = _publishButton.frame;
            frame.origin.y = MainScreenHeight-(35+18);
            _publishButton.frame = frame;
            
            frame = _sliderView.frame;
            frame.origin.y = MainScreenHeight-(35+18+30+8);;
            _sliderView.frame = frame;
            
            frame = _headerView.frame;
            frame.origin.y =   0;
            _headerView.frame = frame; //publishButton
            
        }];
    }
}

-(IBAction)contrastButtonClicked:(id)sender
{
    optionString = KContrast;
    _sliderView.value = 0.5;
    [[FFImageProcess sharedInstance] setOldImage:_image] ;
    [self makeAllButtonWhiteColour];
    [self setButton:_constrastButton colourWithColour:[UIColor colorWithRed:85.0/255.0f green:215.0/255.0f blue:255.0/255.0f alpha:1]];
}
-(IBAction)brigtnessBtnClicked:(id)sender
{
    optionString = KBrightness;
    _sliderView.value = 0.5;
     [[FFImageProcess sharedInstance] setOldImage:_image] ;
    [self makeAllButtonWhiteColour];
     [self setButton:_brightnessButton colourWithColour:[UIColor colorWithRed:85.0/255.0f green:215.0/255.0f blue:255.0/255.0f alpha:1]];
    
}
-(IBAction)colourButtonClicekd:(id)sender
{
    
    optionString = KSaturation;
    _sliderView.value = 0.5;
     [self makeAllButtonWhiteColour];
    [self setButton:_colourButton colourWithColour:[UIColor colorWithRed:85.0/255.0f green:215.0/255.0f blue:255.0/255.0f alpha:1]];
     _imageView.image = _image;
 
}

-(void)sendButtonClicked:(id)sender
{
    [self showLoader];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSData * data = UIImagePNGRepresentation(_imageView.image);
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self callApiForMessaging:base64];
        });
    });
}
-(IBAction)publishButtonClicekd:(id)sender
{
    if (_isMessaging) {
        
        [self showLoader];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            NSData * data = UIImagePNGRepresentation(_imageView.image);
            NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self callApiForMessaging:base64];
            });
        });

    }
    else{
        UIImage * imgeToPublish = _imageView.image;
        FFCaptionViewController * colorpickerController = (FFCaptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFCaptionViewController"];
        colorpickerController.imageToPublish = imgeToPublish;
        colorpickerController.isFromCameraClick = self.isFromCameraClick;
        [self.navigationController pushViewController:colorpickerController animated:YES];
    }
    
}
-(void)makeAllButtonWhiteColour
{
    [self setButton:_constrastButton colourWithColour:[UIColor whiteColor]];
    [self setButton:_brightnessButton colourWithColour:[UIColor whiteColor]];
    [self setButton:_colourButton colourWithColour:[UIColor whiteColor]];
    
}

-(void)setButton:(UIButton*)button colourWithColour:(UIColor *)colour
{
    [button setTitleColor:colour forState:UIControlStateNormal];
}



#pragma mark-
#pragma mark- Slider dragged----

-(IBAction)sliderDragged:(UISlider*)slider
{
    CGFloat value = slider.value;
    if ([optionString isEqualToString:KContrast]) {
        _imageView.image = [[FFImageProcess sharedInstance] contrast:(1+value-0.5)];  //setup contrast over image
    }
    if ([optionString isEqualToString:KBrightness]) {
    _imageView.image = [[FFImageProcess sharedInstance] brightness:(1+value-0.5)]; //setup brightness over image
    }
    if ([optionString isEqualToString:KSaturation]) {
        
       _imageView.image =  [[FFImageProcess sharedInstance] imageSaturation:_image withSliderVal:value];
       
    }
}


#pragma mark - Call Api for messaging

-(void)callApiForMessaging:(NSString*)imageBase64
{
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiAddChat forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];//
    [dictRequest setValue:_modalPost.messageReceipent forKey:KReceiverID]; //message
    [dictRequest setValue:@"" forKey:KMessages];
    [dictRequest setValue:imageBase64 forKey:KMessagesImage];
    [dictRequest setValue:_modalPost.postTitle forKey:KTitle];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
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

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    [self.publishButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    [self.publishButton setTitle:@"PUBLISH" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
