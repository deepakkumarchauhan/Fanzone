//
//  FFCreateFlowModel.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 4/6/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFCreateFlowModel : NSObject

@property (assign, nonatomic) BOOL isManageFlowSelected;
@property (assign, nonatomic) BOOL isCanPostSelected;
@property (assign, nonatomic) BOOL isWhoCanViewSelected;
@property (assign, nonatomic) BOOL isViewSelectedUser;
@property (assign, nonatomic) BOOL isPostSelectedUser;
@property (strong, nonatomic) NSString *flowNameString;
@property (strong, nonatomic) NSMutableArray *arrayFlowSharedWith;
@property (strong, nonatomic) NSString *strManageFlowSelectedText;

@property (strong, nonatomic) NSString *viewByString;
@property (strong, nonatomic) NSString *flowSharedWithString;
@property (strong, nonatomic) NSString *strFlowName;

@end
