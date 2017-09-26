//
//  FFImageProcess.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 07/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FFImageProcess : UIImage
{
    CIFilter *filterContrast;
    CIFilter *filterBrightNess;
    CIContext *context;

}
@property (nonatomic, strong) UIImage * oldImage;
@property (nonatomic, assign) BOOL iselected;



+ (id)sharedInstance;
-(void)setOldImage:(UIImage *)oldimage;
- (UIImage*) saturation:(CGFloat)s;
- (UIImage*) setContrast:(CGFloat)s WithImage:(UIImage *)image;
- (UIImage*) setBrightNess:(CGFloat)s WithImage:(UIImage *)image;
- (UIImage*)brightness:(double)amount;
- (UIImage*)contrast:(double)amount;
- (UIImage*)noise:(double)amount;
#pragma mark-
#pragma mark Apply Heu-

- (UIImage*)applyHeuEffect:(UIImage*)image withSliderValue:(CGFloat)value;
- (UIImage*)applyPosterEffect:(UIImage*)image withSliderValue:(CGFloat)value;
- (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName withSliderValue:(CGFloat)sliderVal;
-(UIImage*)porcessImage:(UIImage*)inputImage forIndexValue:(NSInteger)index withSliderValue:(CGFloat)sliderVal;
-(UIImage*) imageSaturation:(UIImage*)inputImage withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyHueEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyposterEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyGloomEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyBloomEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyShadowEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applySpotEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
- (UIImage*)applyPixellateEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal;
-(UIImage *)processImageForEffectsWithImage:(UIImage*)inputImage andSliderVal:(CGFloat)sliderVal andIndex:(NSInteger)indexVal;







@end
