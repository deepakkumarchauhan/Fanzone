//
//  FFVursesTableViewCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFVursesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView * photoImageView1;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView1;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel1;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel1;
@property (weak, nonatomic) IBOutlet UITextView * descriptionLabel1;

@property (weak, nonatomic) IBOutlet UIButton * photoImage1Btn;

@property (weak, nonatomic) IBOutlet UIImageView * photoImageView2;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView2;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel2;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel2;
@property (weak, nonatomic) IBOutlet UITextView * descriptionLabel2;
@property (weak, nonatomic) IBOutlet UIButton * photoImage2Btn;
@property (strong, nonatomic) IBOutlet UILabel *firstCommentVsLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstLikeVsLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondVsCommentLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondVsLikeLabel;


@end
