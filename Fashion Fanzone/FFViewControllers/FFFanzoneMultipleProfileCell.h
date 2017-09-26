//
//  FFFanzoneMultipleProfileCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 27/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFanzoneMultipleProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * photoImageView1;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView1;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel1;
@property (weak, nonatomic) IBOutlet UITextView * descriptionLabel1;

@property (weak, nonatomic) IBOutlet UIImageView * photoImageView2;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView2;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel2;
@property (weak, nonatomic) IBOutlet UITextView * descriptionLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionView1WidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionView1WidthFinalConstraint;
@property (strong, nonatomic) IBOutlet UILabel *firstCommentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLikeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondCommentCountLabel;

@property (strong, nonatomic) IBOutlet UILabel *secondLikeCountLabel;

@end
