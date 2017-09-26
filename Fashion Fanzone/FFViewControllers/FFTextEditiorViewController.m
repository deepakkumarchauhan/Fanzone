//
//  FFTextEditiorViewController.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 4/3/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFTextEditiorViewController.h"
#import "AlertView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>


@interface FFTextEditiorViewController ()<MFMailComposeViewControllerDelegate , GPPSignInDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) IBOutlet UIButton *publishButton;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *gPlusButton;
@property (strong, nonatomic) IBOutlet UIButton *smsButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIImageView  * nextImage;

@end

@implementation FFTextEditiorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_isMessaging) {
        _fbButton.hidden = YES;
        _twitterButton.hidden = YES;
        _gPlusButton.hidden = YES;
        _smsButton.hidden = YES;
        _publishButton.hidden = YES;
        _sendButton.hidden = NO;
        _nextImage.hidden = NO;
    }
    else
    {
        _sendButton.hidden = YES;
        _nextImage.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Handle Google+ login-


-(void)googlePlusSignIn
{
    
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = KGooglePlusClientID;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
              // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    [signIn authenticate];
}



// google+ login delegate method-

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@", error, auth);
    if (error) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Google plus login error" message:error.description andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             
         }];
    } else {
        NSString *serverCode = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
        NSLog(@"server code = %@", serverCode);
        
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        
        NSString * html =  [self getHTML];
        NSRange range = [html rangeOfString:@"<img src="];//alt="">
        NSRange end = [html rangeOfString:@">"];
        if (range.location != NSNotFound && end.location != NSNotFound && end.location > range.location) {
            NSString *betweenBraces = [html substringWithRange:NSMakeRange(range.location, end.location-(range.location))];//-(range.location+1)
            
            html = [self removeQuotesFromHTML:html :betweenBraces];
            NSLog(@"%@", html);
        }
        
        [shareBuilder setPrefillText:html];
        [shareBuilder attachImage:[[FFUtility sharedInstance] sharedImageForTextEditor]];
        [shareBuilder open];
        
    }
}


- (NSString *)removeQuotesFromHTML:(NSString *)html :(NSString *)betweenBraces {
    
    html = [html  stringByReplacingOccurrencesOfString:betweenBraces withString:@" "];
    html = [html  stringByReplacingOccurrencesOfString:@" >" withString:@""];
    html = [html  stringByReplacingOccurrencesOfString:@"\n >" withString:@"\n"];
    html = [html  stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    html = [html  stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;"  withString:@" "];
    
    return html;
}



#pragma mark -******************* Button Action & Selector Methods ****************-
- (IBAction)backButtonAction :(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString *) stringByStrippingHTML:(NSString*)html {
    NSRange r;
   
    while ((r = [html rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        html = [html stringByReplacingCharactersInRange:r withString:@""];
    return html;
}


-(IBAction)sendButtonClicked:(id)sender
{
    NSString * htmlString =  [self getHTML];
    if (htmlString.length) {
        [self callApiForMessaging:htmlString];
    }else {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter some text." onController:self];
    }
}

- (IBAction)commonButtonAction :(UIButton *)sender {
    
    if (_isMessaging)
    {
        NSString * htmlString =  [self getHTML];
        if (htmlString.length) {
            [self callApiForMessaging:htmlString];
        }else {
            [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter some text." onController:self];
        }
        return; 
    }
        
    
    switch (sender.tag) {
            //Publish Button Action
        case 90: {
            
            NSString * htmlString =  [self getHTML];
            htmlString = [self stringByStrippingHTML:htmlString];
            htmlString = [self removeQuotesFromHTML:htmlString:@""];
            
            if (htmlString.length) {
                [self makeWebApiCallForPublishPost:htmlString];
            }else {
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter some text." onController:self];
            }
        }
            break;
            //Facebook
        case 95: {

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
               
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    
                    NSString * htmlString =  [self getHTML];
                    NSRange range = [htmlString rangeOfString:@"<img src="];//alt="">
                    NSRange end = [htmlString rangeOfString:@">"];
                    if (range.location != NSNotFound && end.location != NSNotFound && end.location > range.location) {
                        NSString *betweenBraces = [htmlString substringWithRange:NSMakeRange(range.location, end.location-(range.location))];//-(range.location+1)
                        
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:betweenBraces withString:@" "];
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:@"\n >" withString:@" "];
                        NSLog(@"%@", htmlString);
                    }
                    htmlString = [self stringByStrippingHTML:htmlString];
                    htmlString = [self removeQuotesFromHTML:htmlString:@""];
                    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                    [controllerSLC setInitialText:htmlString];
                    [controllerSLC addImage:[[FFUtility sharedInstance] sharedImageForTextEditor]];
                    [self presentViewController:controllerSLC animated:YES completion:Nil];
                });
            });
            
        }
            break;
            //Twitter
        case 96: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    NSString * htmlString =  [self getHTML];
                    NSRange range = [htmlString rangeOfString:@"<img src="];//alt="">
                    NSRange end = [htmlString rangeOfString:@">"];
                    if (range.location != NSNotFound && end.location != NSNotFound && end.location > range.location) {
                        NSString *betweenBraces = [htmlString substringWithRange:NSMakeRange(range.location, end.location-(range.location))];//-(range.location+1)
                        
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:betweenBraces withString:@" "];
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:@"\n >" withString:@" "];
                        NSLog(@"%@", htmlString);
                    }
                    htmlString = [self stringByStrippingHTML:htmlString];
                    htmlString = [self removeQuotesFromHTML:htmlString:@""];
                    SLComposeViewController *controllerSLC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [controllerSLC setInitialText:htmlString];
                    [controllerSLC addImage:[[FFUtility sharedInstance] sharedImageForTextEditor]];
                    [self presentViewController:controllerSLC animated:YES completion:Nil];
                });
            });
            
            
        }
            break;
            //Google Plus
        case 97: {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    
                    NSString * htmlString =  [self getHTML];
                    NSRange range = [htmlString rangeOfString:@"<img src="];//alt="">
                    NSRange end = [htmlString rangeOfString:@">"];
                    if (range.location != NSNotFound && end.location != NSNotFound && end.location > range.location) {
                        NSString *betweenBraces = [htmlString substringWithRange:NSMakeRange(range.location, end.location-(range.location))];//-(range.location+1)
                        
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:betweenBraces withString:@" "];
                        htmlString = [htmlString  stringByReplacingOccurrencesOfString:@"\n >" withString:@" "];
                        NSLog(@"%@", htmlString);
                    }
                    htmlString = [self stringByStrippingHTML:htmlString];
                    htmlString = [self removeQuotesFromHTML:htmlString:@""];
                    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
                    // Set any prefilled text that you might want to suggest
                    [shareBuilder setPrefillText:htmlString];
                    [shareBuilder attachImage:[[FFUtility sharedInstance] sharedImageForTextEditor]];
                    BOOL canOpen = [shareBuilder open];
                    if (!canOpen) {
                        
                        
                        GPPSignIn *signIn = [GPPSignIn sharedInstance];
                        signIn.shouldFetchGooglePlusUser = YES;
                        signIn.clientID = KGooglePlusClientID;
                        signIn.scopes = @[ kGTLAuthScopePlusLogin ];
                        signIn.delegate = self;
                        [signIn authenticate];
                    }
                });
            });
            
            
            
        }
            break;
            //Message
        case 98: {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
                
                dispatch_async(dispatch_get_main_queue(), ^{ // 2
                    if ([MFMailComposeViewController canSendMail]) {
                        
                        NSString * htmlString =  [self getHTML];
                        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
                        [composeViewController setMailComposeDelegate:self];
                        [composeViewController setMessageBody:htmlString isHTML:YES];
                        [self presentViewController:composeViewController animated:YES completion:nil];
                    }
                });
            });
            
            
            
        }
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Method

- (void)makeWebApiCallForPublishPost:(NSString *)htmlContent {
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];
    [dictRequest setValue:apiPublish forKey:KAction];
    if ([[FFUtility sharedInstance] sharedImageForTextEditor] != nil) {
        NSData *dataProfileImg = UIImageJPEGRepresentation([[FFUtility sharedInstance] sharedImageForTextEditor], 0.1);
        [dictRequest setValue:[dataProfileImg base64EncodedString] forKey:KPublishImage];
    }
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:htmlContent forKey:KHtmlContent];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlatitude] forKey:KDefaultlatitude];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KDefaultlongitude] forKey:KDefaultlongitude];
    
     FFCaptionViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCaptionViewController"];
    controller.isFromTextEditor = YES;
    controller.textDitorDict = dictRequest;
    [self.navigationController pushViewController:controller animated:YES];
    
    return;
    
   /* [self showLoader];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                        [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
    
    */
    
    
}

#pragma mark - Activity Indicator Helper Method

- (void)showLoader {
    
    [self.publishButton setTitle:@"" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = NO;
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

-(void)hideLoader{
    [self.publishButton setTitle:@"PUBLISH" forState:UIControlStateNormal];
    self.view.userInteractionEnabled = YES;
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}


#pragma mark - Call Api for messaging 

-(void)callApiForMessaging:(NSString*)htmlString
{
    
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiAddChat forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];//
    [dictRequest setValue:_modalPost.messageReceipent forKey:KReceiverID]; //message
    [dictRequest setValue:htmlString forKey:KMessages];
    [dictRequest setValue:@"" forKey:KMessagesImage];
    [dictRequest setValue:_modalPost.postTitle forKey:KTitle];
    [self showLoader];
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:@[@"Ok"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
                
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
    
    
}


@end
