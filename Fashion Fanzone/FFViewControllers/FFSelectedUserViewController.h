//
//  FFSelectedUserViewController.h
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 19/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectUserProtocol <NSObject>

- (void)selectedUser:(NSMutableArray *)userArray :(NSString *)permission;

@end

@interface FFSelectedUserViewController : UIViewController

@property (nonatomic,weak) id<SelectUserProtocol> delegate;

@property (nonatomic,strong) NSString *viewPermission;

@end
