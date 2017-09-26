//
//  FFprofileDetailViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 31/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface FFprofileDetailViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView * tableView;
@property (nonatomic, assign) BOOL isEditOption;
@end
