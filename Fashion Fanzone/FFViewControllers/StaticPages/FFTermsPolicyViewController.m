//
//  FFTermsPolicyViewController.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFTermsPolicyViewController.h"
#import "Macro.h"

@interface FFTermsPolicyViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFTermsPolicyViewController


#pragma mark - UIView Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}


#pragma mark - Custom Method
- (void)initialSetup {
    
    self.titleLabel.text = self.titleText;
    [self makeWebApiCallToGetStaticContent];


}


#pragma mark - UIButton Action
- (IBAction)backButtobAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UIWebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoader];
    
}


#pragma mark - Helper Method

- (void)makeWebApiCallToGetStaticContent {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiStaticContent forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    
    if ([self.titleText isEqualToString:@"FASHION FANZONE INFORMATION"])
        [dictRequest setValue:@"4538" forKey:KStaticID];
    else if ([self.titleText isEqualToString:@"TERMS AND CONDITIONS"])
        [dictRequest setValue:@"4540" forKey:KStaticID];
    else
        [dictRequest setValue:@"4539" forKey:KStaticID];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                NSDictionary *dict = [response objectForKeyNotNull:@"StaticContent" expectedObj:[NSDictionary dictionary]];
                NSString *staticData = [dict objectForKeyNotNull:@"content" expectedObj:@""];
                
                 [self.webView loadHTMLString:staticData baseURL:nil];
                
            }else{
                [self hideLoader];
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [self hideLoader];
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
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
