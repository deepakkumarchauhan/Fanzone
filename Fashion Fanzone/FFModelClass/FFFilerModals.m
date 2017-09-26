//
//  FFFilerModals.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 12/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFFilerModals.h"
#import "FFImageProcess.h"
@implementation FFFilerModals

+ (id)sharedInstance
{
    static FFFilerModals *  sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)initializeObjects
{
     _context = [CIContext contextWithOptions:nil];
}

-(UIImage*)colourInvertedForImage:(UIImage*)originalImage //filter 17 , filter 4 = noise
{
    CIImage * cIImage = [[CIImage alloc]initWithImage:originalImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert" keysAndValues: kCIInputImageKey,cIImage,nil];
    CIImage * outputImage = [filter outputImage];
    CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    return  [UIImage imageWithCGImage:cgimg];
}
-(UIImage*)getNoiseImageFilterForImage:(UIImage*)image andValue:(double)value
{
    UIImage * imagege = [[FFImageProcess sharedInstance] noise:value];
    return imagege;
}
@end
