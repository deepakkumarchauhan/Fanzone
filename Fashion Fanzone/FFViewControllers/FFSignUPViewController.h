//
//  FFSignUPViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSignUPViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField * usernametextFld;
-(IBAction)continueBtnClicked:(id)sender;
-(IBAction)callBack:(id)sender;
@end
