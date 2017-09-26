//
//  FFFanzoneMultipleProfileCell.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 27/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFFanzoneMultipleProfileCell.h"
#import "Macro.h"
@implementation FFFanzoneMultipleProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    if (MainScreenWidth>320) {
         self.contentViewLeftConstraint.constant =200;
        self.descriptionView1WidthConstraint.constant = 190;
    }
    if (MainScreenWidth>375) {
       // self.contentViewLeftConstraint.constant =210;
       // self.descriptionView1WidthConstraint.constant = 190;
       // self.descriptionView1WidthFinalConstraint.constant = 20;
    }
    
   
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
