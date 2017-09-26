//
//  FFConnectionListViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface FFConnectionListViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView * tbleView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, strong)  NSString * concernUser_id;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end
