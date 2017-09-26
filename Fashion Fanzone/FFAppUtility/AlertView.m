//
//  AlertView.m
//  Catalog
//
//  Created by Deepak Kumar on 8/18/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//


#import "AlertView.h"

@interface AlertView () <UIAlertViewDelegate>

@property (nonatomic, strong) AlertCompletionBlock completionBlock;

@end

@implementation AlertView

+ (instancetype)sharedManager {
    
    static AlertView *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)presentAlertWithTitle:(NSString*)title
                     message:(NSString*)message
         andButtonsWithTitle:(NSArray*)buttonTitles
                onController:(UIViewController*)controller
               dismissedWith:(AlertCompletionBlock)completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        //NSLog(@"AlertView ERROR ==> Invalid button title!");
        return;
    }
    
    self.completionBlock = completionBlock;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        
        //display UIAlertView
        
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        alertView.tag = 888;
        for (NSInteger index = 0; index < buttonTitles.count; index++)
            [alertView addButtonWithTitle:[buttonTitles objectAtIndex:index]];
        
        [alertView show];
    }
    else {
        //display UIAlertController
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        for (NSInteger index = 0; index < buttonTitles.count; index++) {
            
            UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                //  AlertActionBLock
                self.completionBlock(index, action.title);
                
            }];
            [alertController addAction:buttonAction];
        }
        [alertController.view setTintColor:[UIColor colorWithRed:251.0/255.0f green:53.0/255.0f blue:166.0/255.0 alpha:1]];
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark * * * * UIAlertViewDelegate Method * * * *
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    self.completionBlock(buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
}

-(void)displayInformativeAlertwithTitle:(NSString *)title andMessage:(NSString*)message onController:(UIViewController*)controller {
    
    [self presentAlertWithTitle:title message:message andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle) { }];
}

+ (void)actionSheet:(NSString*)title
            message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles
      dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock {
    
    id buttonTitle = [buttonTitles firstObject];
    if (!buttonTitle || ![buttonTitle isKindOfClass:[NSString class]]) {
        //NSLog(@"ERROR ==> Invalid button title!");
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Other buttons
    
    for (NSInteger index = 0; index < buttonTitles.count; index++) {
        
        UIAlertAction * buttonAction = [UIAlertAction actionWithTitle:[buttonTitles objectAtIndex:index] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //  AlertActionBLock
            
            if (completionBlock) {
                completionBlock(index, action.title);
            }
        }];
        //alertController.view.tintColor = [UIColor blackColor];
        [alertController addAction:buttonAction];
    }
    
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0];
    }
    
    // Cancel Button
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)  style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        if (completionBlock) {
            completionBlock(buttonTitles.count, @"Cancel");
        }
        
        [rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }]];
   // [alertController.view setTintColor: [UIColor colorWithRed:251.0/255.0f green:53.0/255.0f blue:166.0/255.0 alpha:1]]; //RGBCOLOR(251, 53, 166, 1)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [rootViewController presentViewController:alertController animated:YES completion:nil];
    });
}
@end
