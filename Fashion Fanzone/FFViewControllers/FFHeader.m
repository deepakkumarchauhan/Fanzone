//
//  FFHeader.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 31/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFHeader.h"
#import "FFFanzoneModelInfo.h"

@implementation FFHeader

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   
    self = [[[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil] objectAtIndex:0];
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 4.0f;
    self.noOfFollowers.font = AppFont(14);
    self.noOfStylePoints.font = AppFont(14);
    self.noOfConnections.font = AppFont(14);
    self.totalNoOfTags.font = AppFont(14);
   
    [self initialMethod];
    
    return self;
}

-(void)initialMethod {
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.detailArray.count;

    self.imageArray = [NSMutableArray array];
    
   // for (int index = 0; index < self.detailArray.count; index++) {
        
     //   FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:index];
        
     //   if (tempPostModel.userPostArray.count) {
     //
    //        FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];
   //         [self.imageArray addObject:tempPostImageModel.publishImage];
   //     }

  //  }
    
    
    if (self.detailArray.count) {
        
        FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.pageControl.currentPage];
        FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];
        
        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage]];

        // Add Swipe Gesture to image
        [self.bannerImageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImage:)];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        // Adding the swipe gesture on image view
        [self.bannerImageView addGestureRecognizer:swipeLeft];
        [self.bannerImageView addGestureRecognizer:swipeRight];
        [self.bannerImageView addGestureRecognizer:gesture];

        [self startTimer];
    }else{
        [self.bannerImageView setImage:[UIImage imageNamed:@"Banner"]];
    }
    
    
    self.headerBorderView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.headerBorderView.layer.borderWidth = 1.0;
    
    [self.bannerImageView setIsAccessibilityElement:NO];
    

   }


#pragma mark - Timer Method
-(void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(swipeTutorialScreenAutomatically) userInfo:nil repeats:YES];
}

-(void)swipeTutorialScreenAutomatically {
    if (!self.bannerImageView.isAccessibilityElement) {
        [self leftMove_faster:NO];
    }else {
        [self rightMove_faster:NO];
    }
}


#pragma mark - Swipe Method
-(void)rightMove_faster:(BOOL)fast {
    if (self.selectedIndex-1 < 0 ) {
        return;
    }else{
        //self.rigthBackBtn.hidden=NO;
        CATransition *animation = [CATransition animation];
        [animation setDuration:(fast)?0.3:0.7];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.bannerImageView.layer addAnimation:animation forKey:@"SwitchToView1"];
        
       // [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:self.pageControl.currentPage]]];
        
        
        FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.pageControl.currentPage];
        FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];
        
        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];
       self.selectedIndex -= 1;
        self.pageControl.currentPage = self.selectedIndex;

        if (self.selectedIndex==0) {
            //  self.leftBackBtn.hidden=YES;
            
        }
    }
    if (self.selectedIndex == 0) {
        [self.bannerImageView setIsAccessibilityElement:NO];
    }
    
    
    FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.selectedIndex];
    FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];

    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];


//    [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.selectedIndex]]];
}

-(void)leftMove_faster:(BOOL)fast{
    if (self.selectedIndex+1 < [self.detailArray count]) {
        if (self.selectedIndex==0) {
            //  self.leftBackBtn.hidden=YES;
        }
        //self.leftBackBtn.hidden=NO;
        CATransition *animation = [CATransition animation];
        [animation setDuration:(fast)?0.3:0.7];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.bannerImageView.layer addAnimation:animation forKey:@"SwitchToView1"];
//        [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.pageControl.currentPage]]];
        

        FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.pageControl.currentPage];
        FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];

        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];

        
        self.selectedIndex += 1;
        self.pageControl.currentPage = self.selectedIndex;
        
        if (self.selectedIndex==3) {
            //self.rigthBackBtn.hidden=YES;
        }
    }
    else{
        // self.rigthBackBtn.hidden=YES;
        return;
    }
    if (self.selectedIndex == 2) {
        [self.bannerImageView setIsAccessibilityElement:YES];
    }
    
    FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.selectedIndex];
    FFFanzoneModelInfo *tempPostImageModel = [tempPostModel.userPostArray firstObject];
    

    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:tempPostImageModel.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];


 //   [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.selectedIndex]]];
}

#pragma mark - Selector Method
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            [self leftMove_faster:YES];
        }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:{
            [self rightMove_faster:YES];
        }
            break;
        default:
            break;
    }
}


- (void)tapOnImage:(UITapGestureRecognizer*)gesture {
    
    self.timer = nil;
    [self.timer invalidate];
    NSLog(@"%ld",(long)self.pageControl.currentPage);
    if (self.detailArray.count) {
        FFFanzoneModelInfo *tempPostModel = [self.detailArray objectAtIndex:self.pageControl.currentPage];
       [self.delegate getFashionFlowImageTap:tempPostModel];
    }
 }


@end
