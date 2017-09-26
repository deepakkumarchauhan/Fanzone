//
//  FFPostCommentsTableViewCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeableCellDelegate <NSObject>

- (void)buttonOneActionForItemText:(NSInteger)index;
- (void)buttonTwoActionForItemText:(NSInteger)index;
- (void)buttonThreeActionForItemText:(NSInteger)index;
- (void)buttonFourActionForItemText:(NSInteger)index;
- (void)cellDidOpen:(UITableViewCell *)cell;
- (void)cellDidClose:(UITableViewCell *)cell;

@end


@interface FFPostCommentsTableViewCell : UITableViewCell

@property (nonatomic, weak)IBOutlet UILabel * nameLabel;
@property (nonatomic, weak)IBOutlet UITextView * postDecription;
@property (nonatomic, weak)IBOutlet UIImageView * userProfileImageView;
@property (nonatomic, weak)IBOutlet UIButton * likeBtn;
@property (nonatomic, weak)IBOutlet UIButton * exportBtn;
@property (nonatomic, weak)IBOutlet UIButton * deleteBtn;
@property (nonatomic, weak)IBOutlet UIButton * shareBtn;
@property (nonatomic, weak)IBOutlet UIView * myContentView;

@property (strong, nonatomic) IBOutlet UIButton *commentImageButton;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;


@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;


- (void)openCell;
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)notifyDelegate;
-(void)setIndexForCellContent:(NSInteger)index;
@end
