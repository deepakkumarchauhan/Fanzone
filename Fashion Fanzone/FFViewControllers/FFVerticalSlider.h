//
//  FFVerticalSlider.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFVerticalSliderDelegate <NSObject>

-(void)getSliderValueWith:(float)sliderValue;

@end

@interface FFVerticalSlider : UIView

@property (nonatomic, weak) id<FFVerticalSliderDelegate>sliderDelegate;
@property (nonatomic, strong) UIImageView * sliderImage;
@property (nonatomic, strong) UIImageView * thumbImage;
@property (nonatomic, assign) BOOL shouldPassVal;
@property (nonatomic, assign) CGFloat passVal;
- (id)initWithFrame:(CGRect)frame;
@end
