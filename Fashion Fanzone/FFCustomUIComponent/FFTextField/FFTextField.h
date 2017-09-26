//
//  FFTextField.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTextField : UITextField

- (void)addPaddingViewWithWidth: (CGFloat)width andHeight: (CGFloat)height;

@property (nonatomic, setter=setPaddingValue:) IBInspectable NSInteger paddingValue;
@property (nonatomic, strong) IBInspectable UIImage *paddingIcon;

@property (strong, nonatomic) NSIndexPath *indexPath; // use if cell for getting easily the cell & txtfield

- (void)placeHolderText:(NSString *)text;
- (void)placeHolderTextWithColor:(NSString *)text :(UIColor *)color;
- (void)setPlaceholderImage:(UIImage *)iconImage;
- (void)error:(BOOL)status;

@end
