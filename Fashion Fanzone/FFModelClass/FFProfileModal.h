//
//  FFProfileModal.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FFProfileModal : NSObject

@property (nonatomic ,strong) NSString * user_id;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * strylePoints;
@property (nonatomic, strong) NSString * noOfLikes;
@property (nonatomic, strong) NSString * noOfComments;
@property (nonatomic, strong) UIImage  * fulImage;

@end
