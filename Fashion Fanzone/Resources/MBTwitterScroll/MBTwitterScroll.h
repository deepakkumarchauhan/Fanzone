//
//  MBTwitterScroll.h
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"



typedef enum : NSUInteger {
    MBTable,
    MBScroll,
} MBType;


@protocol MBTwitterScrollDelegate <NSObject>
-(void)recievedMBTwitterScrollEvent;

@optional
-(void)recievedMBTwitterScrollButtonClicked;
@end


@interface MBTwitterScroll : UIView <UIScrollViewDelegate, MBTwitterScrollDelegate >


- (MBTwitterScroll *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle;
- (MBTwitterScroll *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height;
-(void)updateHeaderImage:(UIImage*)newImage;
- (MBTwitterScroll *)initTableViewWithBackgound:(UIImage*)backgroundImage andDataModal:(FFProfileModal*)modal;
- (void) animationForScroll:(CGFloat) offset;



@property (strong, nonatomic) UIImageView *avatarImage;
@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIButton *headerButton;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) BOOL headerHidden;


@property (nonatomic, assign)  NSInteger  selectedIndex;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong)  NSTimer  *timer;

@property (nonatomic, strong) NSMutableArray *blurImages;
@property (nonatomic,strong) id<MBTwitterScrollDelegate>delegate;


@end
