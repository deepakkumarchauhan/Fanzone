//
//  FFEditorialDetailViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 19/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFEditorialDetailViewController.h"

@interface FFEditorialDetailViewController ()<UIWebViewDelegate>
{
    UILabel * lbl;
    UIView * headerview;
    UIImageView * headerImage;
    UIButton * btn;
    UIButton * profileBtn;
}

@property (nonatomic, weak) IBOutlet UIImageView* profileImagView;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* numberofLikes;
@property (nonatomic, weak) IBOutlet UILabel* numberOfComments;
@property (nonatomic, weak) IBOutlet UIWebView* descriptionWebView;




@end

@implementation FFEditorialDetailViewController

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoader];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoader];
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:self.activityIndicatorView];
    self.descriptionWebView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- LayoutNavigation Controller---


-(void)layoutNavigationBar
{
    headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 17, [UIScreen mainScreen].bounds.size.width, 31)];
    lbl.text = @"EDITORIAL";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font =  AppFont(23) ;   ///[UIFont systemFontOfSize:25];
    [self.navigationController.navigationBar addSubview:lbl];
    
    btn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake(4, 0, 35, 35) andBackImage:[UIImage imageNamed:@"chat"]];
    [btn addTarget:self action:@selector(chatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
    
    profileBtn = [[FFUtility sharedInstance] getButtonWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, 1, 40, 40) andBackImage:[UIImage imageNamed:@"img9"]];
    [profileBtn addTarget:self action:@selector(profileBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [profileBtn sd_setImageWithURL:[NSURL URLWithString:[NSUSERDEFAULT valueForKey:KUserImage]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.navigationController.navigationBar addSubview:profileBtn];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self layoutNavigationBar];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    [self.profileImagView sd_setImageWithURL:[NSURL URLWithString:self.obj_detail.profileImage] placeholderImage:[UIImage imageNamed:@""]];
    [self.nameLabel setText:self.obj_detail.fanzoneTitle];
    [self.numberofLikes setText:[self.obj_detail.likeCount isEqualToString:@""]?@"0":self.obj_detail.likeCount];
    [self.numberOfComments setText:[self.obj_detail.commentCount isEqualToString:@""]?@"0":self.obj_detail.commentCount];
    [self.descriptionWebView loadHTMLString:self.obj_detail.fanzoneDescription baseURL:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
    [lbl removeFromSuperview];
    [headerImage removeFromSuperview];
    [btn removeFromSuperview];
    [profileBtn removeFromSuperview];
    [headerview removeFromSuperview];
}

#pragma mark-
#pragma mark IBaction methods--

-(IBAction)chatBtnClicked:(id)sender//
{
    [self performSegueWithIdentifier:@"messagechat" sender:self];
    
}
-(IBAction)profileBtnClicked:(id)sender//profileBtnClicked
{
    FFProfileViewController * profile = (FFProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFProfileViewController"];
    profile.isUserSelfProfile = YES;
    [self.navigationController pushViewController:profile animated:NO];
}
-(IBAction)fanzoneBtnClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFMainViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFMainViewController"];
    [self.navigationController pushViewController: myController animated:NO];
    
    
}
- (IBAction)editorButtonAction:(id)sender {
    
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFTextEditiorViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFTextEditiorViewController"];
    [self.navigationController pushViewController: myController animated:NO];

}

-(IBAction)caneraBtnClicked:(id)sender//
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFCameraViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCameraViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}
-(IBAction)exploreBtnClicked:(id)sender//
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFExploreViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFExploreViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}

-(IBAction)fashionButtonClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFFashionViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
    UIViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"FFExploreViewController"];
    [self.navigationController pushViewController: myController animated:NO];
}

-(IBAction)commentbuttonClicked:(id)sender
{
    
}

-(IBAction)likebuttonClicked:(id)sender
{
    [self makeWebApiCallForLikeUnlikePost];
}

-(IBAction)exportbuttonClicked:(id)sender
{

    NSString *textToShare = self.obj_detail.fanzoneDescription;
    
    NSArray *activityItems =  @[textToShare];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}


- (void)makeWebApiCallForLikeUnlikePost {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiLikeUnlikePost forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:([self.obj_detail.likeStatus isEqualToString:@"1"])?@"0":@"1" forKey:KLikeStatus];
    [dictRequest setValue:self.obj_detail.publishId forKey:KPostID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if ([[response objectForKeyNotNull:@"likeStatus" expectedObj:@""] isEqualToString:@"0"]) {
                    self.obj_detail.likeCount = [NSString stringWithFormat:@"%ld",(long)[self.obj_detail.likeCount integerValue]-1];
                    self.numberofLikes.text = self.obj_detail.likeCount;
                    self.obj_detail.likeStatus = @"0";

                }
                else {
                    self.obj_detail.likeCount = [NSString stringWithFormat:@"%ld",(long)[self.obj_detail.likeCount integerValue]+1];
                    self.numberofLikes.text = self.obj_detail.likeCount;
                    self.obj_detail.likeStatus = @"1";
                }
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
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
