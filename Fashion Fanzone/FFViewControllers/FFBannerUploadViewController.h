//
//  FFBannerUploadViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFUserInfo.h"

@interface FFBannerUploadViewController : UIViewController<UIImagePickerControllerDelegate , UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView * photoView;
@property (nonatomic, weak) IBOutlet UIImageView * photoImageView;
@property (strong, nonatomic) FFUserInfo *userInfoObj;


-(IBAction)uploadPhotoBtn:(id)sender;
-(IBAction)continueBtnClicked:(id)sender;
-(IBAction)callBack:(id)sender;
@end
