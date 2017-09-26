//
//  FFPostDetailViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 03/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFPostDetailViewController.h"
#import "MBTwitterScroll.h"



@interface FFPostDetailViewController ()<UITableViewDelegate, UITableViewDataSource, MBTwitterScrollDelegate , SwipeableCellDelegate , UIGestureRecognizerDelegate , UITextFieldDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate>
{
    FFPostDetailHeaderView * sectionHeader;
    MBTwitterScroll *myTableView;
    UIView * toolBarView;
    UITextField * textfld;
    NSMutableArray *detailArray;
    UIButton * imageButton;
    UIButton *commentButton;
    BOOL isFirstTime;
    UIButton * addBtn;
}

@property (nonatomic , strong )UITableView * commentTable;
@property (nonatomic , strong ) UIImageView * likeImage;
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@property (nonatomic, strong)  UIButton * commentBtn;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign)  NSInteger  selectedIndex;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong)  NSTimer  *timer;

@end

@implementation FFPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // For hide pos detail indicator
    isFirstTime = NO;
    [self createSubView];
    self.cellsCurrentlyEditing = [NSMutableArray array];
    [self manageToolBar];
    textfld.autocorrectionType = UITextAutocorrectionTypeNo;
    // Alloc Array
    detailArray = [NSMutableArray array];
    [self makeWebApiCallForGetFanzonePostDetail];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark - Notification Methods

- (void)keyboardWillShow:(NSNotification *)note {
    
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView animateWithDuration:0.5f animations:^{
            myTableView.tableView.frame = CGRectMake(0, myTableView.tableView.frame.origin.y, windowWidth, myTableView.tableView.frame.size.height-(kbSize.height+40));

        }];

    
        [self.view layoutSubviews];
        
    } completion:^(BOOL finished) {
        FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
        if ([modelInfo.commentArray count]) {
            [myTableView.tableView reloadData];
            
            NSIndexPath *lastIndexPath = [self lastIndexPath];
            
            [myTableView.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        }
    }];
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [myTableView.tableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [myTableView.tableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [UIView animateWithDuration:[[[note userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

        [UIView animateWithDuration:0.5f animations:^{
            myTableView.tableView.frame = CGRectMake(0, myTableView.tableView.frame.origin.y, windowWidth, myTableView.tableView.frame.size.height+(kbSize.height+40));
        }];
        [self.view layoutSubviews];
    } completion:^(BOOL finished) {
        
        FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
        if ([modelInfo.commentArray count]) {
            [myTableView.tableView reloadData];

            NSIndexPath *lastIndexPath = [self lastIndexPath];
            [myTableView.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}


#pragma mark CReate Subview-----

-(void)createSubView
{
    
    FFFanzoneModelInfo *tempInfo = [self.fanzoneModal.userPostArray firstObject];
    
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.publishImage] placeholderImage:[UIImage imageNamed:@"Banner"]];

    
    myTableView  = [[MBTwitterScroll alloc] initTableViewWithBackgound:self.postImageView.image andDataModal:_profileModal];
    myTableView.tableView.delegate = self;
    myTableView.tableView.dataSource = self;
    myTableView.delegate = self;
    [self addGestureOnImageView];
    myTableView.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"horizontalBar"]];
    
    UINib * nib = [UINib nibWithNibName:@"FFPostCommentsTableViewCell" bundle:nil];
    [myTableView.tableView registerNib:nib forCellReuseIdentifier:@"postcomment"];
    nib = [UINib nibWithNibName:@"FFPostDescriptionTableViewCell" bundle:nil];
    [myTableView.tableView registerNib:nib forCellReuseIdentifier:@"post"];
    myTableView.tableView.estimatedRowHeight = 78;
    myTableView.tableView.rowHeight =  UITableViewAutomaticDimension;
    myTableView.headerHidden = NO;
    myTableView.tableView.bounces = NO;
    [self.view addSubview:myTableView];
    
    _exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 3, 50, 35)];
    [_exitBtn addTarget:self action:@selector(callBack:) forControlEvents:UIControlEventTouchUpInside];
    [_exitBtn setTitle:@"Back" forState:UIControlStateNormal];
    [_exitBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    //Header Top Right Dot Button
    commentButton = [[UIButton alloc] initWithFrame:CGRectMake(windowWidth-40, 9, 40, 18)];
    [commentButton setImage:[UIImage imageNamed:@"CommentEdit"] forState:UIControlStateNormal];
    commentButton.contentMode = UIViewContentModeScaleAspectFill;
    commentButton.clipsToBounds = YES;
    [commentButton addTarget:self action:@selector(commentButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    _hederViewBlack =[[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 35)];
    _hederViewBlack.backgroundColor =[UIColor blackColor];
    _hederViewBlack.alpha = 0.3f;
    _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, MainScreenWidth-100, 35)];
    _headerImage.image = [UIImage imageNamed:@"ffplane_white"];
    _headerImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_commentBtn];
    [self.view addSubview:_hederViewBlack];
    [self.view addSubview:_headerImage];
    [self.view addSubview:_exitBtn];
    [self.view addSubview:commentButton];
    
    [self.view addSubview:self.activityIndicatorView];

    [self manageHeaderFrames:0];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * likeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    [likeTap setNumberOfTapsRequired:2];
    likeTap.delegate = self;
    [tap requireGestureRecognizerToFail:likeTap];
    
    [self.view addGestureRecognizer:likeTap];
    
    _likeImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _likeImage.image = [UIImage imageNamed:@"yay"];
   
    //_likeImage.image = [UIImage animatew]
    _likeImage.contentMode = UIViewContentModeScaleAspectFit;
    _likeImage.hidden = YES;
    [self.view addSubview:_likeImage];
    
}

#pragma mark-
#pragma mark UItapGesture Delegate  Methods---
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer
                                                                                                                       *)otherGestureRecognizer
{  return YES;
}


- (void)addGestureOnImageView {
    
    // Add Swipe Gesture to image
    [self.view setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

#pragma mark-
#pragma mark Timer Methods---

#pragma mark - Timer Method
-(void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(swipeTutorialScreenAutomatically) userInfo:nil repeats:YES];
}

-(void)swipeTutorialScreenAutomatically {
    
    if (!self.view.isAccessibilityElement) {
        [self leftMove_faster:NO];
    }else {
        [self rightMove_faster:NO];
    }
}



-(void)viewDoubleTapped:(UITapGestureRecognizer*)doubleTap
{
    _likeImage.alpha = 1;
    _likeImage.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _likeImage.hidden = NO;
    [self hideToolBar];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _likeImage.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _likeImage.center = self.view.center;
    }completion:^(BOOL finish)
     {
         if (finish) {
             [UIView transitionWithView:_likeImage duration:1.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                 
             }completion:^(BOOL finish)
              {
                  if (finish) {
                      _likeImage.hidden = YES;
                      
                      [self makeWebApiCallForLikeUnlikePost];
                  }
              }];
         }
         
     }];}

-(void)viewTapped:(UITapGestureRecognizer*)getsure
{
    CGPoint touchPoint = [getsure locationInView: self.view];
    if (touchPoint.y > (MainScreenHeight-50)) {
        return;
    }
    
    [self hideToolBar];
    [UIView animateWithDuration:0.3 animations:^{
        
        
        if (_hederViewBlack.frame.origin.y==0) {
            [self manageHeaderFrames:-70];
            
            CGRect frame = myTableView.tableView.tableHeaderView.frame;
            frame.size.height = MainScreenHeight-(35+60);
            myTableView.tableView.tableHeaderView.frame = frame;
            myTableView.tableView.contentOffset = CGPointMake(0, -50);
            myTableView.tableView.scrollEnabled = NO;
        }
        else
        {
            [self manageHeaderFrames:0];
            
            CGRect frame = myTableView.tableView.tableHeaderView.frame;
            frame.size.height = MainScreenHeight-35;
            myTableView.tableView.tableHeaderView.frame = frame;
            myTableView.tableView.contentOffset = CGPointMake(0, 0);
            myTableView.tableView.scrollEnabled = YES;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)manageHeaderFrames:(NSInteger)yVal
{
    _hederViewBlack.frame = CGRectMake(0, yVal, MainScreenWidth, 35);
    _exitBtn.frame = CGRectMake(5, yVal+5, 60, 30);
    _commentBtn.frame = CGRectMake(MainScreenWidth-45, yVal+5+2, 45, 30);
    _headerImage.frame = CGRectMake(55, yVal, MainScreenWidth-110, 35);
    commentButton.frame = CGRectMake(windowWidth-40, yVal+9, 40, 18);

}

#pragma mark-
#pragma mark- IBActionMethods-----********

- (void) recievedMBTwitterScrollButtonClicked {
    // [self.navigationController popViewControllerAnimated:YES];
}
-(void)recievedMBTwitterScrollEvent
{
    
}
-(void)callStoryComment:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        toolBarView.frame = CGRectMake(0, MainScreenHeight-250, MainScreenWidth, 40);
        [textfld becomeFirstResponder];
        
    }];
}
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)commentButtonAction:(UIButton *)sender {
    
    
    if ([[NSString stringWithFormat:@"%@",[NSUSERDEFAULT valueForKey:KUserId]] isEqualToString:self.fanzoneModal.postAddUserId]) {
        
        [AlertView actionSheet:nil message:nil andButtonsWithTitle:[NSArray arrayWithObjects:@"COMMENT ON POST",@"DELETE POST",nil] dismissedWith:^(NSInteger index, NSString * buttonTitle)
         {
             switch (index) {
                 case 0:
                 {
                     [textfld becomeFirstResponder];
                     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                     [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
                 }
                     
                     break;
                 case 1:
                 {
                     [[AlertView sharedManager] presentAlertWithTitle:kAPPName message:@"Are you sure you want to delete this post ?" andButtonsWithTitle:[NSArray arrayWithObjects:@"Yes", @"No", nil] onController:self dismissedWith:^(NSInteger index, NSString * buttonTitle)
                      {
                          if (index==0) {
                              [self makeWebApiCallDeletePost];
                          }
                          
                      }];
                     
                 }
                     
                     break;
                     
                 default:
                     break;
             }
         }];

    }else {
        [textfld becomeFirstResponder];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    return modelInfo.commentArray.count+1;
    
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {//
    
    if (indexPath.row==0) {
        FFPostDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post"];
        FFFanzoneModelInfo *modelInfo = [detailArray firstObject];

        cell.nameLabel.text = modelInfo.userName;
        cell.descriptionView.text = modelInfo.fanzoneDescription;
        if (modelInfo == nil) {
            cell.stylePointLabel.text = @"";
        }else
            cell.stylePointLabel.text = [NSString stringWithFormat:@"(%@)Style Points", modelInfo.stylePoints];
        
        cell.noOfLikeLabel.text = modelInfo.likeCount;
        cell.noOfCommentsLabel.text = modelInfo.commentCount;

        [cell.userprofileImageView sd_setImageWithURL:[NSURL URLWithString:modelInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
       // cell.userprofileImageView.image = [UIImage imageNamed:@"img9"];
        cell.backgroundColor = [UIColor clearColor];
        [cell.commentBtn addTarget:self action:@selector(postCommentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeBtn addTarget:self action:@selector(postLikeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.exportBtn addTarget:self action:@selector(postExportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:indexPath.row-1];


    NSString *identifier = @"postcomment";
    FFPostCommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FFPostCommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.commentImageButton.tag = indexPath.row+399;
    cell.likeBtn.tag = indexPath.row+399;
    cell.exportBtn.tag = indexPath.row+399;
    cell.shareBtn.tag = indexPath.row+399;
    cell.deleteBtn.tag = indexPath.row+399;

    [cell.commentImageButton addTarget:self action:@selector(commentImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likeBtn addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.exportBtn addTarget:self action:@selector(exportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareBtn addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteBtn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    [cell.commentImageButton sd_setImageWithURL:[NSURL URLWithString:modelCommentInfo.publishImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Banner"]];


    cell.delegate = self;
    cell.nameLabel.text =  modelCommentInfo.userName;
    cell.postDecription.text = modelCommentInfo.comment;
    cell.likeCountLabel.text = modelCommentInfo.likeCount;

    [cell.userProfileImageView sd_setImageWithURL:[NSURL URLWithString:modelCommentInfo.profileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
        [cell openCell];
    }
    
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 95;
    }else
        return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1
        // [_objects removeObjectAtIndex:indexPath.row];
        
        //2
        // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark-
#pragma mark ***************/////    IBaction Methods *************  ///////



-(void)postCommentButtonClicked:(id)sender
{
//    CGRect frame = myTableView.tableView.tableHeaderView.frame;
//    frame.size.height = MainScreenHeight-(35+60);
//    myTableView.tableView.tableHeaderView.frame = frame;
//    myTableView.tableView.contentOffset = CGPointMake(0, 10);
    
}


-(void)postLikeButtonClicked:(id)sender
{
    
}
-(void)postExportButtonClicked:(id)sender
{
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight-40, MainScreenWidth, 40);
    NSMutableArray *activityItems = [NSMutableArray array];
    if (self.postImageView.image != nil) {
        [activityItems addObject:self.postImageView.image];
    }
    
    if (![self.fanzoneModal.fanzoneDescription isEqualToString:@""]) {
        [activityItems addObject:self.fanzoneModal.fanzoneDescription];
    }

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}


-(void)commentImageButtonAction:(UIButton *)sender {
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:sender.tag-400];
    NSURL *url = [NSURL URLWithString:modelCommentInfo.publishImage];
    [[UIApplication sharedApplication] openURL:url];
}


-(void)likeButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    [self makeWebApiCallForLikeUnlikeComment:sender.tag-400];
}

-(void)exportButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:sender.tag-400];
    
    [UIView animateWithDuration:0.3 animations:^{
        toolBarView.frame = CGRectMake(0, MainScreenHeight-250, MainScreenWidth, 40);
        [textfld becomeFirstResponder];
        
    }];
    
    modelInfo.commentId = modelCommentInfo.commentId;
}

-(void)shareButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:sender.tag-400];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (modelCommentInfo.publishImage != nil) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:modelCommentInfo.publishImage]];
    }
    NSString *textToShare = modelCommentInfo.comment;

    NSArray *activityItems = [NSArray arrayWithObjects:textToShare,imageView.image, nil];

    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)deleteButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    [[AlertView sharedManager] presentAlertWithTitle:@"Are you sure!" message:@"You want to delete this comment?" andButtonsWithTitle:@[@"Yes",@"No"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        
        if (index == 0) {
            [self makeWebApiCallDeleteComment:sender.tag-400];
        }
    }];

}


- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSIndexPath *currentEditingIndexPath = [myTableView.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
    
}

- (void)cellDidClose:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[myTableView.tableView indexPathForCell:cell]];
}

- (void)buttonOneActionForItemText:(NSInteger)index
{
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    [self makeWebApiCallForLikeUnlikeComment:index];
}

- (void)buttonTwoActionForItemText:(NSInteger)index
{
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight, MainScreenWidth, 40);

    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:index];

    [UIView animateWithDuration:0.3 animations:^{
        toolBarView.frame = CGRectMake(0, MainScreenHeight-250, MainScreenWidth, 40);
        [textfld becomeFirstResponder];
        
    }];
    
    modelInfo.commentId = modelCommentInfo.commentId;
}

- (void)buttonThreeActionForItemText:(NSInteger)index
{
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight-40, MainScreenWidth, 40);

    [self makeWebApiCallDeleteComment:index];

}

- (void)buttonFourActionForItemText:(NSInteger)index
{
    [self.view endEditing:YES];
    toolBarView.frame = CGRectMake(0, windowHeight-40, MainScreenWidth, 40);

    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:index];
    
    NSString *textToShare = modelCommentInfo.comment;
    
    NSArray *activityItems =  @[textToShare];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];

}

-(void)hideToolBar
{
    [self.view endEditing:NO];
    textfld.text = @"";
    [textfld resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        toolBarView.frame = CGRectMake(0, MainScreenHeight, MainScreenWidth, 40);
        [textfld resignFirstResponder];
        
    }];
}



#pragma mark - Swipe Method
-(void)rightMove_faster:(BOOL)fast {
    if (self.selectedIndex-1 < 0 ) {
        return;
    }else{
        //self.rigthBackBtn.hidden=NO;
        CATransition *animation = [CATransition animation];
        [animation setDuration:(fast)?0.3:0.7];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [myTableView.headerImageView.layer addAnimation:animation forKey:@"SwitchToView1"];
        
        FFFanzoneModelInfo *tempInfo = [self.fanzoneModal.userPostArray objectAtIndex:self.pageControl.currentPage];

        [myTableView.headerImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.publishImage]];
        
        // [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.pageControl.currentPage]]];
        
        self.selectedIndex -= 1;
        self.pageControl.currentPage = self.selectedIndex;
        
        if (self.selectedIndex==0) {
            //  self.leftBackBtn.hidden=YES;
            
        }
    }
    if (self.selectedIndex == 0) {
        [self.postImageView setIsAccessibilityElement:NO];
    }
    
    FFFanzoneModelInfo *tempInfo = [self.fanzoneModal.userPostArray objectAtIndex:self.selectedIndex];
    [myTableView.headerImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.publishImage]];

}

-(void)leftMove_faster:(BOOL)fast{
    if (self.selectedIndex+1 < [self.fanzoneModal.userPostArray count]) {
        if (self.selectedIndex==0) {
            //  self.leftBackBtn.hidden=YES;
        }
        //self.leftBackBtn.hidden=NO;
        CATransition *animation = [CATransition animation];
        [animation setDuration:(fast)?0.3:0.7];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [myTableView.headerImageView.layer addAnimation:animation forKey:@"SwitchToView1"];
        //        [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.pageControl.currentPage]]];
        
        FFFanzoneModelInfo *tempInfo = [self.fanzoneModal.userPostArray objectAtIndex:self.pageControl.currentPage];
        [myTableView.headerImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.publishImage]];
        
        
        self.selectedIndex += 1;
        self.pageControl.currentPage = self.selectedIndex;
        
        if (self.selectedIndex==3) {
            //self.rigthBackBtn.hidden=YES;
        }
    }
    else{
        // self.rigthBackBtn.hidden=YES;
        return;
    }
    if (self.selectedIndex == 2) {
        [self.view setIsAccessibilityElement:YES];
    }
    FFFanzoneModelInfo *tempInfo = [self.fanzoneModal.userPostArray objectAtIndex:self.selectedIndex];
    [myTableView.headerImageView sd_setImageWithURL:[NSURL URLWithString:tempInfo.publishImage]];
    
    //   [self.bannerImageView setImage:[UIImage imageNamed:[self.imageArray objectAtIndex:self.selectedIndex]]];
}

#pragma mark - Selector Method
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft: {
            [self leftMove_faster:YES];
        }
            break;
            
        case UISwipeGestureRecognizerDirectionRight:{
            [self rightMove_faster:YES];
        }
            break;
        default:
            break;
    }
}





#pragma mark-
#pragma mark ManageTool Bar For Reply ***********

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.font = AppFont(14) ;
    [UIView animateWithDuration:0.3 animations:^{
        toolBarView.frame = CGRectMake(0, MainScreenHeight-250, MainScreenWidth, 40);
        [textfld becomeFirstResponder];
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hideToolBar];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    modelInfo.comment = TRIM_SPACE(str);
    
    if (modelInfo.comment.length) {
        addBtn.userInteractionEnabled = YES;
        addBtn.alpha = 1.0;
    }else {
        addBtn.userInteractionEnabled = NO;
        addBtn.alpha = 0.5;
    }
        
    return YES;
}


-(void)manageToolBar
{
    toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 40)];
    toolBarView.clipsToBounds = YES;
    toolBarView.backgroundColor = [UIColor whiteColor];
    toolBarView.opaque = YES;
    imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(0, 0, 50, 40);
    [imageButton setImage:[UIImage imageNamed:@"gallery"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(selectMediaFile:) forControlEvents:UIControlEventTouchUpInside];
    [toolBarView addSubview:imageButton];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(MainScreenWidth-50, 0, 50, 40);
    [addBtn setTitle:@"ADD" forState:UIControlStateNormal];
    addBtn.backgroundColor=[UIColor colorWithRed:80.0/255.0f green:200.0/255.0f blue:254.0/255.0f alpha:1];
    [addBtn addTarget:self action:@selector(replyOver:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.userInteractionEnabled = NO;
    addBtn.alpha = 0.5;
    [toolBarView addSubview:addBtn];
    
    textfld = [[UITextField alloc] initWithFrame:CGRectMake(55, 5, MainScreenWidth-110, 30)];
    textfld.borderStyle = UITextBorderStyleNone;
    textfld.delegate = self;
    [toolBarView addSubview:textfld];
    [self.view addSubview:toolBarView];
    
}
-(void)selectMediaFile:(UIButton*)mediaFile
{
    toolBarView.frame = CGRectMake(0, MainScreenHeight-40, MainScreenWidth, 40);
    [self.view endEditing:YES];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Fashion Fanzone" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        [self presentViewController:picker animated:YES completion:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [imagePicker setDelegate:self];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


-(void)replyOver:(UIButton*)mediaFile
{
    
    isFirstTime = YES;
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    if (modelInfo.comment.length) {
        textfld.text = @"";
        addBtn.userInteractionEnabled = NO;
        addBtn.alpha = 0.5;
        [self makeWebApiCallForPostComment];
    }else {
       // [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Error!" andMessage:@"Please enter comment." onController:self];
    }
}


-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    toolBarView.frame = CGRectMake(0, keyboardFrame.origin.y-40, MainScreenWidth, 40);

}



#pragma mark - ImagePicker Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
   UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    modelInfo.commentImage = image;
    
    [imageButton setImage:image forState:UIControlStateNormal];

}


#pragma mark - Helper Method

- (void)makeWebApiCallForGetFanzonePostDetail {
    
    if (!isFirstTime)
         [self showLoader];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiPostDetail forKey:KAction];
    [dictRequest setValue:self.fanzoneModal.publishId forKey:KPostID];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (!isFirstTime)
            [self hideLoader];
        
        if (suceeded) {
            
            [detailArray removeAllObjects];
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [detailArray removeAllObjects];
                
                [detailArray addObject:[FFFanzoneModelInfo fanzoneDetailResponse:response]];
                FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
                
                if (isFirstTime) {
                    if ([modelInfo.commentArray count]) {
                        [myTableView.tableView reloadData];
                        
                        NSIndexPath *lastIndexPath = [self lastIndexPath];
                        [myTableView.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }
                [myTableView.tableView reloadData];
                
            }else{
                [detailArray removeAllObjects];
                [myTableView.tableView reloadData];
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


- (void)makeWebApiCallForPostComment {
    
   // [self showLoader];

    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];


    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiPostComment forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserType] forKey:KUserType];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:modelInfo.postId forKey:KPostID];
    [dictRequest setValue:modelInfo.comment forKey:KComment];
    [dictRequest setValue:modelInfo.commentId forKey:KCommentID];

    if (modelInfo.commentImage != nil) {
        NSData *dataBannerImg = UIImageJPEGRepresentation(modelInfo.commentImage, 0.1);
        [dictRequest setValue:[dataBannerImg base64EncodedString] forKey:KPublishImage];
    }

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
      //  [self hideLoader];
        modelInfo.commentId = @"";
        [imageButton setImage:[UIImage imageNamed:@"gallery"] forState:UIControlStateNormal];

        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                if (!modelInfo.commentId.length) {
                    [self.delegate callFanzoneApi];
                }

                [self makeWebApiCallForGetFanzonePostDetail];
                modelInfo.comment = @"";
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


- (void)makeWebApiCallForLikeUnlikeComment:(NSInteger)index {
    
    [self showLoader];
    
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:index];

    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];

    [dictRequest setValue:apiLikeUnlikeComment forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:[modelCommentInfo.likeStatus isEqualToString:@"0"]?@"1":@"0" forKey:KLikeStatus];
    [dictRequest setValue:modelCommentInfo.commentId forKey:KCommentID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
               // [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Success!" andMessage:strResponseMessage onController:self];
                FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
                FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:index];
                modelCommentInfo.likeStatus = ([modelCommentInfo.likeStatus isEqualToString:@"0"]?@"1":@"0");
                [self makeWebApiCallForGetFanzonePostDetail];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
        }
    }];
}


- (void)makeWebApiCallForLikeUnlikePost {
    
    [self showLoader];
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiLikeUnlikePost forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];
    [dictRequest setValue:[modelInfo.likeStatus isEqualToString:@"0"]?@"1":@"0" forKey:KLikeStatus];
    [dictRequest setValue:modelInfo.postId forKey:KPostID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
//                [[AlertView sharedManager]displayInformativeAlertwithTitle:@"Success!" andMessage:strResponseMessage onController:self];
                FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
                modelInfo.likeStatus = [modelInfo.likeStatus isEqualToString:@"0"]?@"1":@"0";
                [self.delegate callFanzoneApi];

                [self makeWebApiCallForGetFanzonePostDetail];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}

- (void)makeWebApiCallDeleteComment:(NSInteger)index {
    
    [self showLoader];
    
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    FFFanzoneModelInfo *modelCommentInfo = [modelInfo.commentArray objectAtIndex:index];

    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiDeleteComment forKey:KAction];
    [dictRequest setValue:modelCommentInfo.commentId forKey:KCommentID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
               [self.delegate callFanzoneApi];
                [self makeWebApiCallForGetFanzonePostDetail];
                
            }else{
                [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:strResponseMessage onController:self];
            }
            
        }else{
            [[AlertView sharedManager]displayInformativeAlertwithTitle:KError andMessage:[response objectForKeyNotNull:KresponseMessage expectedObj:@""] onController:self];
            
        }
    }];
}


- (void)makeWebApiCallDeletePost {
    
    [self showLoader];
    
    FFFanzoneModelInfo *modelInfo = [detailArray firstObject];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    
    [dictRequest setValue:apiDeletePost forKey:KAction];
    [dictRequest setValue:modelInfo.postId forKey:KPostID];
    
    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        [self hideLoader];
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
            NSString *strResponseMessage = [response objectForKeyNotNull:KresponseMessage expectedObj:@""];
            
            if (strResponseCode.integerValue == 200) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"" message:strResponseMessage andButtonsWithTitle:[NSArray arrayWithObjects:@"Ok",nil] onController:self dismissedWith:^(NSInteger index, NSString * buttonTitle)
                 {
                     
                     [self.delegate callFanzoneApi];
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
