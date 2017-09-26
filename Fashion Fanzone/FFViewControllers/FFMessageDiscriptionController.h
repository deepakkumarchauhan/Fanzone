//
//  FFMessageDiscriptionController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@class FFMessageModal;


@interface FFMessageDiscriptionController : UIViewController


@property (nonatomic,strong) FFMessageModal *modelInfo;

@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) BOOL isFromThread;
@property (nonatomic,strong) NSMutableArray *threadArray;



-(IBAction)callBack:(id)sender;


@end
