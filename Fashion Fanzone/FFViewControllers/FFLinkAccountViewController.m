//
//  FFLinkAccountViewController.m
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFLinkAccountViewController.h"

@interface FFLinkAccountViewController ()

@end

@implementation FFLinkAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UIButton Action Method
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
