//
//  FFCaptionViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 18/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFCaptionViewController.h"
#import "IQKeyboardManager.h"


@interface FFCaptionViewController ()
@property (nonatomic, weak)IBOutlet UITextView * textView;
@property (nonatomic, weak)IBOutlet UITextField * textfld;
@property (nonatomic, strong) FFPostModal * modal;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation FFCaptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textfld.autocorrectionType  =  UITextAutocorrectionTypeNo;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _modal = [[FFPostModal alloc] init];
    _modal.postImage = _imageToPublish;
    _modal.gifImageData = _gifImagedatqa;
    [self manageImageArray];
    
    
    // Do any additional setup after loading the view.
}
-(void)manageImageArray
{
    NSMutableArray * tempArray = [NSMutableArray new];
    for (FFImageProcess * modal in _imageArrayToPublish) {
        [tempArray addObject:modal.oldImage];
    }
    _modal.postImageArray = tempArray;
    tempArray = nil;
    _imageArrayToPublish = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [_textfld becomeFirstResponder];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}




#pragma mark-
#pragma mark IBAction methods--


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)publishButtonClicked:(id)sender
{
    
    if (_isFromTextEditor) {
        [_textDitorDict setValue:_textView.text forKey:KCaption];
        [_textDitorDict setValue:_textfld.text forKey:KTitle];
        FFAddToFlowViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFAddToFlowViewController"];
        controller.textDitorDict = _textDitorDict;
        controller.isFromTextEditor = _isFromTextEditor;
        [self.navigationController pushViewController:controller animated:YES];
        return;
        
    }
    
    if ([self isValidCaption]) {
        
        if (self.isFromCameraClick) {
            [self makeWebApiCallForPublishFanzonePost];
        }
        else
        {
            _modal.postTitle = _textfld.text;
            _modal.postCatptions = _textView.text;
            FFAddToFlowViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFAddToFlowViewController"];
            controller.modalPost = _modal;
            controller.isFromCameraClick = self.isFromCameraClick;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}

// validate captions-


-(BOOL)isValidCaption
{
    return YES;
}




- (void)makeWebApiCallForPublishFanzonePost {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiFanzonePublish forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    if (self.modal.postImage != nil) {
       self.modal.postImage = [FFUtility resizeImage: self.modal.postImage];
        NSData *dataProfileImg = [NSData dataWithData:UIImageJPEGRepresentation(self.modal.postImage , 1.0)];
        [imageArray addObject:dataProfileImg];
    }else if (self.modal.postImageArray.count) {
        
        for (int index = 0; index < self.modal.postImageArray.count ; index++) {
            UIImage * imge = [self.modal.postImageArray objectAtIndex:index];
            NSData *dataProfileImg = [NSData dataWithData:UIImageJPEGRepresentation([FFUtility resizeImage: imge] , 1.0)];
            [imageArray addObject:dataProfileImg];
        }
    }
    if (self.modal.gifImageData) {
        [imageArray removeAllObjects];
        [imageArray addObject:self.modal.gifImageData];
    }
    [dictRequest setValue:imageArray forKey:KPublishImage];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlatitude] forKey:KDefaultlatitude];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlongitude] forKey:KDefaultlongitude];
    [dictRequest setValue:_textView.text forKey:KCaption];
    [dictRequest setValue:_textfld.text forKey:KTitle];
    [dictRequest setValue:@"flash-flow" forKey:KCategoryName];
    [dictRequest setValue:@"" forKey:KHtmlFanzoneContent];
    
    [[ServiceHelper_AF3 instance] makeMultipartWebApiCallWithParametersForMultipleFile:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if ([NSUSERDEFAULT boolForKey:@"imageTophoto"]) {
                    if (self.modal.postImage != nil) {
                        UIImageWriteToSavedPhotosAlbum(self.modal.postImage, nil, nil, nil);
                        
                    }else if (self.modal.postImageArray.count) {
                        
                        for (int index = 0; index < self.modal.postImageArray.count ; index++) {
                            
                            UIImageWriteToSavedPhotosAlbum([self.modal.postImageArray objectAtIndex:index], nil, nil, nil);
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
