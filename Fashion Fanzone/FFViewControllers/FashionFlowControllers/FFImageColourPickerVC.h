//
//  FFImageColourPickerVC.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 10/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "SYEmojiPopover.h"
#import "ZDStickerView.h"
#import "FFVerticalSlider.h"
#import "FFEffectsScrollView.h"


@interface FFImageColourPickerVC : UIViewController<SYEmojiPopoverDelegate , ZDStickerViewDelegate , FFVerticalSliderDelegate >
{
    SYEmojiPopover *_emojiPopover;
}
@property (nonatomic, strong) UIImage * imageObject;
@property (nonatomic, assign)BOOL  isFromCameraClick;
@property (nonatomic, strong) FFPostModal * modalPost;
@property (nonatomic, assign) BOOL isMessaging;

@end
