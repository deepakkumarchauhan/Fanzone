//
//  TempImageView.m
//  Collage
//
//  Created by Chandra Prakash on 17/04/17.
//  Copyright © 2017 Collage. All rights reserved.
//

#import "TempImageView.h"

@implementation TempImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * thisTouch = [touches anyObject];
    CGPoint thisPoint = [thisTouch locationInView:self];
    float newX = thisPoint.x + self.frame.origin.x;
    float newY = thisPoint.y + self.frame.origin.y;
    if (newX<0) {
        newX=0;
    }
    if (newY<0) {
        newY = 0;
    }
    else if (newY>250)
    {
        newY = 250;
    }
    self.center = CGPointMake(newX, newY);
}


@end
