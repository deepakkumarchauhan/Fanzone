//
//  FFPostDetailHeaderView.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFPostDetailHeaderView : UIView

@property (nonatomic, weak) IBOutlet UIImageView * userprofileImageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * stylePointLabel;
@property (nonatomic, weak) IBOutlet UITextView * descriptionView;
@property (nonatomic, weak) IBOutlet UILabel * noOfLikeLabel;
@property (nonatomic, weak) IBOutlet UILabel * noOfCommentsLabel;
@property (nonatomic, weak) IBOutlet UIButton * commentBtn;
@property (nonatomic, weak) IBOutlet UIButton * likeBtn;
@property (nonatomic, weak) IBOutlet UIButton * exportBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
