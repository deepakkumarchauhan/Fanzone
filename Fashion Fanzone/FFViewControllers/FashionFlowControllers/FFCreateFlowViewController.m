//
//  FFCreateFlowViewController.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 4/6/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFCreateFlowViewController.h"
#import "FFCreateFlowModel.h"
#import "FFFlowTableCell.h"
#import "Macro.h"
#import "FFFlowTextViewTableCell.h"

static NSString *flowCellIdentifier = @"FFFlowTableCelID";
static NSString *textFieldCellIdentifier = @"FFFlowTextViewTableCellID";

@interface FFCreateFlowViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate,SelectUserProtocol> {
    NSMutableArray *arrayFlowManageOptions;
    NSMutableArray *arrayCanPostToFlowOptions;
    NSMutableArray *arrayCanViewFlowOptions;
    
    NSString *myViewPermissionString;
    NSString *myPostPermissionString;
}

@property (weak, nonatomic) IBOutlet UITableView *flowTableView;
@property (weak, nonatomic) IBOutlet UIView *createNewFlowView;
@property (weak, nonatomic) IBOutlet UIView *createNewWhiteView;
@property (weak, nonatomic) IBOutlet FFTextField *selectNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (strong, nonatomic) FFCreateFlowModel *flowModalClassObj;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFCreateFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetUpViewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self layoutNavigationBar];
    [self.navigationController setNavigationBarHidden:NO];
     self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
      self.navigationItem.hidesBackButton = YES;
    for (UIView *viewAdded in self.navigationController.navigationBar.subviews) {
        [viewAdded removeFromSuperview];
    }
}

#pragma mark -******************** Helper Methods **********************-

/**
 *Initilizes the controller's view
 */

- (void)initialSetUpViewDidLoad {
    
    self.flowModalClassObj = [[FFCreateFlowModel alloc]init];
    self.flowModalClassObj.viewByString = @"@FFanzine @SupaModels @HansRosencedal @TopFashion";
    self.flowModalClassObj.flowSharedWithString = @"@FFanzine @SupaModels @HansRosencedal @TopFashion";
    self.flowModalClassObj.arrayFlowSharedWith = [NSMutableArray array];
    self.flowTableView.rowHeight = 50;
    self.flowTableView.estimatedRowHeight = 50.0;
    self.flowTableView.rowHeight = UITableViewAutomaticDimension;
    
    arrayFlowManageOptions = [NSMutableArray array];
    arrayCanViewFlowOptions = [NSMutableArray arrayWithObjects:@"PUBLIC",@"CONNECTIONS",@"SELECTED USERS", nil];
    arrayCanPostToFlowOptions = [NSMutableArray arrayWithObjects:@"ME ONLY",@"CONNECTIONS",@"SELECTED USERS", nil];
    self.flowTableView.tableFooterView = [self tableFooterViewToAddDoneButton];
    [self.createNewFlowView setHidden:YES];
    
//    //Adding tap gesture on view to review it from superview
    UITapGestureRecognizer *tapHappen = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnView:)];
    [self.createNewFlowView addGestureRecognizer:tapHappen];
    
    myViewPermissionString = @"";
    myPostPermissionString = @"";
    
    [self makeWebApiCallForGetFlows];
    
}

/**
 *Prepares the navigation bar
 */
-(void)layoutNavigationBar {
    
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, -1, [UIScreen mainScreen].bounds.size.width-200, 25)];
    headerImage.image = [UIImage imageNamed:@"ffplane"];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationController.navigationBar addSubview:headerImage];
    
   UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"backBlack"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:91];
    [button setFrame:CGRectMake(2, 5, 60, 30)];
    [self.navigationController.navigationBar addSubview:button];
    
}

/**
 *To Add Done button at the footer of table view
 
 @return UIView Object
 */
- (UIView *)tableFooterViewToAddDoneButton {
    
    UIView *holdingView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, windowWidth, 120)];
    [holdingView setBackgroundColor:[UIColor whiteColor]];
    UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(windowWidth-150, 40, 120, 50)];
    [doneButton setBackgroundColor:[UIColor colorWithRed:(87.0/255.0) green:(201.0/255.0) blue:(250.0/255.0) alpha:1.0]];
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:AppFontBOLD(20)];
    [doneButton setTag:92];
    [doneButton addTarget:self action:@selector(commonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [holdingView addSubview:doneButton];
    return holdingView;
}

- (BOOL)validateContentWithData {
    
    BOOL isValidated = NO;
    if(!self.flowModalClassObj.strFlowName.length) {
        [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter flow name." onController:self];
    }
    else if(![self.flowModalClassObj.strFlowName isValidName]){
       [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter valid flow name." onController:self];
    }
    else
        isValidated = YES;
    
    return isValidated;
}


#pragma mark -******************** UITableViewDataSource Methods ***********************-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSection = 5;
   return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
            numberOfRows = self.flowModalClassObj.isManageFlowSelected?modelInfo.categoryArray.count:1;
        }
            break;
        case 1: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];

            numberOfRows = self.flowModalClassObj.isWhoCanViewSelected?modelInfo.viewPermissionArray.count:1;
        }
            break;
        case 2: {
             numberOfRows = 1;
//            numberOfRows = (self.flowModalClassObj.isCanPostSelected && !self.flowModalClassObj.isViewSelectedUser)?arrayCanPostToFlowOptions.count:1;
        }
            break;
        case 3: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];

            numberOfRows = self.flowModalClassObj.isCanPostSelected?modelInfo.postPermissionArray.count:1;
//            numberOfRows = (!self.flowModalClassObj.isCanPostSelected && self.flowModalClassObj.isViewSelectedUser)?arrayCanPostToFlowOptions.count:1;
        }
            break;
        case 4: {
//            numberOfRows = (self.flowModalClassObj.isCanPostSelected  && !self.flowModalClassObj.isPostSelectedUser)?arrayCanPostToFlowOptions.count:1;
            numberOfRows = 1;
        }
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FFFlowTableCell *flowCell = [tableView dequeueReusableCellWithIdentifier:flowCellIdentifier];
    [flowCell.flowIconImageView setHidden:(!indexPath.row)?NO:YES];
    flowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FFFlowTextViewTableCell *textFieldCell = [tableView dequeueReusableCellWithIdentifier:textFieldCellIdentifier];
    textFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [textFieldCell.flowTextView setTag:(indexPath.section+100)];
    
    switch (indexPath.section) {
        case 0: {
            
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
            
            FFFanzoneModelInfo *modelCategoryInfo = [modelInfo.categoryArray objectAtIndex:indexPath.row];
            flowCell.flowTextlabel.text = modelCategoryInfo.categoryName;
            return flowCell;
        }
            break;
        case 1: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];

            FFFanzoneModelInfo *modelPermissionInfo = [modelInfo.viewPermissionArray objectAtIndex:indexPath.row];
            flowCell.flowTextlabel.text = modelPermissionInfo.viewPermissionName;
            return flowCell;
        }
            break;
        case 2: {
            textFieldCell.flowTextView.text = self.flowModalClassObj.viewByString;
            return textFieldCell;
        }
            break;
        case 3: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
            
            FFFanzoneModelInfo *modelPermissionInfo = [modelInfo.postPermissionArray objectAtIndex:indexPath.row];
            flowCell.flowTextlabel.text = modelPermissionInfo.postPermissionName;
            return flowCell;
        }
            break;
        case 4: {
            textFieldCell.flowTextView.text = self.flowModalClassObj.flowSharedWithString;
            return textFieldCell;
        }
            break;
        default:
            return flowCell;
            break;
    }
}

#pragma mark -******************* UITableViewDelegate methods ****************-
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return  tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewSection = [[UIView alloc]initWithFrame:CGRectMake(15.0, 0.0, windowWidth-30, 50)];
    UILabel *labelHeaderText = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 0.0, windowWidth-30, 50)];
    [labelHeaderText setFont:AppFont(14)];
    switch (section) {
        case 0: {
            [labelHeaderText setText:@"Select FLOW to manage"];
        }
            break;
        case 1: {
            [labelHeaderText setText:@"Set VIEWING Permission"];
        }
            break;
        case 2: {
            [labelHeaderText setText:@"Viewed by"];

        }
            break;
        case 3: {
             [labelHeaderText setText:@"Set POSTING Permission"];

        }
            break;
        case 4: {
             [labelHeaderText setText:@"Flow shared with:"];
         
        }
            break;
        default:
            break;
    }
    [viewSection setBackgroundColor:[UIColor whiteColor]];
    [viewSection addSubview:labelHeaderText];
    return viewSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section) {
        case 0: {
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];

            FFFanzoneModelInfo *modelCategoryInfo = [modelInfo.categoryArray objectAtIndex:indexPath.row];

            if(indexPath.row == modelInfo.categoryArray.count-1) {
                  [self.createNewFlowView setHidden:NO];
            }
            else {
                [modelInfo.categoryArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
                modelInfo.categorySlugName = modelCategoryInfo.categorySlugName;
                self.flowModalClassObj.isManageFlowSelected = !self.flowModalClassObj.isManageFlowSelected;
            }
        }
            break;
        case 1: {

            
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
            
            FFFanzoneModelInfo *modelPermissionInfo = [modelInfo.viewPermissionArray objectAtIndex:indexPath.row];
            modelInfo.viewPermissionType = modelPermissionInfo.viewPermissionType;

            NSString *selectStr = modelPermissionInfo.viewPermissionName;

             [modelInfo.viewPermissionArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
            self.flowModalClassObj.isWhoCanViewSelected = !self.flowModalClassObj.isWhoCanViewSelected;
            
            
            if ([selectStr isEqualToString:@"SELECTED USERS"]) {
                
                FFSelectedUserViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFSelectedUserViewControllerId"];
                controller.delegate = self;
                controller.viewPermission = @"viewPermission";
                [self presentViewController:controller animated:YES completion:nil];
            }else {
                [modelInfo.selectedViewByUserArray removeAllObjects];
            }
        }
            break;
        case 2: {
        
       }
            break;
        case 3: {
            
            FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
            
            FFFanzoneModelInfo *modelPermissionInfo = [modelInfo.postPermissionArray objectAtIndex:indexPath.row];
            
            modelInfo.postPermissionType = modelPermissionInfo.postPermissionType;

            NSString *selectStr = modelPermissionInfo.postPermissionName;

            [modelInfo.postPermissionArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
            self.flowModalClassObj.isCanPostSelected = !self.flowModalClassObj.isCanPostSelected;
            
            
            if ([selectStr isEqualToString:@"SELECTED USERS"]) {
                
                FFSelectedUserViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFSelectedUserViewControllerId"];
                controller.delegate = self;
                controller.viewPermission = @"postPermission";
                [self presentViewController:controller animated:YES completion:nil];
            }else {
                [modelInfo.selectedPostByUserArray removeAllObjects];
            }
//            self.flowModalClassObj.isViewSelectedUser = NO;
//            self.flowModalClassObj.isPostSelectedUser = NO;
        }
            break;
        case 4: {
//            self.flowModalClassObj.isViewSelectedUser = NO;
//            self.flowModalClassObj.isPostSelectedUser = NO;
        }
            break;
        default:
            break;
    }
    [self.flowTableView reloadData];
}

#pragma mark-******************** Button Actions & Selector Methods ********************-
- (void)commonButtonAction: (UIButton *)sender {
    switch (sender.tag) {
        //back button Action
        case 91: {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            //Done Button Action
        case 92:{
            
            [self makeWebApiCallToUpdateManageFlow];
            
        }
        default:
            break;
    }
}

- (void)tappedOnView: (UIGestureRecognizer *)gestureRecorgnizer {
    
    CGPoint point = [gestureRecorgnizer locationInView:self.createNewWhiteView];
    if ( !CGRectContainsPoint(self.createNewWhiteView.bounds, point) ) {
        // Point lies inside the bounds.
        [self.createNewFlowView setHidden:YES];
       // [arrayFlowManageOptions exchangeObjectAtIndex:arrayFlowManageOptions.count-1 withObjectAtIndex:0];
        [self.flowTableView reloadData];
    }
}

- (IBAction)createButtonAction:(UIButton *)sender {
    
    if([self validateContentWithData]) {
        
        [self makeWebApiCallToCreateCategory];
       
    }
}


#pragma mark - Custom Delegate Method

- (void)selectedUser:(NSMutableArray *)userArray :(NSString *)permission {
    
    FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];


    if ([permission isEqualToString:@"viewPermission"]) {
            myViewPermissionString = [NSString stringWithFormat:@"@%@",[[userArray valueForKey:@"userName"] componentsJoinedByString:@"@"]];
        [modelInfo.selectedViewByUserArray removeAllObjects];
    }
    else {
        myPostPermissionString = [NSString stringWithFormat:@"@%@",[[userArray valueForKey:@"userName"] componentsJoinedByString:@"@"]];
        [modelInfo.selectedPostByUserArray removeAllObjects];
    }

    for (FFConnectionModal *obj in userArray) {
        if ([permission isEqualToString:@"viewPermission"]) {
            [modelInfo.selectedViewByUserArray addObject:obj.otherUserID];
            self.flowModalClassObj.viewByString = myViewPermissionString;
        }
        else {
            [modelInfo.selectedPostByUserArray addObject:obj.otherUserID];
            self.flowModalClassObj.flowSharedWithString = myPostPermissionString;
        }
    }

    [self.flowTableView reloadData];
}


#pragma mark -********************** TextField Delegate Methods *************************-
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    switch (textView.tag) {
        case 102: {
            if(self.flowModalClassObj.viewByString.length)
                textView.text = self.flowModalClassObj.viewByString;
            else
                textView.text = @"";
        }
            break;
        case 104: {
            if(self.flowModalClassObj.flowSharedWithString.length)
                textView.text = self.flowModalClassObj.flowSharedWithString;
            else
                textView.text = @"";

        }
            break;
        default:
            break;
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *strComplete  = [textView.text stringByReplacingCharactersInRange:range withString:text];
    switch (textView.tag) {
        case 102: {
            self.flowModalClassObj.viewByString = strComplete;
        }
            break;
        case 104: {
            self.flowModalClassObj.flowSharedWithString = strComplete;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark -************************* UITextFieldDelegate Methods *********************-
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *strComplete = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.flowModalClassObj.strFlowName = strComplete;
    return YES;
}


#pragma mark - Service Helper Method

- (void)makeWebApiCallToCreateCategory {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiCreateCategory forKey:KAction];
    [dictRequest setValue:self.flowModalClassObj.strFlowName forKey:KCategoryName];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KSuccess andMessage:strResponseMessage onController:self];

                [self.selectNameTextField resignFirstResponder];
                [self.createNewFlowView setHidden:YES];
                [self makeWebApiCallForGetFlows];


            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
        }
    }];
}


- (void)makeWebApiCallToUpdateManageFlow {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
    [dictRequest setValue:apiUpdateManageFlow forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:modelInfo.viewPermissionType forKey:KViewType];
    [dictRequest setValue:modelInfo.categorySlugName forKey:KCategorySlug];
    [dictRequest setValue:modelInfo.postPermissionType forKey:KPostType];
    [dictRequest setValue:modelInfo.selectedViewByUserArray forKey:KViewSelectedUserId];
    [dictRequest setValue:modelInfo.selectedPostByUserArray forKey:KPostSelectedUserId];
    
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




- (void)makeWebApiCallForGetFlows {
    
    [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiGetFlows forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];

            if (strResponseCode.integerValue == 200) {
                
                [arrayFlowManageOptions removeAllObjects];
                
                [arrayFlowManageOptions addObject:[FFFanzoneModelInfo fanzoneManageFlowResponse:response]];
                
                FFFanzoneModelInfo *modelObj = [arrayFlowManageOptions firstObject];
                FFFanzoneModelInfo *modelTempObj = [[FFFanzoneModelInfo alloc] init];
                
                modelObj.selectedPostByUserArray = [NSMutableArray array];
                modelObj.selectedViewByUserArray = [NSMutableArray array];

                modelTempObj.categoryName = @"CREATE FLOW";
                [modelObj.categoryArray addObject:modelTempObj];
                
                FFFanzoneModelInfo *modelInfo = [arrayFlowManageOptions firstObject];
                FFFanzoneModelInfo *modelCategoryInfo = [modelInfo.categoryArray firstObject];

                modelInfo.categorySlugName = modelCategoryInfo.categorySlugName;
                
                
                NSString *sharedFlowUserName = [NSString stringWithFormat:@"@%@",[[modelInfo.selectedPostArray valueForKey:KUserName] componentsJoinedByString:@"@"]];
                
                NSString *viewByUserName = [NSString stringWithFormat:@"@%@",[[modelInfo.selectedViewArray valueForKey:KUserName] componentsJoinedByString:@"@"]];

                if ([sharedFlowUserName isEqualToString:@"@"])
                    self.flowModalClassObj.flowSharedWithString = @"";
                else
                    self.flowModalClassObj.flowSharedWithString = sharedFlowUserName;
                
                if ([viewByUserName isEqualToString:@"@"])
                    self.flowModalClassObj.viewByString = @"";
                else
                    self.flowModalClassObj.viewByString = viewByUserName;
                
                modelInfo.selectedViewByUserArray = [[modelInfo.selectedViewArray valueForKey:@"userId"] mutableCopy];
                modelInfo.selectedPostByUserArray = [[modelInfo.selectedPostArray valueForKey:@"userId"] mutableCopy];

                FFFanzoneModelInfo *modelPermissionInfo = [modelInfo.viewPermissionArray firstObject];
                modelInfo.viewPermissionType = modelPermissionInfo.viewPermissionType;
                
                FFFanzoneModelInfo *modelPostPermissionInfo = [modelInfo.postPermissionArray firstObject];
                modelInfo.postPermissionType = modelPostPermissionInfo.postPermissionType;

                [self.flowTableView reloadData];
                
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
