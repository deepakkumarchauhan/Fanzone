//
//  ViewController.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/10/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//


#import "Macro.h"

@interface ViewController : UIViewController

@property (nonatomic,weak) IBOutlet FFTextField * userNameFld;
@property (nonatomic,weak) IBOutlet FFTextField * passwordFld;

-(IBAction)performSignUpPassword:(id)sender;

-(IBAction)performLogin:(id)sender;
@end

