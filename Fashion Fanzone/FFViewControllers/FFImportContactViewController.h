//
//  FFImportContactViewController.h
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 23/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFContactDelegate;
@protocol FFContactDelegate <NSObject>

@optional
- (void)selectionButtonClicked:(NSString *)emailAddress;

@end

@interface FFImportContactViewController : UIViewController
@property (assign, nonatomic) id <FFContactDelegate>delegate;
@end
