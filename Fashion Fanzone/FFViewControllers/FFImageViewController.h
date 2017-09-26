//
//  FFImageViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface FFImageViewController : UIViewController
@property (nonatomic, strong)  UIImage * image;
@property (nonatomic, assign)BOOL  isFromCameraClick;
@property (nonatomic, strong) FFPostModal * modalPost;
@property (nonatomic, assign) BOOL isMessaging;
- (instancetype)initWithImage:(UIImage *)image;
@end
