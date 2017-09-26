//
//  FFMessageDecriptionViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMessageDecriptionViewController.h"

@interface FFMessageDecriptionViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView * webView;
@property (nonatomic, weak) IBOutlet UIWebView * webView_text;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFMessageDecriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    FFMessageModal * modal = nil;
    if (self.index<self.messageArray.count) {
        modal = self.messageArray[self.index];
    }
    if (modal.message.length) {
       self.webView_text.hidden = NO;
        [self.webView_text loadHTMLString:modal.message baseURL:nil];
    }
    else
    {
        
        CGRect frame = self.webView.frame;
        frame.origin.y  = 0;
         self.webView_text.hidden = YES;
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        self.webView.frame = frame;
        NSURL *url = [NSURL URLWithString:modal.imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
       [self.webView loadRequest:request];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark //********* WEbView Delegate Method-


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoader];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideLoader];
 
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


@end
