//
//  ImageCollectionViewCell.h
//  FBLikeLayout Sample
//
//  Created by Giuseppe Lanza on 18/01/15.
//  Copyright (c) 2015 La Nuova Era. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * stylePointLabel;
@property (weak, nonatomic) IBOutlet UILabel * descriptionLabel;


@end
