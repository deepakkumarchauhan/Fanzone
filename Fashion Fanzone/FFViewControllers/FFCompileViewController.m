//
//  FFCompileViewController.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 17/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFCompileViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>



@interface FFCompileViewController ()
{
    BOOL dataCompile;
}
@property (nonatomic, weak) IBOutlet UILabel * timeLabel;
@property (nonatomic, weak) IBOutlet UIPickerView * optionPicker;
@property (nonatomic, weak) IBOutlet UIPickerView * timePicker;
@property (nonatomic, weak) IBOutlet UICollectionView * gifCollection;
@property (nonatomic, weak) IBOutlet UIView * collageView;
@property (nonatomic, strong) NSArray * timeSlotArray;
@property (nonatomic, strong) NSArray * optionArray;
@property (nonatomic, strong) NSString * selectedTimeString;
@property (nonatomic, strong) NSString * selectedOtionString;
@property (nonatomic, strong) NSMutableArray * myPics;




@end

@implementation FFCompileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myPics = [NSMutableArray new];
    dataCompile = NO;
    _timeSlotArray = [NSArray arrayWithObjects:@"0.1 Sec",@"0.2 Sec", @"0.3 Sec",@"0.4 Sec",@"0.5 Sec",@"0.6 Sec",@"0.7 Sec",@"0.8 Sec",@"0.9 Sec",@"1.0 Sec",@"1.1 Sec",@"1.2 Sec",@"1.3 Sec",@"1.4 Sec",@"1.5 Sec",@"1.6 Sec",@"1.7 Sec",@"1.8 Sec",@"1.9 Sec",@"2.0 Sec",nil];
    
    _optionArray = [ NSArray arrayWithObjects:@"SLIDESHOW",@"COLLAGE" ,nil];
    self.gifCollection.contentInset = UIEdgeInsetsMake(4, 6, 4,5);
    [self.gifCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"identifier"];
    [self.gifCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"identifier"];
    [self compileForCollage];
    [self.gifCollection reloadData];
    
    
    _collageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _collageView.layer.borderWidth = 1.0f;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([_selectedOtionString isEqualToString:@"COLLAGE"]) {
        _timeLabel.hidden = YES;
        _timePicker.hidden = YES;
        _collageView.hidden = NO;
        _gifCollection.hidden = YES;
    }
    else
    {
        _timeLabel.hidden = NO;
        _timePicker.hidden = NO;
        _collageView.hidden = YES;
        _gifCollection.hidden = NO;
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark Picker View Delegate Methods:-

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pV.tag==1) {
        if ([[_optionArray objectAtIndex:row] isEqualToString:@"COLLAGE"]) {
            _selectedOtionString = @"COLLAGE";
            _timeLabel.hidden = YES;
            _timePicker.hidden = YES;
            _collageView.hidden = NO;
            _gifCollection.hidden = YES;
        }
        else
        {
            _timeLabel.hidden = NO;
            _timePicker.hidden = NO;
            _collageView.hidden = YES;
            _gifCollection.hidden = NO;
             _selectedOtionString = @"";
        }
    }
    else
    {
        _selectedTimeString = _timeSlotArray[row];
        _selectedTimeString = [[_selectedTimeString componentsSeparatedByString:@" "] objectAtIndex:0];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    [pickerView.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        subview.hidden = (CGRectGetHeight(subview.frame) == 0.5);
    }];
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return _optionArray.count;
    }
    return _timeSlotArray.count;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        
        return _optionArray[row];
    }
    return _timeSlotArray[row];
}




- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  
    
    UILabel* tView = [[UILabel alloc] init];
    [tView setFont:[UIFont fontWithName:@"AvantGrade-Book" size:13]];
    [tView setTextAlignment:NSTextAlignmentCenter];
    if (pickerView.tag==1) {
        tView.text = _optionArray[row];
    }
    else
    {
        tView.text = _timeSlotArray[row];
    }
    return tView;
}



#pragma mark - CollectionView DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
    
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.gifCollection.bounds.size.width, 1);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.gifCollection.bounds.size.width, 1);
}

-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"identifier" forIndexPath:indexPath];
    
    if(!view)
        view = [[UICollectionReusableView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FFDarkroomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gifcell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blackColor];
    FFImageProcess * modal = self.imagesArray[indexPath.row];
    cell.imageView.image = modal.oldImage;
    cell.selctView.hidden = YES;
    return cell;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger cellWidth = (self.gifCollection.frame.size.width-25)/3;
    
    return CGSizeMake(cellWidth-3, cellWidth);
}




#pragma mark-
#pragma mark IBaction Method--


-(IBAction)calBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cameraButtonClicked:(id)sender
{
    for (UIViewController * controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[FFCameraViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            return;
        }
    }
}

-(IBAction)compileButtonClicked:(id)sender
{
    dataCompile = YES;
    if ([_selectedOtionString isEqualToString:@"COLLAGE"]) {
         //do collage
         
         [self saveCollageCompiledImage];
     }
     else{
         
         [self exportAnimatedGif:self.imagesArray withDelayTime:[_selectedTimeString floatValue]];
     }
    [self compilationProcessed];
}

-(IBAction)publishBtnClicked:(id)sender
{
    if (!dataCompile) {
        [[AlertView sharedManager] presentAlertWithTitle:@"No image was compiled" message:@"You have not compiled any image. Please edither create Collage or Gif." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
         {
             
         }];
        return;
    }
    FFCaptionViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FFCaptionViewController"];
    if ([_selectedOtionString isEqualToString:@"COLLAGE"])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"collage.png"];
        UIImage * imageToPublish=[UIImage imageWithData:[NSData dataWithContentsOfFile:getImagePath]];
        controller.imageToPublish = imageToPublish;
    }
    else
    {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
        controller.gifImagedatqa = [NSData dataWithContentsOfFile:path];
        UIImage * imageToPublish = [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
        
        controller.imageToPublish = imageToPublish;
    }
    controller.isFromCameraClick = _isFromCameraClick;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark-
#pragma mark Compile for GIF---

- (void)exportAnimatedGif:(NSArray *)imageArray withDelayTime:(float)delayTime
{
    
    @autoreleasepool {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"animated.gif"];
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)[NSURL fileURLWithPath:path],
                                                                            kUTTypeGIF,
                                                                            imageArray.count,
                                                                            NULL);
        
        NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:delayTime] forKey:(NSString *)kCGImagePropertyGIFDelayTime]
                                                                    forKey:(NSString *)kCGImagePropertyGIFDictionary];
        NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:5] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
                                                                  forKey:(NSString *)kCGImagePropertyGIFDictionary];
        
        for (FFImageProcess * modal in imageArray) {
            @autoreleasepool {
                CGImageDestinationAddImage(destination, modal.oldImage.CGImage, (CFDictionaryRef)frameProperties);
            }
            
            
        }
        
        CGImageDestinationSetProperties(destination, (CFDictionaryRef)gifProperties);
        CGImageDestinationFinalize(destination);
        CFRelease(destination);
        destination = nil;
        NSLog(@"animated GIF file created at %@", path);
        path = nil;
        frameProperties = nil;
    }
    imageArray = nil;
    
}

#pragma mark-
#pragma mark Compile for Collage---


-(void)compileForCollage
{
    NSInteger xVal = 0;
    for (FFImageProcess * modal in self.imagesArray) {
        UIImage * image = modal.oldImage;
        TempImageView * myImageView = [[TempImageView alloc] initWithFrame:CGRectMake(xVal, 15, 150, 150)];
        myImageView.image = image;
        myImageView.userInteractionEnabled = YES;
        [_collageView addSubview:myImageView];
        xVal = xVal+20;
        _collageView.clipsToBounds = YES;
        [self addPic:image at:myImageView.frame];
    }
}
-(float)scaleImage:(UIImage *)image
{
    float toSize = 0.25;
    if (image.size.width * toSize > _collageView.frame.size.width) {
        toSize = _collageView.frame.size.width;
    }
    if (image.size.height * toSize > _collageView.frame.size.height) {
        toSize = _collageView.frame.size.height;
    }
    return toSize;
}

// same image compiled image to docuemnt directory-
-(void)saveCollageCompiledImage
{
    UIGraphicsBeginImageContext(_collageView.bounds.size);
    
    [_collageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *  collgeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(collgeImage, nil, nil, nil);
    
    
    NSData *pngData = UIImagePNGRepresentation(collgeImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"collage.png"];
    [pngData writeToFile:getImagePath atomically:YES];
     NSLog(@"animated GIF file created at %@", getImagePath);
}

-(void)addPic:(UIImage*)newPic at:(CGRect)newLoc
{
    [_myPics addObject:[NSDictionary dictionaryWithObjectsAndKeys:newPic, @"picture", [NSNumber numberWithFloat:newLoc.origin.x], @"xpoint"  ,[NSNumber numberWithFloat:newLoc.origin.y], @"ypoint",[NSNumber numberWithFloat:newLoc.size.width], @"width"  ,[NSNumber numberWithFloat:newLoc.size.height], @"height"  ,nil]];
    [_collageView setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
    if (_myPics) {
        for (int i=0; i<_myPics.count; i++) {
            UIImage * thisImage =[[_myPics objectAtIndex:i] valueForKey:@"picture"];
            float xPoint =[[[_myPics objectAtIndex:i] valueForKey:@"xpoint"] floatValue];
            float yPoint =[[[_myPics objectAtIndex:i] valueForKey:@"ypoint"] floatValue];
            float width =[[[_myPics objectAtIndex:i] valueForKey:@"width"] floatValue];
            float height =[[[_myPics objectAtIndex:i] valueForKey:@"height"] floatValue];
            [thisImage drawInRect:CGRectMake(xPoint, yPoint, width, height)];
        }
    }
}


#pragma mark- Alert for compilation processed.-

-(void)compilationProcessed
{
    [[AlertView sharedManager] presentAlertWithTitle:@"Success!" message:@"Your images are successfully compiled." andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
     {
         
     }];
}
@end
