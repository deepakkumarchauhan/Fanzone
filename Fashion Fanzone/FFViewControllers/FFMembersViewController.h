//
//  FFMembersViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@protocol MemberProtocol <NSObject>

- (void)callExploreSearchApi;

@end

@interface FFMembersViewController : UIViewController
@property (nonatomic , strong) NSArray * dataSourceArray;
@property (nonatomic , weak) id <MemberProtocol> delegate;


@end
