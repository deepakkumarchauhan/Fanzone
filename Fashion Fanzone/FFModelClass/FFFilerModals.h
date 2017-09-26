//
//  FFFilerModals.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 12/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface FFFilerModals : NSObject
+ (id)sharedInstance;
-(void)initializeObjects;
-(UIImage*)colourInvertedForImage:(UIImage*)originalImage;
-(UIImage*)getNoiseImageFilterForImage:(UIImage*)image andValue:(double)value;

@property (nonatomic, strong)  CIContext * context;
@end
