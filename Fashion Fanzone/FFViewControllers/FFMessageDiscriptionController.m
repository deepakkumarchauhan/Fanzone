//
//  FFMessageDiscriptionController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 29/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMessageDiscriptionController.h"
#import "MWPhotoBrowser.h"


@interface FFMessageDiscriptionController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource , MWPhotoBrowserDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate>
{
    NSInteger currentIndex;
}
@property (nonatomic, weak) IBOutlet UILabel * userProfileName;
@property (nonatomic, weak) IBOutlet UILabel * userStylePoints;
@property (nonatomic, weak) IBOutlet UIImageView * userProfileImageView;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *messageListArray;
@property (nonatomic, strong) NSMutableArray * photos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FFMessageDiscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
   self.messageListArray = self.modelInfo.chatArray;
   [self initiatePageController];
    
    _userProfileName.text = self.modelInfo.displayName;
    _userStylePoints.text = [NSString stringWithFormat:@"%@ Style Points",self.modelInfo.stylePoints];
    
    [self.userProfileImageView sd_setImageWithURL:[NSURL URLWithString:self.modelInfo.userProfileImage] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self initiatePageController];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--- InitiatePageController----


-(void)initiatePageController
{
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    FFMessageDecriptionViewController * initialViewController;
    
    if (self.isFromThread) {
        initialViewController = [self viewControllerAtIndex:self.pageIndex];
    }
    else {
        initialViewController = [self viewControllerAtIndex:0];
    }
    
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [[self.pageViewController view] setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    [self.view sendSubviewToBack:[self.pageViewController view]];
    [self makeWebApiCallForReadMessage];
    
}

#pragma mark-
#pragma mark Pagecontroller delegate methods-



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFMessagelistViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(FFMessagelistViewController *)viewController index];
    
    
    index++;
    
    if (index >= self.messageListArray.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}


- (FFMessageDecriptionViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    FFMessageDecriptionViewController *childViewController = (FFMessageDecriptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFMessageDecriptionViewController"];
    childViewController.index = index;
    childViewController.messageArray = self.messageListArray;
    return childViewController;
    
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.messageListArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger pageIndex = ((FFMessagelistViewController *) [self.pageViewController.viewControllers objectAtIndex:0]).index;
    NSLog(@"==== %lu", (unsigned long)pageIndex);
    currentIndex = pageIndex;


}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}



#pragma mark-
#pragma mark //******* IBAction Methods ******//


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)exportButotnClieck:(id)sender
{
     FFMessageModal * messageModal = self.messageListArray[currentIndex];
    
    
//    if (![[NSString stringWithFormat:@"%@",messageModal.senderID] isEqualToString:[NSString stringWithFormat:@"%@",[NSUSERDEFAULT valueForKey:KUserId]]]) {
        [AlertView actionSheet:nil message:nil andButtonsWithTitle:[NSArray arrayWithObjects:@"FORWARD",@"REPLY WITH TEXT", @"REPLY WITH PHOTO" ,@"SHARE",nil] dismissedWith:^(NSInteger index, NSString * buttonTitle)
         {
             switch (index) {
                 case 0:
                 {
                     [self forwardMessage];
                 }
                     
                     break;
                 case 1:
                 {
                     [self replayWithText];
                 }
                     
                     break;
                 case 2:
                 {
                     [self replayWithImage];
                 }
                     
                     break;
                 case 3:
                 {
                     [self shareMessage];
                 }
                     
                     break;
                     
                 default:
                     break;
             }
         }];
 
//    }
//    else{
//    [AlertView actionSheet:nil message:nil andButtonsWithTitle:[NSArray arrayWithObjects:@"FORWARD",@"SHARE",nil] dismissedWith:^(NSInteger index, NSString * buttonTitle)
//     {
//         switch (index) {
//             case 0:
//             {
//                 [self forwardMessage];
//             }
//                 
//                 break;
//            case 1:
//             {
//                 [self shareMessage];
//             }
//                 
//                 break;
//                 
//             default:
//                 break;
//         }
//     }];
    //}
}

-(IBAction)indexButtonClicked:(id)sender
{
   
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[FFDirectMessageViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
    
}

-(void)forwardMessage
{
    if (currentIndex < self.messageListArray.count) {
        FFDirectMessageContactList * controller = (FFDirectMessageContactList *)[self.storyboard instantiateViewControllerWithIdentifier:@"FFDirectMessageContactList"];
        controller.isForwardMessage = YES;
        controller.messageModal = self.messageListArray[currentIndex];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
-(void)replayWithText
{
    FFPostModal * modalPost = [[FFPostModal alloc] init];
    FFMessageModal * messageModal = self.messageListArray[currentIndex];
    modalPost.messageReceipent = [NSArray arrayWithObjects:messageModal.senderID, nil];
    modalPost.postCatptions = messageModal.message;
    modalPost.postTitle = messageModal.messageTitle;
    FFTextEditiorViewController * editor = (FFTextEditiorViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"FFTextEditiorViewController"];
    editor.isMessaging = YES;
    editor.modalPost = modalPost;
    [self.navigationController pushViewController:editor animated:YES];
}
-(void)replayWithImage
{
    [AlertView actionSheet:nil message:nil andButtonsWithTitle:[NSArray arrayWithObjects:@"GALLERY",@"CAMERA",nil] dismissedWith:^(NSInteger index, NSString * buttonTitle)
     {
         switch (index) {
             case 0:
             {
                 [self replyWithGallery];
             }
                 
                 break;
             case 1:
             {
                 [self replyWithCamera];
             }
                 
                 break;
                 
             default:
                 break;
         }
     }];
}


-(void)replyWithGallery
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController     alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)replyWithCamera
{
    FFPostModal * modalPost = [[FFPostModal alloc] init];
    FFMessageModal * messageModal = self.messageListArray[currentIndex];
    modalPost.messageReceipent = [NSArray arrayWithObjects:messageModal.senderID, nil];
    modalPost.postTitle = messageModal.messageTitle;
    
    FFCameraViewController * cameraControler = (FFCameraViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFCameraViewController"];
    cameraControler.isMessaging = YES;
    cameraControler.modalPost = modalPost;
    [self.navigationController pushViewController:cameraControler animated:YES];
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    FFPostModal * modalPost = [[FFPostModal alloc] init];
    FFMessageModal * messageModal = self.messageListArray[currentIndex];
    modalPost.messageReceipent = [NSArray arrayWithObjects:messageModal.senderID, nil];
    modalPost.postTitle = messageModal.messageTitle;

    FFImageColourPickerVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFImageColourPickerVC"];
    imageVC.imageObject = img;
    imageVC.isFromCameraClick = YES;
    imageVC.isMessaging = YES;
    imageVC.modalPost = modalPost;
    [self.navigationController pushViewController:imageVC animated:NO];
}

-(void)shareMessage
{
     FFMessageModal * messageModal = self.messageListArray[currentIndex];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:messageModal.imageUrl]];
        NSString *textToShare = messageModal.message;
       NSArray *activityItems = [NSArray arrayWithObjects:textToShare, nil];
        if (data) {
            UIImage * image = [UIImage imageWithData:data];
            activityItems = [NSArray arrayWithObjects:textToShare,image, nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:activityViewController animated:YES completion:nil];
            
        });
    });

    
   
    
    
}


#pragma mark - Service Helper Method

- (void)makeWebApiCallForReadMessage {
    
    FFMessageModal *modelInfo = [self.messageListArray firstObject];
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiReadMessage forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KReceiverID];
    [dictRequest setValue:modelInfo.message_id forKey:KMessageID];

    [[ServiceHelper_AF3 instance] makeWebApiCallWithParameters:dictRequest AndPath:@"" WithCompletion:^(BOOL suceeded, NSString *error, id response) {
        
        if (suceeded) {
            
            NSString *strResponseCode = [response objectForKeyNotNull:KresponseCode expectedObj:@""];
           if (strResponseCode.integerValue == 200) {
               
            }
        }
    }];
}

@end
