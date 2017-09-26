//
//  FFHeader.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 31/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFFanzoneModelInfo.h"
#import "Macro.h"

@protocol HeaderProtocolFashionFlow <NSObject>

- (void)getFashionFlowImageTap:(FFFanzoneModelInfo *)model;

@end
@interface FFHeader : UIView


@property (nonatomic, weak) IBOutlet UIImageView * bannerImageView;
@property (nonatomic, weak) IBOutlet UIImageView * profileImageView;
@property (nonatomic, weak) IBOutlet UIImageView * box1;
@property (nonatomic, weak) IBOutlet UIImageView * box2;
@property (nonatomic, weak) IBOutlet UIImageView * box3;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UITextView * descriptionView;
@property (nonatomic, weak) IBOutlet UILabel * noOfConnections;
@property (nonatomic, weak) IBOutlet UILabel * noOfFollowers;
@property (nonatomic, weak) IBOutlet UILabel * noOfStylePoints;
@property (nonatomic, weak) IBOutlet UILabel * totalNoOfTags;
@property (nonatomic, weak) IBOutlet UIButton * editButton;
@property (nonatomic, weak) IBOutlet UIButton * connectionsBtn;
@property (nonatomic, weak) IBOutlet UIButton * followingBtn;
@property (nonatomic, weak) IBOutlet UIButton * stylePointsBtn;
@property (nonatomic, assign)  NSInteger  selectedIndex;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong)  NSMutableArray  *imageArray;
@property (nonatomic, strong)  NSTimer  *timer;

@property (nonatomic, strong)  NSArray  *detailArray;
@property (strong, nonatomic) IBOutlet UIButton *locationButton;

@property (strong, nonatomic) IBOutlet UIView *showPointsView;

@property(nonatomic,weak) id<HeaderProtocolFashionFlow> delegate;

@property (strong, nonatomic) IBOutlet UIView *headerBorderView;

@property (strong, nonatomic) IBOutlet UIButton *doubleCellButton;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)initialMethod;
@end
