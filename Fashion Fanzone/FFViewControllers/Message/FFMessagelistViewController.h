//
//  FFMessagelistViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMessagelistViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView * tableview;
@property (nonatomic, weak) IBOutlet UIButton  * onGoingChatBtn;
@property (nonatomic, weak) IBOutlet UIButton * requestChatBtn;
@property (assign, nonatomic) NSInteger index;

-(IBAction)callBack:(id)sender;
-(IBAction)ongoingBtnClicked:(id)sender;
-(IBAction)requestBtnClicked:(id)sender;

@end
