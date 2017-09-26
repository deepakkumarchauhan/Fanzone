//
//  FFTextEditiorViewController.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 4/3/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "ZSSRichTextEditor.h"
#import <Social/Social.h>
#import "Macro.h"
@interface FFTextEditiorViewController : ZSSRichTextEditor
@property (nonatomic, assign) BOOL isMessaging;
@property (nonatomic, strong) FFPostModal * modalPost;
@end
