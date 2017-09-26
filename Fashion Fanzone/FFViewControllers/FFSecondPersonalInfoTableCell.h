//
//  FFSecondPersonalInfoTableCell.h
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSecondPersonalInfoTableCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel  *bioLabel;
@property (strong ,nonatomic) IBOutlet UITextView   *bioTextView;
@end
