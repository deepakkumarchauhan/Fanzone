//
//  FFSignUpEmailViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFUserInfo.h"

@interface FFSignUpEmailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *emailTxtFld;

@property (strong, nonatomic) FFUserInfo *userInfoObj;

-(IBAction)continueBtnClicked:(id)sender;
-(IBAction)callBack:(id)sender;
@end
