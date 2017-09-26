//
//  FFDirectMessageViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface FFDirectMessageViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITableView * tableview;
@property (nonatomic, weak) IBOutlet UIButton  * onGoingChatBtn;
@property (nonatomic, weak) IBOutlet UIButton * requestChatBtn;
@property (nonatomic, weak) IBOutlet UILabel  * onGoingLabel;
@property (nonatomic, weak) IBOutlet UILabel * requestLabel;


-(IBAction)callBack:(id)sender;
-(IBAction)indexBtnClicked:(id)sender;
-(IBAction)ongoingBtnClicked:(id)sender;
-(IBAction)requestBtnClicked:(id)sender;
@end
