//
//  FFAcocuntTypeViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFUserInfo.h"

@interface FFAcocuntTypeViewController : UIViewController

@property (strong, nonatomic) FFUserInfo *userInfoObj;

@property (nonatomic, weak) IBOutlet UISegmentedControl * segmentController;
@property (nonatomic, weak) IBOutlet UITextField * firstNameTxtFld;
@property (nonatomic, weak) IBOutlet UITextField * lastNameTxtFld;
@property (nonatomic, weak) IBOutlet UITextField * businessNametxtFld;

-(IBAction)continueBtnClicked:(id)sender;
-(IBAction)segmentChanged:(UISegmentedControl *)controller;
-(IBAction)callBack:(id)sender;


@end
