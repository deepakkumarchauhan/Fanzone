//
//  FFFiltersViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 12/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFFiltersViewController.h"
#import "FFVerticalSlider.h"

@interface FFFiltersViewController ()<FFVerticalSliderDelegate>
{
    FFVerticalSlider * verticalFilterSlider;
    NSArray * filterArray;
    BOOL isfilterHidden;
}

@property (nonatomic, weak) IBOutlet UIImageView * objectImageView;
@property (nonatomic, weak) IBOutlet UIButton * backButton;
@property (nonatomic, weak) IBOutlet UIImageView * headerImage;
@property (nonatomic, weak) IBOutlet UILabel * filterLabel;
@property (nonatomic, weak) IBOutlet UIButton * publish;
@property (nonatomic, strong) UIScrollView *  filterScrollView;
@end

@implementation FFFiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _objectImageView.image = _imageObject;
    [[FFFilerModals sharedInstance] initializeObjects];
    [self manageFilterChooseView];
    [self manageVerticalSlider];
    verticalFilterSlider.frame = CGRectMake(-100, 100, 22, MainScreenHeight * 0.6);
    [self showFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-
#pragma mark Manage Vertical Slider View
-(void)manageVerticalSlider
{
    verticalFilterSlider = [[FFVerticalSlider alloc] initWithFrame:CGRectMake(20, 100, 22, MainScreenHeight * 0.55)];
    verticalFilterSlider.sliderDelegate = self;
    [self.view addSubview:verticalFilterSlider];
}
-(void)getSliderValueWith:(float)sliderValue// get filter value
{
    
}

#pragma mark-
#pragma mark Manage filter choose view-

-(void)hideFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterScrollView.frame = CGRectMake(0, MainScreenHeight, [UIScreen mainScreen].bounds.size.width, 100);
        verticalFilterSlider.frame = CGRectMake(-100, 100, 22, MainScreenHeight * 0.55);
    }];
}
-(void)showFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterScrollView.frame = CGRectMake(0, MainScreenHeight-140, [UIScreen mainScreen].bounds.size.width, 100);
        verticalFilterSlider.frame = CGRectMake(20, 100, 22, MainScreenHeight * 0.55);
    }];
}
#pragma mark-
#pragma mark ManageFiletrs View



-(void)manageFilterChooseView
{
    self.filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-140, [UIScreen mainScreen].bounds.size.width, 100)];
    self.filterScrollView.showsHorizontalScrollIndicator = NO;
    int xVal = 10;
    int width = 90;
    int height = 60;
    filterArray = [NSArray arrayWithObjects:@"New York",@"London",@"Paris",@"Tokyo",@"Miami",@"Milano",@"Los Angeles",@"Beijing",@"New Delhi",@"Berlin", @"Rio",@"Moscow",@"Stockholm",@"Mexico City",nil];
    for (int i=0; i<filterArray.count; i++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xVal, 5, width, height)];
        label.tag = i;
        label.backgroundColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0f blue:255.0/255.0f alpha:1] colorWithAlphaComponent:1.0];
       NSString * stringText = [filterArray[i] uppercaseString];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, stringText.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        label.attributedText = mat ;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.opacity = 0.5f;
        label.font = AppFontBOLD(16);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClicked:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        
        [self.filterScrollView addSubview:label];
        xVal = xVal+width+10;
        
    }
    self.filterScrollView.contentSize = CGSizeMake(xVal, 100);
    [self.view addSubview:self.filterScrollView];
}
-(void)filterClicked:(UITapGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)gesture.view;
    
    for (UIView *view in self.filterScrollView.subviews) {
        
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel*)view;
            lbl.textColor = [UIColor blackColor];
        }
        
    }
    
    label.textColor = [[UIColor colorWithRed:0.0/255.0 green:255.0/255.0f blue:255.0/255.0f alpha:1] colorWithAlphaComponent:1];
    label.font = AppFontBOLD(16);
    
}

#pragma mark-
#pragma mark IBAction Methods-


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)hideShowButtonClicked:(id)sender
{
    if (isfilterHidden) {
        isfilterHidden = NO;
        [self showFilters];
        
        CGRect frame = _headerImage.frame;
        frame.origin.y = 0;
        _headerImage.frame = frame;
        
        frame = _backButton.frame;
        frame.origin.y = 7;
        _backButton.frame = frame;
        
        frame = _publish.frame;
        frame.origin.y = MainScreenHeight-50;
        _publish.frame = frame;
        
        frame = _filterLabel.frame;
        frame.origin.y = MainScreenHeight-50;
        _filterLabel.frame = frame;
        
    }
    else
    {
        isfilterHidden = YES;
        [self hideFilters];
        
        CGRect frame = _headerImage.frame;
        frame.origin.y = -100;
        _headerImage.frame = frame;
        
        frame = _backButton.frame;
        frame.origin.y = -150;
        _backButton.frame = frame;
        
        frame = _publish.frame;
        frame.origin.y = MainScreenHeight;
        _publish.frame = frame;
        
        frame = _filterLabel.frame;
        frame.origin.y = MainScreenHeight;
        _filterLabel.frame = frame;

    }
}
-(IBAction)bublishButtonClicked:(id)sender
{
    
    FFImageViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFImageViewController"];
    controller.image = _objectImageView.image;
    controller.isFromCameraClick = self.isFromCameraClick;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
