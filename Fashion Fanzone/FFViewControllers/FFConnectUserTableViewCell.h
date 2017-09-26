//
//  FFConnectUserTableViewCell.h
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 09/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFConnectUserTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *stylePointsLabel;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@end
