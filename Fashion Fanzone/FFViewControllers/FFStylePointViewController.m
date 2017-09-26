//
//  FFStylePointViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 01/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFStylePointViewController.h"

@interface FFStylePointViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
{
    UIButton * button;
    UIButton * settings;
    UIView * customView;
    UIImageView * headerImage;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;


@end

@implementation FFStylePointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self manageTextColourForBtnAtIndex:0];
    [self initiatePageController];
}
-(void)manageNavigationBar
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"backBlack"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(2, 5, 60, 30)];
    [self.navigationController.navigationBar addSubview:button];
    
    settings = [UIButton buttonWithType:UIButtonTypeCustom];
    [settings setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [settings setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
    [settings setFrame:CGRectMake(MainScreenWidth-35, 5 , 30, 30)];
    [self.navigationController.navigationBar addSubview:settings];
    
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 6, MainScreenWidth-160, 25)];
    headerImage.image = [UIImage imageNamed:@"style"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, MainScreenWidth, 2)];
    customView.backgroundColor =[UIColor colorWithRed:177.0/255.0f green:230.0/255.0f blue:246.0/255.0f alpha:1];
    [self.navigationController.navigationBar addSubview:customView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [self manageNavigationBar];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [button removeFromSuperview];
    [customView removeFromSuperview];
    [headerImage removeFromSuperview];
    [settings removeFromSuperview];
    self.navigationController.navigationBarHidden = YES;
}
-(void)manageTextColourForBtnAtIndex:(NSInteger)index
{
    [self.recentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.connectionsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.followersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    switch (index) {
        case 0:[self.recentBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];   break;
        case 1:[self.connectionsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];   break;
        case 2:[self.followersBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];   break;
            
        default:
            break;
    }
    
}
#pragma mark-
#pragma mark- IBAction Methods-----

#pragma mark-
#pragma mark Manage PageController- *************


-(void)initiatePageController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    
    
    FFStylelistViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    
    [[self.pageViewController view] setFrame:CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-40)];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
}

#pragma mark-
#pragma mark Pagecontroller delegate methods-



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFStylelistViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFStylelistViewController *)viewController index];
    
    index++;
    if (index > 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}





- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger pageIndex = ((FFStylelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    NSLog(@"==== %lu", (unsigned long)pageIndex);
    [self manageTextColourForBtnAtIndex:pageIndex];
}


- (FFStylelistViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    FFStylelistViewController *childViewController = (FFStylelistViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFStylelistViewController"];
    childViewController.index = index;
    childViewController.concernUser_id = self.concernUser_id;
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)changePage:(UIPageViewControllerNavigationDirection)direction toIndex:(NSInteger)toIndex{
    NSUInteger pageIndex = ((FFStylelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    
    if (direction == UIPageViewControllerNavigationDirectionForward) {
        pageIndex++;
        if (pageIndex>2) {
            return;
        }
    }
    else {
        if (pageIndex==0) {
            return;
        }
        pageIndex--;
        
    }
    
    FFStylelistViewController *viewController = [self viewControllerAtIndex:toIndex];
    
    if (viewController == nil) {
        return;
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:direction
                                   animated:YES
                                 completion:nil];
}




-(void)callBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)settings
{
    UIViewController * controler = [self.storyboard instantiateViewControllerWithIdentifier:@"FFSettingsViewController"];
    [self.navigationController pushViewController:controler animated:YES];
}

-(IBAction)recentBtnClick:(id)sender
{
    [self changePage:UIPageViewControllerNavigationDirectionReverse toIndex:0];
    [self manageTextColourForBtnAtIndex:0];
}
-(IBAction)connectionsBtnClick:(id)sender
{
    NSUInteger pageIndex = ((FFStylelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    if (pageIndex==0) {
        [self changePage:UIPageViewControllerNavigationDirectionForward toIndex:1];
    }
    if (pageIndex==2) {
        [self changePage:UIPageViewControllerNavigationDirectionReverse toIndex:1];
    }
    [self manageTextColourForBtnAtIndex:1];
}
-(IBAction)followingBtnClick:(id)sender
{
    [self changePage:UIPageViewControllerNavigationDirectionForward toIndex:2];
    [self manageTextColourForBtnAtIndex:2];
}

@end
