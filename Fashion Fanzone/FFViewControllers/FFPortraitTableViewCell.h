//
//  FFPortraitTableViewCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 28/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFPortraitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel;
@property (weak, nonatomic) IBOutlet UITextView * descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentCount;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton * photoImageBtn;
@end
