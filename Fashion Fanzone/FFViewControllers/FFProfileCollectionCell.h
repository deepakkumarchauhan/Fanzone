//
//  FFProfileCollectionCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 30/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFProfileCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView * storyImage;
@property (nonatomic, weak) IBOutlet UILabel * noOfLikes;
@property (nonatomic, weak) IBOutlet UILabel * noOfComments;
@property (nonatomic, weak) IBOutlet UIButton * exportButton;

@end
