//
//  FFSettingTableCell.h
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSettingTableCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel    *settingLabel;
@property(strong,nonatomic) IBOutlet UISwitch   *settingSwitch;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@end
