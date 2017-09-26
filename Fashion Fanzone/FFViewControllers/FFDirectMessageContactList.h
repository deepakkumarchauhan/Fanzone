//
//  FFDirectMessageContactList.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 16/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@interface FFDirectMessageContactList : UIViewController
@property (nonatomic, strong) NSString * messageTitle;
@property (nonatomic, strong) FFPostModal * modalPost;
@property (nonatomic, strong) FFMessageModal * messageModal;
@property (nonatomic, assign) BOOL isForwardMessage;




@end
