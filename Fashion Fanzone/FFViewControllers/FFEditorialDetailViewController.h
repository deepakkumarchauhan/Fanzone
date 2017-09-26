//
//  FFEditorialDetailViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 19/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "FFFanzoneModelInfo.h"

@interface FFEditorialDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) FFFanzoneModelInfo *obj_detail;

@end
