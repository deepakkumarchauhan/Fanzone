//
//  FFEffectsScrollView.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 16/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFEffectsScrollView.h"

@implementation FFEffectsScrollView

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
        
        [self manageContents];
        self.frame = frame;
        
    }
    return self;
}


-(void)manageContents
{
    int xVal = 10;
    int width = 90;
    int height = 60;
    _optionArray = [NSArray arrayWithObjects:@"HUE",@"POSTER",@"GLOOM",@"SHADOW",@"SPOT",@"BLOOM",@"PIXELLATE",nil];
    for (int i=0; i<_optionArray.count; i++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xVal, 5, width, height)];
        label.tag = i;
        label.backgroundColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0f blue:255.0/255.0f alpha:1] colorWithAlphaComponent:1.0];
        NSString * stringText = [_optionArray[i] uppercaseString];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, stringText.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        label.attributedText = mat ;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.opacity = 0.5f;
        label.font = AppFontBOLD(16);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClicked:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        [self addSubview:label];
        xVal = xVal+width+10;
    }
    
    self.contentSize = CGSizeMake(xVal, 10);
}

-(void)filterClicked:(UITapGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)gesture.view;
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel*)view;
            lbl.textColor = [UIColor blackColor];
        }
    }
    label.textColor = [[UIColor colorWithRed:65.0/255.0 green:204.0/255.0f blue:254.0/255.0f alpha:1] colorWithAlphaComponent:0.5];
    label.font = AppFontBOLD(16);
    [self.delegateMethods imageEffectsIndexGet:label.tag];
    
}

@end
