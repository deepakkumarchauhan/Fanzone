//
//  FFChoosePasswordViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFUserInfo.h"

@interface FFChoosePasswordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField * choosePasswrdFld;
@property (nonatomic, weak) IBOutlet UITextField * repeatPasswrdFld;
@property (strong, nonatomic) FFUserInfo *userInfoObj;

-(IBAction)continueBtnClicked:(id)sender;

-(IBAction)callBack:(id)sender;
@end
