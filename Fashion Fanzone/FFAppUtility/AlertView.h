//
//  AlertView.h
//  Catalog
//
//  Created by Deepak Kumar on 8/18/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^AlertCompletionBlock) (NSInteger index, NSString *buttonTitle);

@interface AlertView : NSObject

+(instancetype)sharedManager;

-(void)presentAlertWithTitle:(NSString*)title
                     message:(NSString*)message
         andButtonsWithTitle:(NSArray*)buttonTitles
                onController:(UIViewController*)controller
               dismissedWith:(AlertCompletionBlock)completionBlock;

+ (void)actionSheet:(NSString*)title
            message:(NSString*)message
andButtonsWithTitle:(NSArray*)buttonTitles
      dismissedWith:(void (^)(NSInteger index, NSString *buttonTitle))completionBlock;
-(void)displayInformativeAlertwithTitle:(NSString *)title andMessage:(NSString*)message onController:(UIViewController*)controller;

@end

