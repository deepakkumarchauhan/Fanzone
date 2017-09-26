//
//  FFPersonalInfoTableCell.h
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface FFPersonalInfoTableCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel  *personalInfoLabel;
@property (nonatomic,strong) IBOutlet FFTextField  *personalInfoTextFeilds;
@end
