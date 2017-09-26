//
//  FFPostModal.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FFPostModal : NSObject

@property (nonatomic, strong) NSString * postTitle;
@property (nonatomic, strong) NSString * postCatptions;
@property (nonatomic, strong) UIImage * postImage;
@property (nonatomic, strong) NSData * gifImageData;
@property (nonatomic, strong) NSArray * postImageArray;
@property (nonatomic, strong) NSString * postFlow;
@property (nonatomic, strong) NSArray * messageReceipent;
@property (nonatomic, assign) BOOL  isJIF;

@end
