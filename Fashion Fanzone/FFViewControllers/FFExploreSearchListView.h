//
//  FFExploreSearchListView.h
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 09/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFExploreSearchListView : UIView

@property (nonatomic,strong)NSString *searchtext;
@property (nonatomic,strong)UIViewController  * controller;
-(void)callSearchApi:(NSString *)searchText withViewController:(UIViewController*)controller;
@end
