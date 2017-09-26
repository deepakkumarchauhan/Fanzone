//
//  FFEditProfileViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 28/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol EditProfileProtocol <NSObject>

- (void)callProfileApi;

@end
@interface FFEditProfileViewController : UIViewController<UIImagePickerControllerDelegate , UINavigationControllerDelegate>
@property(assign,nonatomic) BOOL isFromUserName;
@property(nonatomic,weak) id<EditProfileProtocol> delegate;

@end
