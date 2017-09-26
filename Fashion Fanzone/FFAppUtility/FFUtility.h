//
//  FFUtility.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Macro.h"
#import "FFImageProcess.h"

@interface FFUtility : NSObject

@property (nonatomic, strong) UIImage * sharedImageForTextEditor;
@property (nonatomic, strong) NSMutableArray *multipleImgArr;

+ (id)sharedInstance;
- (UIButton* )getButtonWithFrame:(CGRect )frame andBackImage:(UIImage*)image;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
+(void)commingSoonAlert:(UIViewController*)controller;
- (void)saveSharedImage:(UIImage*)img;
- (void)saveMultipleImg:(NSMutableArray*)imgArr;
- (void)initArr;
+(UIImage*)resizeImage:(UIImage *)image;
+(NSString*)getJSONFromDict:(NSDictionary*)dict;
+(void)callBackMessages:(UIViewController*)controller;
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect;
@end
