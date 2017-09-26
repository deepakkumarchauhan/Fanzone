//
//  FFDirectMessageViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFDirectMessageViewController.h"

@interface FFDirectMessageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource , UIAlertViewDelegate>
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation FFDirectMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiatePageController];
    
    NSString * text = @"ONGOING";
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];//@{  : color
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    self.onGoingLabel.attributedText = mat;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--- InitiatePageController----


-(void)initiatePageController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    FFMessagelistViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [[self.pageViewController view] setFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-115)];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
}

#pragma mark-
#pragma mark Pagecontroller delegate methods-



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFMessagelistViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFMessagelistViewController *)viewController index];
    
    index++;
    if (index > 1) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}



- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
     NSUInteger pageIndex = ((FFMessagelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    if (pageIndex==0) {
        [self makeRequestSelected];
        
    }
    if (pageIndex==1) {
       [self makeOnGoinSelected];
    }
}




- (FFMessagelistViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    FFMessagelistViewController *childViewController = (FFMessagelistViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFMessagelistViewController"];
    childViewController.index = index;
    return childViewController;
    
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)changePage:(UIPageViewControllerNavigationDirection)direction {
    NSUInteger pageIndex = ((FFMessagelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
        if (pageIndex>1) {
            return;
        }
    }
    else {
        if (pageIndex==0) {
            return;
        }
        pageIndex--;
    }
    
    FFMessagelistViewController *viewController = [self viewControllerAtIndex:pageIndex];
    
    if (viewController == nil) {
        return;
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}
#pragma mark-
#pragma mark //****** IBaction methods --------


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)indexBtnClicked:(id)sender
{
    
}
-(IBAction)ongoingBtnClicked:(id)sender
{
    [self makeOnGoinSelected];
    [self changePage:UIPageViewControllerNavigationDirectionReverse];
    
}
-(IBAction)requestBtnClicked:(id)sender
{
    [self makeRequestSelected];
    [self changePage:UIPageViewControllerNavigationDirectionForward];
}

-(void)makeOnGoinSelected
{
    NSString * text = @"ONGOING";
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    self.onGoingLabel.attributedText = mat ;
    
    text = @"REQUESTS";
    mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    self.requestLabel.attributedText = mat;
}

-(void)makeRequestSelected
{
    NSString * text = @"REQUESTS";
    NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, mat.length)];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    self.requestLabel.attributedText = mat;
    
    text = @"ONGOING";
    mat = [[NSMutableAttributedString alloc] initWithString:text];
    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, mat.length)];
    self.onGoingLabel.attributedText = mat ;
}
-(IBAction)newMessageButtonClicked:(id)sender
{
    FFPostModal * modal = [[FFPostModal alloc] init];
    FFDirectMessageContactList * list = (FFDirectMessageContactList*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFDirectMessageContactList"];
    list.modalPost = modal;
    [self.navigationController pushViewController:list animated:YES];
    
    
    
    

}


@end
