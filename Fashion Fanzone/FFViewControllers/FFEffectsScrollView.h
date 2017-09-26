//
//  FFEffectsScrollView.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 16/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"


@protocol EfectsScrollprotocol <NSObject>

-(void)imageEffectsIndexGet:(NSInteger)index;

@end

@interface FFEffectsScrollView : UIScrollView
@property (nonatomic , weak) id<EfectsScrollprotocol>delegateMethods;
@property (nonatomic , strong) NSArray * optionArray;
@end
