//
//  FFForgotPasswordViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFForgotPasswordViewController : UIViewController

@property(nonatomic, weak) IBOutlet UITextField * userNameFld;
-(IBAction)performForgetPassword:(id)sender;
-(IBAction)callBack:(id)sender;
@end
