//
//  FFProfileViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 30/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "FFFanzoneModelInfo.h"
#import "FFDirectMessageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

@interface FFProfileViewController : UIViewController

//@property (nonatomic, weak) IBOutlet UIView * containerView;

@property (nonatomic, assign) BOOL isUserSelfProfile;
@property (nonatomic, assign) BOOL isFromConnection;
@property (nonatomic, strong)  FFFanzoneModelInfo * obj_detail;
@property (nonatomic, strong)  NSString * concernUser_id;


@end
