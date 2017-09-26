//
//  FFInviteFriendsViewController.m
//  Fashion Fanzone
//
//  Created by Shridhar Agarwal on 22/05/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFInviteFriendsViewController.h"
#import "FFImportContactViewController.h"
#import "Macro.h"

@interface FFInviteFriendsViewController ()<FFContactDelegate>
@property (weak, nonatomic) IBOutlet FFTextField *emailTextFeild;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.emailTextFeild setPlaceholder:@"Enter email id."];
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

- (IBAction)addButtonAction:(id)sender {
    if ([TRIM_SPACE(self.emailTextFeild.text) length]) {
        [self makeWebApiCallInviteFriend];
    }
    else{
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter email id." onController:self];
    }
}

- (IBAction)importContactAction:(id)sender {
   
    FFImportContactViewController *objVc = (FFImportContactViewController *)[[FFImportContactViewController alloc]initWithNibName:@"FFImportContactViewController" bundle:nil];
    objVc.delegate = self;
    [self.navigationController pushViewController:objVc animated:YES];
}
- (void)selectionButtonClicked:(NSString *)emailAddress{

    self.emailTextFeild.text = emailAddress;

}



#pragma mark - Helper Method

- (void)makeWebApiCallInviteFriend {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiSendInvitation forKey:KAction];
    [dictRequest setValue:self.emailTextFeild.text forKey:KEmail];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                self.emailTextFeild.text = @"";
                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Success!" andMessage:strResponseMessage onController:self];
                
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
