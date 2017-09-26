//
//  FFDarkRoomViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 14/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFDarkRoomViewController.h"
#import "QBImagePickerController.h"


@interface FFDarkRoomViewController ()<QBImagePickerControllerDelegate , UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIImageView * imview;
    BOOL shouldSelectImages;
    
}
@property (nonatomic,weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic,weak) IBOutlet UIButton * advancedBtn;
@property (nonatomic,weak) IBOutlet UIButton * selectButton;
@property (nonatomic,weak) IBOutlet UIButton * selectAllButton;
@property (nonatomic, strong) NSMutableArray * dataSourceArray;
@property (nonatomic, strong) NSMutableArray  * tempArray;
@property (nonatomic, strong) NSMutableArray * imageSelectedArray;
@end

@implementation FFDarkRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldSelectImages = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource  =self;
    self.dataSourceArray = [NSMutableArray new];
    self.tempArray = [NSMutableArray new];
    self.imageSelectedArray = [NSMutableArray new];
    self.collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
   [self.dataSourceArray addObjectsFromArray:self.preclickedImageArray];
    if (self.preclickedImageArray.count==1) {
        self.collectionView.hidden = YES;
        imview = [[UIImageView alloc] initWithFrame:self.collectionView.frame];
        FFImageProcess * image = self.preclickedImageArray[0];
        imview.image = image.oldImage;
        [self.view addSubview:imview];
    }
    else
    {
        self.collectionView.hidden = NO;
        
    }
     shouldSelectImages = YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
    
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 10);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width, 10);
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if(!view)
        view = [[UICollectionReusableView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFDarkroomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"darkCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    FFImageProcess * modal = self.dataSourceArray[indexPath.row];
    cell.imageView.image = modal.oldImage;
    if (modal.iselected) {
        cell.selctView.hidden = NO;
    }
    else
    {
        cell.selctView.hidden = YES;
    }
    
    
    
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray.count==1) {
        return CGSizeMake(MainScreenWidth-20, collectionView.frame.size.height);
    }
    NSInteger cellWidth = (MainScreenWidth-30)/3;
    return CGSizeMake(cellWidth, 120);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (shouldSelectImages) {
        FFImageProcess * modal = self.dataSourceArray[indexPath.row];
        if ([self.imageSelectedArray containsObject:modal]) {
            [self.imageSelectedArray removeObject:modal];
        }
        else
        {
            if (self.imageSelectedArray.count==10) {
                //display alert....
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"You cannot select more than 10 images." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
                 {
                     
                 }];
                return;
            }
            [self.imageSelectedArray addObject:modal];
        }
        
        if (modal.iselected) {
            modal.iselected = NO;
        }
        else
            
        {
            modal.iselected = YES;
        }
        [self.dataSourceArray replaceObjectAtIndex:indexPath.row withObject:modal];
        [self.collectionView reloadData];
        [self checkForMultipleImagesForAdvanceAdjustDisable];
    }
    
}

/////*** if selected images are greater than 1 than disbale adjust button
-(void)checkForMultipleImagesForAdvanceAdjustDisable
{
    if (self.imageSelectedArray.count>1) {
        self.advancedBtn.enabled = NO;
    }
    else
    {
        self.advancedBtn.enabled = YES;
    }
}






#pragma mark-
#pragma mark Manage Multiple photos----


-(void)manageMultiplePhotoGallery
{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeAny;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.maximumNumberOfSelection =20;
     [self presentViewController:imagePickerController animated:YES completion:NULL];
}
#pragma mark - QBImagePickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
   
    PHImageManager *manager = [PHImageManager defaultManager];
    
    PHImageRequestOptions * requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
   
    // assets contains PHAsset objects.
    __block UIImage *ima;
    
    for (PHAsset *asset in assets) {
        // Do something with the asset
        
        [manager requestImageForAsset:asset
                           targetSize:PHImageManagerMaximumSize
                          contentMode:PHImageContentModeDefault
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            ima = image;
                            
                            if (image) {
                                FFImageProcess * modal= [FFImageProcess new];
                                modal.oldImage = image;
                                modal.iselected = NO;
                                [self.dataSourceArray addObject:modal];
                                [self.tempArray addObject:modal];
                            }
                           
                            [self.collectionView reloadData];
                             self.collectionView.hidden = NO;
                             imview.hidden  = YES;
                        }];
        
        
    }
    
   
    
    requestOptions = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark-
#pragma mark IBAction Methods---


-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)selectImages:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"Deselect All"]) {
        [_dataSourceArray removeAllObjects];
        [_imageSelectedArray removeAllObjects];
        for (FFImageProcess * modal in _tempArray) {
             modal.iselected = NO;
            [_dataSourceArray addObject:modal];
        }
    }
     [self.collectionView reloadData];
    self.selectAllButton.enabled = YES;
    shouldSelectImages = YES;
}
-(IBAction)selectAll:(id)sender
{
    if (self.dataSourceArray.count>10) {
        // display message for only 7 images
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"You cannot select more than 10 images." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             
         }];
        return;
    }
    
    NSMutableArray *   temp = [NSMutableArray new];
    [self.imageSelectedArray removeAllObjects];
    for (FFImageProcess * modal in self.dataSourceArray) {
         modal.iselected = YES;
        [temp addObject:modal];
        [self.imageSelectedArray addObject:modal];
    }
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:temp];
    [self.collectionView reloadData];
    shouldSelectImages = YES;
    self.selectAllButton.enabled = NO;
    [self.selectButton setTitle:@"Deselect All" forState:UIControlStateNormal];
    [self checkForMultipleImagesForAdvanceAdjustDisable];
    temp = nil;
}
-(IBAction)compile:(id)sender
{
    if (self.imageSelectedArray.count==0) {
        [[AlertView sharedManager] presentAlertWithTitle:@"No image to compile" message:@"You have not selected any of the images to compile, please choose atleast one image." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * text)
         {
             
         }];
        return;
    }
    FFCompileViewController * compileObject = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCompileViewController"];
    compileObject.imagesArray = self.imageSelectedArray;
    compileObject.isFromCameraClick = _isFromCameraClick;
    [self.navigationController pushViewController:compileObject animated:YES];
    
}
-(IBAction)advancedAdjustments:(id)sender
{
    FFImageProcess * modal;
    if (_dataSourceArray.count==1) {
        [self.imageSelectedArray removeAllObjects];
        self.imageSelectedArray = [NSMutableArray arrayWithArray:_dataSourceArray];
    }
    if (self.imageSelectedArray.count==1) {
        modal = self.imageSelectedArray[0];
    }
    
    if (modal==nil) {
        [[AlertView sharedManager] presentAlertWithTitle:@"No image to adjustment" message:@"You have not selected any of the images for adjustment, please choose atleast one image." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * text)
         {
             
         }];
        return;
}
    FFImageColourPickerVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FFImageColourPickerVC"];
    imageVC.imageObject = modal.oldImage;
    imageVC.isFromCameraClick = _isFromCameraClick;
    [self.navigationController pushViewController:imageVC animated:YES];
    

}
-(IBAction)publish:(id)sender
{
    
    // user shoud select atleast one image to publish post.
    BOOL shouldShowAlert = NO;
    if (_dataSourceArray.count==0) {
        shouldShowAlert = YES;
    }
    if (_dataSourceArray.count==1) {
        [self.imageSelectedArray removeAllObjects];
        self.imageSelectedArray = [NSMutableArray arrayWithArray:_dataSourceArray];
        shouldShowAlert = NO;
    }
    if (self.imageSelectedArray.count==0 & _dataSourceArray.count!=1) {
         shouldShowAlert = YES;
    }
    
    if (shouldShowAlert) {
    [[AlertView sharedManager] presentAlertWithTitle:@"No image to publish" message:@"You have not selected any of the images to publish, please select atleast one image to publish post." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * text)
     {
         
     }];
        return;
    }
    FFCaptionViewController * colorpickerController = (FFCaptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFCaptionViewController"];
    colorpickerController.imageArrayToPublish = self.imageSelectedArray;
    colorpickerController.isFromCameraClick = _isFromCameraClick;
    [self.navigationController pushViewController:colorpickerController animated:YES];
}
-(IBAction)galleryBtn:(id)sender
{
    [self manageMultiplePhotoGallery];
}




@end
