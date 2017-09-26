//
//  FFMessageListTableCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMessageListTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView * toUserImage;
@property (nonatomic, weak) IBOutlet UIImageView * fromUserImage;
@property (nonatomic, weak) IBOutlet UIImageView * indicatorArraowImageView;
@property (nonatomic, weak) IBOutlet UILabel  * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * descriptionsLabel;
@end
