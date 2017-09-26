//
//  FFConnectionListCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFConnectionListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView * userprofileImageview;
@property (nonatomic, weak) IBOutlet UIImageView * messageImageView;
@property (nonatomic, weak) IBOutlet UILabel * textlabel;
@property (nonatomic, weak) IBOutlet UIButton * followingButton;
@end
