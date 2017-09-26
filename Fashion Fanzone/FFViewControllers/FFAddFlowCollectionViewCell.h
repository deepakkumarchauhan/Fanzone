//
//  FFAddFlowCollectionViewCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 18/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAddFlowCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView * profileimage;
@property (nonatomic, weak) IBOutlet UILabel * decriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *backgroundButton;
@property (strong, nonatomic) IBOutlet UIView *bgAddView;

@end
