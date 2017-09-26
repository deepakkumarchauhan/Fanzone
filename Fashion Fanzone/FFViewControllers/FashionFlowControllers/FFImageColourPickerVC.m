//
//  FFImageColourPickerVC.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 10/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFImageColourPickerVC.h"

#define BUTTON_TAG_INDEX 100


@interface FFImageColourPickerVC ()<EfectsScrollprotocol>
{
    CGFloat brusgSize;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat opecity;
    CGFloat alphaVal;
    CGPoint lastPoint;
    NSInteger filterIndex;
    NSArray * filterArray;
    ZDStickerView *userResizableView1;
    FFVerticalSlider * verticalFilterSlider;
    FFEffectsScrollView * effectScrollView;
    NSString * optionString;
    
}

@property (nonatomic, weak) IBOutlet UIView *  headerView;
@property (nonatomic, weak) IBOutlet UIView *  colourIndicator;
@property (nonatomic, weak) IBOutlet UIView *  brushSizeIndecator;
@property (nonatomic, weak) IBOutlet UIView *  buttonHolderView;
@property (nonatomic, weak) IBOutlet UIView *  upDownHolderView;
@property (nonatomic, weak) IBOutlet UIView *  colourPickerView;
@property (nonatomic, weak) IBOutlet UIView *  emojiView;
@property (nonatomic, weak) IBOutlet UILabel *  colourLbel;
@property (nonatomic, weak) IBOutlet UILabel *  upDownLabel;
@property (nonatomic, weak) IBOutlet UIButton *  sketchButton;
@property (nonatomic, weak) IBOutlet UIButton *  filetButton;
@property (nonatomic, weak) IBOutlet UIButton *  touchButton;
@property (nonatomic, weak) IBOutlet UIButton *  iconButton;
@property (nonatomic, weak) IBOutlet UIButton *  upButton;
@property (nonatomic, weak) IBOutlet UIButton *  downButton;
@property (nonatomic, weak) IBOutlet UIButton *  publishButton;
@property (nonatomic, weak) IBOutlet UIButton *  resetButton;
@property (nonatomic, weak) IBOutlet UIButton *  ADJUSTButton;
@property (nonatomic, weak) IBOutlet UIButton *  sendButton;
@property (nonatomic, weak) IBOutlet UIImageView *  nextIcon;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UIImageView *  colourPickerimageview;
@property (nonatomic, weak) IBOutlet UIImageView *  objectImageView;
@property (nonatomic, weak) IBOutlet UIImageView *  forwrdimageView;
@property (nonatomic, weak) IBOutlet UIImageView *  colourSlider;
@property (nonatomic, weak) IBOutlet UIScrollView *  scrollview;
@property (strong, nonatomic) IBOutlet UIButton *hideShowBtn;
@property (nonatomic, strong) UIColor *  selectedColour;
@property (nonatomic, strong) UIImage *  imageOriginal;
@property (nonatomic, strong) UIScrollView *  filterScrollView;
@property (nonatomic, strong) UIScrollView *  menuSlider;

@end

@implementation FFImageColourPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    brusgSize = 10;  // give initiall RGB Values
    red = 255;
    green = 255;
    blue = 255;
    opecity = 1;
    alphaVal = 1;
    optionString = @"";  //option string to selct options
     _objectImageView.image  = _imageObject;
    _imageOriginal = _imageObject;
  
    //****** Make colour indecator view in round colour
    [self roundColourIndicatorview];
    [self displayEmojis];
    [self hideAllControlsControles];
    [self manageFilterChooseView];
    [self manageVerticalSlider];
    [self managEMenuSlider];
    [self manageEffectsOverImages];
    self.filterScrollView.frame = CGRectMake(0, MainScreenHeight, [UIScreen mainScreen].bounds.size.width, 100);
    effectScrollView.frame = CGRectMake(0, MainScreenHeight, [UIScreen mainScreen].bounds.size.width, 60);
    verticalFilterSlider.frame = CGRectMake(-100, 100, 22, MainScreenHeight * 0.6);
    _buttonHolderView.hidden = YES;
    if (_isMessaging) {
        _sendButton.hidden = NO;
        _nextIcon.hidden = NO;
        _publishButton.hidden = YES;
        [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        _sendButton.hidden = YES;
        _nextIcon.hidden = YES;
        _publishButton.hidden = NO;
    }
    
    
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


#pragma mark-
#pragma mark IBAction Methods-

-(IBAction)adjustButtonClicked:(id)sender
{
    [self hideAllControlsControles];
    FFImageViewController * controller = (FFImageViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFImageViewController"];
    controller.isFromCameraClick = self.isFromCameraClick;
    controller.image = _objectImageView.image;
    if(_isMessaging)
    {
        controller.isMessaging = YES;
        controller.modalPost = _modalPost;
    }
        
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)callBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)upWardButtonClicked:(id)sender
{
    
    // manage frame for brush size indecator....
    CGRect frame = _brushSizeIndecator.frame;
    CGPoint center = _brushSizeIndecator.center;
    frame.size.height = frame.size.height+2;
    frame.size.width = frame.size.width+4;
    frame.origin = CGPointMake(MainScreenWidth, (frame.origin.y+frame.size.height/2));
    _brushSizeIndecator.frame = frame;
    _brushSizeIndecator.center =center;
    _brushSizeIndecator.layer.borderColor = [UIColor whiteColor].CGColor;
    _brushSizeIndecator.layer.borderWidth = 1.0f;
    _brushSizeIndecator.layer.cornerRadius = _brushSizeIndecator.frame.size.height/2;
    _downButton.enabled = YES;
    brusgSize = brusgSize+1.5;
    if (frame.size.width>=80) {
        _upButton.enabled = NO;
    }
}
-(IBAction)downWardButtonClicked:(id)sender
{
     // manage frame for brush size indecator....
    
    CGRect frame = _brushSizeIndecator.frame;
    CGPoint center = _brushSizeIndecator.center;
    frame.size.height = frame.size.height-2;
    frame.size.width = frame.size.width-4;
    _brushSizeIndecator.frame = frame;
    _brushSizeIndecator.center =center;
    _brushSizeIndecator.layer.borderColor = [UIColor whiteColor].CGColor;
    _brushSizeIndecator.layer.borderWidth = 1.0f;
    _brushSizeIndecator.layer.cornerRadius = _brushSizeIndecator.frame.size.height/2;
    _upButton.enabled = YES;
    brusgSize = brusgSize-2;
      if (frame.size.width<=26) {
        _downButton.enabled = NO;
    }
}
-(IBAction)sketchButtonClicked:(id)sender
{
    optionString = KSketch;
    [self hideAllControlsControles];
    [self showSketchView];
}
-(IBAction)filterButtonClicked:(id)sender
{
    optionString = KFilter;
    [self hideAllControlsControles];
    self.filterScrollView.hidden = NO;
    [self showFilters];
    _imageObject =_objectImageView.image  ;
    
    
}
-(IBAction)touchButtonClicked:(id)sender
{
    optionString = KTouch;
    [self hideAllControlsControles];
    [[AlertView sharedManager] presentAlertWithTitle:@"This feature coming soon." message:nil andButtonsWithTitle:[NSArray arrayWithObject:@"OK"] onController:self dismissedWith:^(NSInteger index, NSString * title)
     {
         
     }];
}
-(IBAction)iconButtonClicked:(id)sender
{
    optionString = KIcon;
    [self hideAllControlsControles];
    _emojiView.hidden = NO;
}
-(void)sendButtonClicked:(id)sender
{
    [self showLoader];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSData * data = UIImagePNGRepresentation(_objectImageView.image);
        NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            [self callApiForMessaging:base64];
        });
    });
}
-(IBAction)publishButtonClicked:(id)sender
{

    if (_isMessaging) {
        [self showLoader];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
            NSData * data = UIImagePNGRepresentation(_objectImageView.image);
            NSString *base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self callApiForMessaging:base64];
            });
        });
        
       
        
    }
    else
    {
        UIImage * imgeToPublish = _objectImageView.image;
        FFCaptionViewController * colorpickerController = (FFCaptionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"FFCaptionViewController"];
        colorpickerController.imageToPublish = imgeToPublish;
        colorpickerController.isFromCameraClick = self.isFromCameraClick;
        [self.navigationController pushViewController:colorpickerController animated:YES];
        UIImage *img = [self imageWithView:_objectImageView];
        NSLog(@"%@", img);
    }
    
    
}

- (UIImage *) imageWithView:(UIImageView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;

}

-(IBAction)hideButtonClicked:(id)sender
{
    [self hideShowControls];
}
-(IBAction)resetButtonClicked:(id)sender
{
    for (ZDStickerView *img in _objectImageView.subviews) {
        [img removeFromSuperview];
    }
    [userResizableView1 removeFromSuperview];
      _objectImageView.image  = _imageOriginal;
    for (UIView * subview in self.view.subviews) {
        if ([subview isKindOfClass:[ZDStickerView class]]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark-
#pragma mark HideShow Controls-

-(void)hideShowControls
{
    
    if (_headerView.frame.origin.y==0) {
        [self hideFilters];
        [self hideEffectsFilters];
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _headerView.frame;
            frame.origin.y = -100;
            _headerView.frame = frame;
            
            frame = _menuSlider.frame;
            frame.origin.y = MainScreenHeight+50;
            _menuSlider.frame = frame;
            
            frame = _publishButton.frame;
            frame.origin.y = MainScreenHeight+50;
            _publishButton.frame = frame;
            
            frame = _colourLbel.frame;
            frame.origin.x = -200;
            _colourLbel.frame = frame;
            
            frame = _colourPickerView.frame;
            frame.origin.x = -200;
            _colourPickerView.frame = frame;//
            
            frame = _colourIndicator.frame;
            frame.origin.x = -200;
            _colourIndicator.frame = frame;
            
            frame = _brushSizeIndecator.frame;//
            frame.origin.x = MainScreenWidth+20;
            _brushSizeIndecator.frame = frame;
            
            frame = _upDownHolderView.frame;
            frame.origin.x = MainScreenWidth+20;
            _upDownHolderView.frame = frame;//
            
            frame = _upDownLabel.frame;
            frame.origin.x = MainScreenWidth+20;
            _upDownLabel.frame = frame;
            
            frame = _resetButton.frame;
            frame.origin.x = MainScreenWidth+20;
            _resetButton.frame = frame;
            
            verticalFilterSlider.frame = CGRectMake(-100, 100, 22, MainScreenHeight * 0.55);
        }];
    }
    else
    {
       
        if ([optionString isEqualToString:KFilter]) {
            [self showFilters];
        }
        if ([optionString isEqualToString:KEffects]) {
            [self showEffectsFilters];
        }
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = _headerView.frame;
            frame.origin.y = 0;
            _headerView.frame = frame;
            
            frame = _menuSlider.frame;
            frame.origin.y = MainScreenHeight-58;
            _menuSlider.frame = frame;
            
            frame = _publishButton.frame;
            frame.origin.y = MainScreenHeight-54;
            _publishButton.frame = frame;
            
            frame = _colourLbel.frame;
            frame.origin.x = 1;
            _colourLbel.frame = frame;
            
            frame = _colourPickerView.frame;
            frame.origin.x = 1;
            _colourPickerView.frame = frame;//
            
            frame = _colourIndicator.frame;
            frame.origin.x = -23;
            _colourIndicator.frame = frame;
            
            frame = _brushSizeIndecator.frame;//
            frame.origin.x = MainScreenWidth-26;
            _brushSizeIndecator.frame = frame;
            
            frame = _upDownHolderView.frame;
            frame.origin.x = MainScreenWidth-23;
            _upDownHolderView.frame = frame;//
            
            frame = _upDownLabel.frame;
            frame.origin.x = MainScreenWidth-65;
            _upDownLabel.frame = frame;
            
            frame = _resetButton.frame;
            frame.origin.x = MainScreenWidth-64;
            _resetButton.frame = frame;
            
            verticalFilterSlider.frame = CGRectMake(20, 100, 22, MainScreenHeight * 0.55);
        }];
    }
    
    
}

#pragma mark- Make Colour indecator view round

-(void)roundColourIndicatorview
{
    _colourIndicator.layer.borderColor = [UIColor whiteColor].CGColor;
    _colourIndicator.layer.borderWidth = 1.0f;
    _colourIndicator.layer.cornerRadius = _colourIndicator.frame.size.height/2;
    
    _brushSizeIndecator.layer.borderColor = [UIColor whiteColor].CGColor;
    _brushSizeIndecator.layer.borderWidth = 1.0f;
    _brushSizeIndecator.layer.cornerRadius = _brushSizeIndecator.frame.size.height/2;
}



#pragma mark-
#pragma mark Touch dlegate methods--


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([optionString isEqualToString:@""]) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_colourPickerView];
    if (CGRectContainsPoint(_colourPickerimageview.frame, touchPoint)) {
        
     
       [self moveIndecatorForTouchPoint:touchPoint];
        
    }
    lastPoint = [touch locationInView:self.view];
   
    if (CGRectContainsPoint(_colourPickerView.frame, touchPoint)) {
        
    }
    [self roundColourIndicatorview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([optionString isEqualToString:@""]) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_colourPickerView];
    
    if ([optionString isEqualToString:KSketch]) {//optionString = KIcon
        if (CGRectContainsPoint(_colourPickerimageview.frame, touchPoint)) {
            [self moveIndecatorForTouchPoint:touchPoint];
        }
        else
        {
            _objectImageView.image = [self imageByDrawingCircleOnImage:_objectImageView.image atPointTouch:touch];
            _imageObject = _objectImageView.image;
        }
    }
    [self roundColourIndicatorview];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_colourPickerView];
    
    if ([optionString isEqualToString:KSketch]) {//optionString = KIcon
        if (CGRectContainsPoint(_colourPickerimageview.frame, touchPoint)) {
            
            [self moveIndecatorForTouchPoint:touchPoint];
        }
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"output.png"];
        NSData *imageData = UIImagePNGRepresentation(_objectImageView.image);
        [imageData writeToFile:filePath atomically:YES];

    }
    [self roundColourIndicatorview];
}


-(void)moveIndecatorForTouchPoint:(CGPoint )point
{
    CGPoint center = _colourSlider.center;
    center.y = point.y;
    _colourSlider.center = center;
    [self getPixelColorAtLocation:point];
}


//********* get RGB Values for colour selcted *******
-(void) getPixelColorAtLocation:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.colourPickerimageview.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    _selectedColour = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    _colourIndicator.backgroundColor = _selectedColour;
    NSLog(@"RGB Color code %d  %d  %d",pixel[0],pixel[1],pixel[2]);
    red = pixel[0]/255.0;
    green = pixel[1]/255.0;
    blue = pixel[2]/255.0;
    alphaVal = pixel[3]/255.0;
}




#pragma mark-
#pragma mark  Draw sketch *****


- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image atPointTouch:(UITouch *)touch
{
    
    CGPoint currentPoint = [touch locationInView:self.view];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brusgSize );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alphaVal);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    [_objectImageView setAlpha:opecity];
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
    
    return newImage;
}



#pragma amrk Initial Hide all controls----


-(void)showSketchView
{
    _colourIndicator.hidden = NO;
    _colourPickerView.hidden = NO;
    _colourLbel.hidden = NO;
    _brushSizeIndecator.hidden = NO;
    _upDownLabel.hidden = NO;
    _upDownHolderView.hidden = NO;
}

-(void)hideAllControlsControles
{
    _colourIndicator.hidden = YES;
    _colourPickerView.hidden = YES;
    _colourLbel.hidden = YES;
    _brushSizeIndecator.hidden = YES;
    _upDownLabel.hidden = YES;
     _upDownHolderView.hidden = YES;
    _emojiView.hidden = YES;
    self.filterScrollView.hidden = YES;
    verticalFilterSlider.hidden = YES;
    effectScrollView.hidden = YES;
}


#pragma mark-
#pragma mark Display Emojis---


-(void)displayEmojis
{
    if(!self->_emojiPopover)
    {
        self->_emojiPopover = [[SYEmojiPopover alloc] init];
        [self->_emojiPopover setDelegate:self];
        CGRect farme = CGRectMake(0, 35, MainScreenWidth, _emojiView.frame.size.height-5);
        [self->_emojiPopover showFromFame:farme inView:nil];
        [_emojiView addSubview:self->_emojiPopover.view];
        
        
    }
    
    
}
-(void)emojiPopover:(NSString*)emojiPopover didClickedOnCharacter:(NSString*)character
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2, _emojiView.frame.origin.y+_emojiView.frame.size.height, 35, 35)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = character;
    label.userInteractionEnabled = YES;
    [label setFont:[UIFont fontWithName:@"AppleColorEmoji" size:32]];
   
    userResizableView1 = [[ZDStickerView alloc] initWithFrame:CGRectMake(MainScreenWidth/2, _emojiView.frame.origin.y+_emojiView.frame.size.height, 100, 100   )];
    userResizableView1.tag = 0;
    userResizableView1.stickerViewDelegate = self;
    userResizableView1.contentView = label;;
    userResizableView1.preventsPositionOutsideSuperview = NO;
    userResizableView1.translucencySticker = NO;
    userResizableView1.preventsCustomButton = NO;
    [userResizableView1 showEditingHandles];
    [self.view addSubview:userResizableView1];
    
 
}
- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {  // not in use for now
    
    UILabel * touchedLabel = (UILabel *)recognizer.view;
    CGPoint translation = [recognizer translationInView:touchedLabel];
    touchedLabel.center = CGPointMake(touchedLabel.center.x + translation.x, touchedLabel.center.y + translation.y);
   [recognizer setTranslation:CGPointZero inView:touchedLabel];
    
}

//******** draw emoji over the image ********

-(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    
    UIFont *font = [UIFont fontWithName:@"AppleColorEmoji" size:30];

    UIGraphicsBeginImageContext(image.size);
    
    
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, 35, 35);
    [[UIColor whiteColor] set];
    
    NSDictionary *attributes = @{ NSFontAttributeName: font};
    [text drawInRect:rect withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark
#pragma mark Sticker Delegate Methods---



- (void)stickerViewDidLongPressed:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidClose:(ZDStickerView *)sticker
{
    NSLog(@"%s [%zd]",__func__, sticker.tag);
}

- (void)stickerViewDidCustomButtonTap:(ZDStickerView *)sticker
{

    
    [sticker hideEditingHandles];
    [_objectImageView addSubview:sticker];
    UIImage *img = [self imageWithView:_objectImageView];
    _objectImageView.image = img;
    
}

#pragma mark-
#pragma mark Manage filter choose view-

-(void)hideFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterScrollView.frame = CGRectMake(0, MainScreenHeight, [UIScreen mainScreen].bounds.size.width, 100);
       
    }];
}
-(void)showFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        self.filterScrollView.frame = CGRectMake(0, MainScreenHeight-140, [UIScreen mainScreen].bounds.size.width, 100);
        
    }];
}
-(void)hideEffectsFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        effectScrollView.frame = CGRectMake(0, MainScreenHeight, [UIScreen mainScreen].bounds.size.width, 60);
        
    }];
}
-(void)showEffectsFilters
{
    [UIView animateWithDuration:0.3 animations:^{
        effectScrollView.frame = CGRectMake(0, MainScreenHeight-140, [UIScreen mainScreen].bounds.size.width, 60);
        //verticalFilterSlider.frame = CGRectMake(20, 100, 22, MainScreenHeight * 0.55);
    }];
}
-(void)manageFilterChooseView
{
    self.filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MainScreenHeight-140, [UIScreen mainScreen].bounds.size.width, 100)];
    self.filterScrollView.showsHorizontalScrollIndicator = NO;
    int xVal = 10;
    int width = 90;
    int height = 60;
    filterArray = [NSArray arrayWithObjects:@"New York",@"London",@"Paris",@"Tokyo",@"Miami",@"Miami",@"Los Angeles",@"Beijing",@"New Delhi",@"Berlin", @"Rio",@"Moscow", @"Stockholm", @"Mexico City",nil];
    for (int i=0; i<filterArray.count; i++) {
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(xVal, 5, width, height)];
        label.tag = i;
        label.backgroundColor = [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0f blue:255.0/255.0f alpha:1] colorWithAlphaComponent:1.0];
        NSString * stringText = [filterArray[i] uppercaseString];
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:stringText];
        [mat addAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:NSMakeRange (0, stringText.length)];
        [mat addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mat.length)];
        label.attributedText = mat;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.opacity = 0.5f;
        label.font = AppFontBOLD(15);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterClicked:)];
        label.userInteractionEnabled = YES;
        label.adjustsFontSizeToFitWidth = YES;
        [label addGestureRecognizer:tap];
        
        [self.filterScrollView addSubview:label];
        xVal = xVal+width+10;
        
    }
    self.filterScrollView.contentSize = CGSizeMake(xVal, 100);
    [self.view addSubview:self.filterScrollView];
}
-(void)filterClicked:(UITapGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)gesture.view;
    
    for (UIView *view in self.filterScrollView.subviews) {
       if([view isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel*)view;
            lbl.textColor = [UIColor blackColor];
        }
    }
    label.textColor = [[UIColor colorWithRed:65.0/255.0 green:204.0/255.0f blue:254.0/255.0f alpha:1] colorWithAlphaComponent:0.5];
   label.font = AppFontBOLD(16);
    filterIndex = label.tag;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         UIImage * imge = [[FFImageProcess sharedInstance] porcessImage:_imageObject forIndexValue:label.tag withSliderValue:0.9];
          [_objectImageView performSelectorOnMainThread:@selector(setImage:) withObject:imge waitUntilDone:NO];
    });
    
}


// manage vertical slider


-(void)manageVerticalSlider
{
    verticalFilterSlider = [[FFVerticalSlider alloc] initWithFrame:CGRectMake(20, 100, 22, MainScreenHeight * 0.55)];
    verticalFilterSlider.sliderDelegate = self;
    [self.view addSubview:verticalFilterSlider];
}
-(void)getSliderValueWith:(float)sliderValue// get filter value
{
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * imge = [[FFImageProcess sharedInstance] processImageForEffectsWithImage:_imageObject andSliderVal:sliderValue andIndex: filterIndex];
        [_objectImageView performSelectorOnMainThread:@selector(setImage:) withObject:imge waitUntilDone:NO];
    });
}

#pragma mark Manage Menu Slider-

-(void)managEMenuSlider
{
    
    
    self.menuSlider = [[UIScrollView alloc] initWithFrame:CGRectMake(5, MainScreenHeight-60 , [UIScreen mainScreen].bounds.size.width-90, 40)];
    self.menuSlider.showsHorizontalScrollIndicator = NO;
    int xVal = 5;
    int width = 66;
    int height = 30;
    NSArray * optionArray = [NSArray arrayWithObjects:@"SKETCH",@"FILTERS",@"ICON",@"ADJUST",@"EFFECTS",nil];
    for (int i=0; i<optionArray.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xVal, 5, width, height);
        button.tag = BUTTON_TAG_INDEX+ i;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:optionArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = AppFontBOLD(13);
        [self.menuSlider addSubview:button];
        xVal = xVal+width+5;
        
    }
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , xVal, 40)];
    view.backgroundColor = [UIColor blackColor];
    view.layer.opacity = 0.45f;
    [self.menuSlider addSubview:view];
    [self.menuSlider sendSubviewToBack:view];
    self.menuSlider.contentSize = CGSizeMake(xVal, 10);
    [self.view addSubview:self.menuSlider];
}
-(void)menuButtonClicked:(UIButton*)button
{
    [self makeAllButotnsBaby:button];
    NSInteger tag = button.tag;
    tag = tag - BUTTON_TAG_INDEX;
    switch (tag) {
        case 0:
            
        {
            [self sketchButtonClicked:nil];
        }
            break;
        case 1:
            
        {
            [self filterButtonClicked:nil];
        }
            break;
        case 2:
            
        {
            [self iconButtonClicked:nil];
        }
            break;
        case 3:
            
        {
            [self adjustButtonClicked:nil];
        }
            break;
        case 4:
            
        {
             [self hideAllControlsControles];
            verticalFilterSlider.frame = CGRectMake(20, 100, 22, MainScreenHeight * 0.55);
            verticalFilterSlider.hidden = NO;
            effectScrollView.hidden = NO;
            optionString = KEffects;
            [self showEffectsFilters];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)makeAllButotnsBaby:(UIButton *)jumboButton
{
    for (UIButton * button in self.menuSlider.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.titleLabel.font = AppFontBOLD(13);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [jumboButton setTitleColor:[UIColor colorWithRed:85.0/255.0f green:215.0/255.0f blue:255.0/255.0f alpha:1] forState:UIControlStateNormal];
    [jumboButton.titleLabel setFont:AppFontBOLD(15)];
    
}


#pragma mark-
#pragma manage Effects Over Images-


-(void)manageEffectsOverImages //effectScrollView
{
    effectScrollView = [[FFEffectsScrollView alloc] initWithFrame:CGRectMake(5, MainScreenHeight-60 , [UIScreen mainScreen].bounds.size.width-90, 60)];
    effectScrollView.showsHorizontalScrollIndicator = NO;
    effectScrollView.delegateMethods = self;
     [self.view addSubview:effectScrollView];
}
-(void)imageEffectsIndexGet:(NSInteger)index
{
    filterIndex = index;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * imge = [[FFImageProcess sharedInstance] processImageForEffectsWithImage:_imageObject andSliderVal:0.9 andIndex: filterIndex];
        [_objectImageView performSelectorOnMainThread:@selector(setImage:) withObject:imge waitUntilDone:NO];
    });
}


#pragma mark - Call Api for messaging

-(void)callApiForMessaging:(NSString*)imageBase64
{
    
    NSMutableDictionary *dictRequest = [[NSMutableDictionary alloc] init];
    [dictRequest setValue:apiAddChat forKey:KAction];
    [dictRequest setValue:[NSUSERDEFAULT valueForKey:KUserId] forKey:KUserId];//
    [dictRequest setValue:_modalPost.messageReceipent forKey:KReceiverID]; //message
    [dictRequest setValue:@"" forKey:KMessages];
    [dictRequest setValue:imageBase64 forKey:KMessagesImage];
    [dictRequest setValue:_modalPost.postTitle forKey:KTitle];
    
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

@end
