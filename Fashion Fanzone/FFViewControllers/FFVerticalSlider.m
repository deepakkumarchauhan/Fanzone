//
//  FFVerticalSlider.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFVerticalSlider.h"
#import <UIKit/UIKit.h>

@implementation FFVerticalSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sliderImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, self.frame.size.width-8, self.frame.size.height)];
        self.sliderImage.image = [UIImage imageNamed:@"line"];
        self.thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.width)];
        self.thumbImage.image =[ UIImage imageNamed:@"cir"];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sliderImage];
        [self addSubview:self.thumbImage];
        [self.sliderDelegate getSliderValueWith: self.thumbImage.center.y/self.frame.size.height];
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.thumbImage.frame, touchPoint)) {
        
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    _shouldPassVal = NO;
    if (CGRectContainsPoint(self.thumbImage.frame, touchPoint)  && (touchPoint.y +self.thumbImage.frame.size.width/2)<self.frame.size.height ) {
        
        if (touchPoint.y >=self.thumbImage.frame.size.width/2) {
            CGPoint center = self.thumbImage.center;
            center.y = touchPoint.y;
            self.thumbImage.center = center;
            _passVal = center.y/self.frame.size.height;
            _shouldPassVal = YES;
           // [self.sliderDelegate getSliderValueWith: center.y/self.frame.size.height];
            NSLog(@"point == %f", self.thumbImage.center.y);
        }
        
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    if (_shouldPassVal) {
        [self.sliderDelegate getSliderValueWith: _passVal];
    }
}
@end
