//
//  FFImageViewerViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFImageViewerViewController.h"

@interface FFImageViewerViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * imageView;
@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;


@end

@implementation FFImageViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = self.objectImage;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(IBAction)calBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
