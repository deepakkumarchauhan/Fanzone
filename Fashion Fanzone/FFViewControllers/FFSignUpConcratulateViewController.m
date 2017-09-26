//
//  FFSignUpConcratulateViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 15/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFSignUpConcratulateViewController.h"
#import "Macro.h"


@interface FFSignUpConcratulateViewController ()

@end

@implementation FFSignUpConcratulateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark IBAction Methods-


-(IBAction)exploreBtnClicked:(id)sender
{
    [self performSegueWithIdentifier:@"explore" sender:self];   // move to explaore screen
}
-(IBAction)guideMeBtnClicked:(id)sender
{
    FFGuideMeViewController *guideVc = (FFGuideMeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFGuideMeViewController"];
    [self.navigationController pushViewController:guideVc animated:YES];
}

@end
