//
//  FFCaptionViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 18/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface FFCaptionViewController : UIViewController
@property (nonatomic, strong)UIImage * imageToPublish;
@property (nonatomic, strong) NSData * gifImagedatqa;
@property (nonatomic, strong)NSArray * imageArrayToPublish;
@property (nonatomic, assign)BOOL  isFromCameraClick;
@property (nonatomic, assign)BOOL  isFromTextEditor;
@property (nonatomic, strong)NSMutableDictionary * textDitorDict;
@end
