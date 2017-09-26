//
//  FFTextField.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFTextField.h"
#import "Macro.h"

@interface FFTextField ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIView *paddingView;
@property (strong, nonatomic) UIColor *errorColor;
@property (strong, nonatomic) UIColor *normalColor;

@end

@implementation FFTextField

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setFont:AppFont(self.font.pointSize)];
    
}

- (void)addPaddingViewWithWidth: (CGFloat)width andHeight: (CGFloat)height {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    
    if(self){
        [self defaultSetup];
    }
    
    return self;
}

#pragma mark - Private methods

- (void)defaultSetup {
    
    self.errorColor = [UIColor clearColor];
    self.normalColor = [UIColor clearColor];
    
    self.layer.cornerRadius = 2.0f;
    //  self.layer.borderColor = [self.normalColor CGColor];
    // self.layer.borderWidth = 1.0f;
    self.clipsToBounds = YES;
    [self setBorderStyle:UITextBorderStyleNone];
    // self.font = [UIFont systemFontSize:15];
    [self placeHolderText:self.placeholder];
    
    
}

- (void)addPaddingWithValue:(CGFloat )value {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, value, self.frame.size.height)];
    [self setLeftView:paddingView];
    paddingView.tag = 998;
    self.paddingView = paddingView;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
}

- (void)addplaceHolderImageInsideView:(UIView *)view placeHolderImage:(UIImage *)image {
    UIImageView *placeHolderImageView = [view viewWithTag:999];
    if (!placeHolderImageView) {
        placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        placeHolderImageView.tag = 999;
        [view addSubview:placeHolderImageView];
        [placeHolderImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    [placeHolderImageView setImage:image];
    placeHolderImageView.center = CGPointMake(view.frame.size.width  / 2,
                                              view.frame.size.height / 2);
    
    self.iconImageView = placeHolderImageView;
    
}

- (void)setPlaceholderImage:(UIImage *)iconImage {
    if (iconImage) {
        [self setPaddingIcon:iconImage];
    }
}

#pragma mark - Public methods
- (void)error:(BOOL)status {
    self.layer.borderColor = status ? [self.errorColor CGColor]:[self.normalColor CGColor];
}

- (void)setPaddingIcon:(UIImage *)iconImage {
    
    [self addplaceHolderImageInsideView:self.paddingView placeHolderImage:iconImage];
}
- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}

- (void)placeHolderText:(NSString *)text {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: TextFieldPlaceHolderColor, NSFontAttributeName:AppFont(self.font.pointSize)}];
    }
}

- (void)placeHolderTextWithColor:(NSString *)text :(UIColor *)color {
    if (text.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:142.9/250.0 green:190.0/255.0 blue:62.0/255.0 alpha:1.0]}];
    }
}

@end
