//
//  FFPostDetailViewController.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "FFFanzoneModelInfo.h"

@protocol PostDetailProtocol <NSObject>

-(void)callFanzoneApi;

@end

@interface FFPostDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView * postImageView;
@property (nonatomic, strong) FFProfileModal * profileModal;
@property (nonatomic, strong)  UIButton * exitBtn;
@property (nonatomic, strong)  UIImageView * headerImage;
@property (nonatomic, strong)  UIView * hederViewBlack;

@property (nonatomic, strong) FFFanzoneModelInfo * fanzoneModal;

@property (nonatomic, strong)  NSString * postId;

@property (nonatomic, weak) id <PostDetailProtocol> delegate;


@end
