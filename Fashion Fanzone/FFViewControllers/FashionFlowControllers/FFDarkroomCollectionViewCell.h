//
//  FFDarkroomCollectionViewCell.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFDarkroomCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIView * selctView;
@property (nonatomic,assign) BOOL isSelected;
@end
