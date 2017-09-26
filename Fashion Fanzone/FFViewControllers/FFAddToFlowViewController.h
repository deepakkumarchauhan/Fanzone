//
//  FFAddToFlowViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 18/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@interface FFAddToFlowViewController : UIViewController

@property (nonatomic, strong) FFPostModal * modalPost;
@property (nonatomic, assign) BOOL isFromCameraClick;
@property (nonatomic, assign)BOOL  isFromTextEditor;
@property (nonatomic, strong)NSMutableDictionary * textDitorDict;
@end
