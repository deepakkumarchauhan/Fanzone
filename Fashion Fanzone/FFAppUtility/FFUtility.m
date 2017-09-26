//
//  FFUtility.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFUtility.h"
#import "Macro.h"
#import "FFDirectMessageViewController.h"
@implementation FFUtility
+ (id)sharedInstance
{
    static FFUtility *  sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)initArr
{
    _multipleImgArr = [[NSMutableArray alloc]init];
}
- (void)saveSharedImage:(UIImage*)img
{
    _sharedImageForTextEditor = img;
}

- (void)saveMultipleImg:(NSMutableArray*)imgArr
{
    _multipleImgArr = imgArr;
}
#pragma mark- Get Custom Buttons----

-(UIButton* )getButtonWithFrame:(CGRect )frame andBackImage:(UIImage*)image
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    button.frame = frame;
    return button;
}


#pragma mark---- validate Email address----
-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; 
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+(NSString*)getJSONFromDict:(NSDictionary*)dict{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
        return @"";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


+(void)commingSoonAlert:(UIViewController*)controller
{
    [[AlertView sharedManager] presentAlertWithTitle:@"This feature comming soon" message:nil andButtonsWithTitle:[NSArray arrayWithObjects:@"OK", nil] onController:controller dismissedWith:^(NSInteger index, NSString * titlestring){
        
    }];
}


+(void)callBackMessages:(UIViewController*)controller
{
    for (UIViewController * subViewControler in controller.navigationController.viewControllers) {
        if ([subViewControler isKindOfClass:[FFDirectMessageViewController class]]) {
            [controller.navigationController popToViewController:subViewControler animated:YES];
        }
    }
}
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    CGSize imagesize = imageToCrop.size;
    if (imagesize.width> 2 * MainScreenWidth) {
        imagesize.width = 2 * MainScreenWidth;
    }
    if (imagesize.height > 2* MainScreenHeight) {
        imagesize.height = 2* MainScreenHeight;
    }
    UIGraphicsBeginImageContext(imagesize);
    [imageToCrop drawInRect:CGRectMake(0,0,imagesize.width,imagesize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);
    UIImage * cropped = [UIImage imageWithData:data];
    return cropped;
}


+(UIImage*)resizeImage:(UIImage *)image
{
    CGSize imagesize = image.size;
    if (imagesize.width> 2 * MainScreenWidth) {
        imagesize.width = 2 * MainScreenWidth;
    }
    if (imagesize.height > 2* MainScreenHeight) {
        imagesize.height = 2* MainScreenHeight;
    }
    UIGraphicsBeginImageContext(imagesize);
    [image drawInRect:CGRectMake(0,0,imagesize.width,imagesize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return  newImage;
    
}
@end
