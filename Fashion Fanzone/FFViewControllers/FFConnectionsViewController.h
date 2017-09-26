//
//  FFConnectionsViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface FFConnectionsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton * recentBtn;
@property (nonatomic, weak) IBOutlet UIButton * connectionsBtn;
@property (nonatomic, weak) IBOutlet UIButton * followersBtn;
@property (strong, nonatomic) FFUserInfo *userInfoObj;
@property (nonatomic, strong)  NSString * concernUser_id;

@end
