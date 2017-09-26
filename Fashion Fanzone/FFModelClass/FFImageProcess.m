//
//  FFImageProcess.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 07/04/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFImageProcess.h"
#import <CoreImage/CoreImage.h>
#include <math.h>


/* These are our own constants */
#define SAFECOLOR(color) MIN(255,MAX(0,color))
typedef void (*FilterCallback)(UInt8 *pixelBuf, UInt32 offset, void *context);
typedef void (*FilterBlendCallback)(UInt8 *pixelBuf, UInt8 *pixelBlendBuf, UInt32 offset, void *context);

/* These constants are used by ImageMagick */
typedef unsigned char Quantum;
typedef double MagickRealType;

#define RoundToQuantum(quantum)  ClampToQuantum(quantum)
#define ScaleCharToQuantum(value)  ((Quantum) (value))
#define SigmaGaussian  ScaleCharToQuantum(4)
#define TauGaussian  ScaleCharToQuantum(20)
#define QuantumRange  ((Quantum) 65535)

/* These are our own constants */
#define SAFECOLOR(color) MIN(255,MAX(0,color))



@implementation FFImageProcess




+ (id)sharedInstance
{
    static FFImageProcess *  sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
- (CGFloat) clamp:(CGFloat)pixel
{
    if(pixel > 255) return 255;
    else if(pixel < 0) return 0;
    return pixel;
}

- (UIImage*) saturation:(CGFloat)s
{
    CGImageRef inImage = self.CGImage;
    CFDataRef ref = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * buf = (UInt8 *) CFDataGetBytePtr(ref);
    int length = (int)CFDataGetLength(ref);
    
    for(int i=0; i<length; i+=4)
    {
        int r = buf[i];
        int g = buf[i+1];
        int b = buf[i+2];
        
        CGFloat avg = (r + g + b) / 3.0;
        buf[i] = [self clamp:(r - avg) * s + avg];
        buf[i+1] = [self clamp:(g - avg) * s + avg];
        buf[i+2] = [self clamp:(b - avg) * s + avg];
    }
    
    CGContextRef ctx = CGBitmapContextCreate(buf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetAlphaInfo(inImage));
    
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CFRelease(ref);
    CGContextRelease(ctx);
    return [UIImage imageWithCGImage:img];
}
-(UIImage*) imageSaturation:(UIImage*)inputImage withSliderVal:(CGFloat)sliderVal {
   
    
    CGImageRef inImage = inputImage.CGImage;
    CIContext *contextLocal = [CIContext contextWithOptions:nil];
    CIImage *ciimage = [CIImage imageWithCGImage:inImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:ciimage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:kCIInputSaturationKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [contextLocal createCGImage:result fromRect:[result extent]];
    UIImage * image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
    
}
- (UIImage*) setContrast:(CGFloat)s WithImage:(UIImage *)image
{
   
    if (!filterContrast) {
        filterContrast = [self filetrForContrast];
        [self setContext];
    }
    [filterContrast setValue:@(s) forKey:@"inputContrast"];
    CIImage *result = [filterContrast valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage] ;//[[UIImage alloc] initWithCGImage:cgImage] ;      //
    CGImageRelease(cgImage);
    return filteredImage;
}

-(CIFilter*)filetrForContrast
{
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.oldImage];
    CIFilter *filterContrastLocal = [CIFilter filterWithName:@"CIColorControls"];
    [filterContrastLocal setValue:ciImage forKey:kCIInputImageKey];
    return filterContrastLocal;

}
- (UIImage*) setBrightNess:(CGFloat)s WithImage:(UIImage *)image
{
    if (!filterBrightNess) {
        filterBrightNess = [self filetrForBrightness];
        [self setContext];
    }
    
   [filterBrightNess setValue:[NSNumber numberWithFloat:s] forKey:@"inputBrightness"];
    CIImage *result = [filterBrightNess valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage] ;      //
    CGImageRelease(cgImage);
    return filteredImage;
}
-(CIFilter*)filetrForBrightness
{
    
    //  Convert UIImage to CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.oldImage];
    CIFilter *filterContrastLocal = [CIFilter filterWithName:@"CIColorControls"];
    [filterContrastLocal setValue:ciImage forKey:kCIInputImageKey];
    return filterContrastLocal;
    
}
-(void)setContext
{
    context = [CIContext contextWithOptions:nil];
}
- (UIImage*)brightness:(double)amount
{
    return [self applyFilter:filterBrightness context:&amount];
}

- (UIImage*)contrast:(double)amount
{
    return [self applyFilter:filterContrasts context:&amount];
}
- (UIImage*)noise:(double)amount
{
    return [self applyFilter:filterNoise context:&amount];
}
////*********

//
// Noise filter was adapted from ImageMagick
//
static inline Quantum ClampToQuantum(const MagickRealType value)
{
    if (value <= 0.0)
        return((Quantum) 0);
    if (value >= (MagickRealType) QuantumRange)
        return((Quantum) QuantumRange);
    return((Quantum) (value+0.5));
}

static inline double RandBetweenZeroAndOne()
{
    double value = arc4random() % 1000000;
    value = value / 1000000;
    return value;
}

static inline Quantum GenerateGaussianNoise(double alpha, const Quantum pixel)
{
    double beta = RandBetweenZeroAndOne();
    double sigma = sqrt(-2.0*log((double) alpha))*cos((double) (2.0*M_PI*beta));
    double tau = sqrt(-2.0*log((double) alpha))*sin((double) (2.0*M_PI*beta));
    double noise = (MagickRealType) pixel+sqrt((double) pixel)*SigmaGaussian*sigma+TauGaussian*tau;
    
    return ClampToQuantum(noise);
}

void filterNoise(UInt8 *pixelBuf, UInt32 offset, void *context)
{
    double alpha = 1.0 - *((double*)context);
    
    int r = offset;
    int g = offset+1;
    int b = offset+2;
    
    int red = pixelBuf[r];
    int green = pixelBuf[g];
    int blue = pixelBuf[b];
    
    pixelBuf[r] = GenerateGaussianNoise(alpha, red);
    pixelBuf[g] = GenerateGaussianNoise(alpha, green);
    pixelBuf[b] = GenerateGaussianNoise(alpha, blue);
}

//*************
void filterBrightness(UInt8 *pixelBuf, UInt32 offset, void *context)
{
    double t = *((double*)context);
    
    int r = offset;
    int g = offset+1;
    int b = offset+2;
    
    int red = pixelBuf[r];
    int green = pixelBuf[g];
    int blue = pixelBuf[b];
    
    pixelBuf[r] = SAFECOLOR(red*t);
    pixelBuf[g] = SAFECOLOR(green*t);
    pixelBuf[b] = SAFECOLOR(blue*t);
}
double calcContrast(double f, double c){
    return (f-0.5) * c + 0.5;
}
void filterContrasts(UInt8 *pixelBuf, UInt32 offset, void *context)
{
    double val = *((double*)context);
    int r = offset;
    int g = offset+1;
    int b = offset+2;
    
    int red = pixelBuf[r];
    int green = pixelBuf[g];
    int blue = pixelBuf[b];
    
    pixelBuf[r] = SAFECOLOR(255 * calcContrast((double)((double)red / 255.0f), val));
    pixelBuf[g] = SAFECOLOR(255 * calcContrast((double)((double)green / 255.0f), val));
    pixelBuf[b] = SAFECOLOR(255 * calcContrast((double)((double)blue / 255.0f), val));
}


- (UIImage*) applyFilter:(FilterCallback)filter context:(void*)contextL
{
    CGImageRef inImage = self.oldImage.CGImage;
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    size_t bits = CGImageGetBitsPerComponent(inImage);
    size_t bitsPerRow = CGImageGetBytesPerRow(inImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(inImage);
    int alphaInfo = CGImageGetAlphaInfo(inImage);
    
    if (alphaInfo != kCGImageAlphaPremultipliedLast &&
        alphaInfo != kCGImageAlphaNoneSkipLast) {
        if (alphaInfo == kCGImageAlphaNone ||
            alphaInfo == kCGImageAlphaNoneSkipFirst) {
            alphaInfo = kCGImageAlphaNoneSkipLast;
        }else {
            alphaInfo = kCGImageAlphaPremultipliedLast;
        }
        CGContextRef contextLocal = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     bits,
                                                     bitsPerRow,
                                                     colorSpace,
                                                     alphaInfo);
        CGContextDrawImage(contextLocal, CGRectMake(0, 0, width, height), inImage);
        inImage = CGBitmapContextCreateImage(contextLocal);
        CGContextRelease(contextLocal);
    }else {
        CGImageRetain(inImage);
    }
    
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    NSInteger length = CFDataGetLength(m_DataRef);
    CFMutableDataRef m_DataRefEdit = CFDataCreateMutableCopy(NULL,length,m_DataRef);
    CFRelease(m_DataRef);
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetMutableBytePtr(m_DataRefEdit);
    
    for (int i=0; i<length; i+=4)
    {
        filter(m_PixelBuf,i,contextL);
    }
    CGImageRelease(inImage);
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             width,
                                             height,
                                             bits,
                                             bitsPerRow,
                                             colorSpace,
                                             alphaInfo
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef
                                              scale:self.oldImage.scale
                                        orientation:self.oldImage.imageOrientation];//  self.imageOrientation
    CGImageRelease(imageRef);
    CFRelease(m_DataRefEdit);
    return finalImage;
    
}


#pragma mark- 
#pragma mark Apply Heu-

- (UIImage*)applyHeuEffect:(UIImage*)image withSliderValue:(CGFloat)value
{
   
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:value] forKey:@"inputAngle"];
   CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage
                                              scale:image.scale
                                        orientation:image.imageOrientation];
    
    
    CGImageRelease(cgImage);
    
    return finalImage;
}
#pragma mark-
#pragma mark Apply Posterize -

- (UIImage*)applyPosterEffect:(UIImage*)image withSliderValue:(CGFloat)value
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:- value] forKey:@"inputLevels"];
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}


- (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName withSliderValue:(CGFloat)sliderVal
{
    if([filterName isEqualToString:@"CLDefaultEmptyFilter"]){
        return image;
    }
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage,  nil];
    [filter setDefaults];
    if([filterName isEqualToString:@"CIVignetteEffect"]){//
        CGFloat R = MIN(image.size.width, image.size.height)*image.scale/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width*image.scale/2 Y:image.size.height*image.scale/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage
                                              scale:image.scale
                                        orientation:image.imageOrientation];
    CGImageRelease(cgImage);
    
    return finalImage;
}



-(UIImage*)porcessImage:(UIImage*)inputImage forIndexValue:(NSInteger)index withSliderValue:(CGFloat)sliderVal
{
    UIImage * output_Image;
    switch (index) {
        case 0:
        {
           output_Image = [self filteredImage:inputImage withFilterName:@"CISRGBToneCurveToLinear" withSliderValue:sliderVal];
        }
            break;
        case 1:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIVignetteEffect" withSliderValue:sliderVal];
        }
            break;
        case 2:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectInstant" withSliderValue:sliderVal];
        }
            break;
        case 3:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectTransfer" withSliderValue:sliderVal];
        }
            break;
        case 4:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectProcess" withSliderValue:sliderVal];
        }
            break;
            
        case 5:
        {
            self.oldImage = inputImage;
            output_Image = [self noise:sliderVal];
            //output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectNoir" withSliderValue:sliderVal];
        }
            break;
        case 6:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIColorInvert" withSliderValue:sliderVal];
        }
            break;
        case 7:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectMono" withSliderValue:sliderVal];
        }
            break;
        case 8:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectTonal" withSliderValue:sliderVal];
        }
            break;
        case 9:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectChrome" withSliderValue:sliderVal];
        }
            break;
        case 10:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CISepiaTone" withSliderValue:sliderVal];
        }
            break;
        case 11:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CIPhotoEffectFade" withSliderValue:sliderVal];
        }
            break;
        case 12:
        {
            output_Image = [self filteredImage:inputImage withFilterName:@"CILinearToSRGBToneCurve" withSliderValue:sliderVal];
        }
            break;
        case 13:
        {
            output_Image = [self applyHeuEffect:inputImage withSliderValue:sliderVal];
        }
            break;
            
        default:
            break;
    }
    return output_Image;
}



// Heu effects



- (UIImage*)applyHueEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:@"inputAngle"];
    
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage
                                              scale:self.oldImage.scale
                                        orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return finalImage;
}


// Pixellate-

- (UIImage*)applyPixellateEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
     self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * 0.1 * sliderVal;
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width/2 Y:image.size.height/2];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputScale"];
    
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
   // CGRect clippingRect = [self clippingRectForTransparentSpace:cgImage];
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage
                                              scale:self.oldImage.scale
                                        orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    return finalImage;
   // return [self crop:clippingRect];
}
#pragma mark- Clipping

- (UIImage*)crop:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark-

- (CGRect)clippingRectForTransparentSpace:(CGImageRef)inImage
{
    CGFloat left=0, right=0, top=0, bottom=0;
    
    CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
    UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
    
    int width  = (int)CGImageGetWidth(inImage);
    int height = (int)CGImageGetHeight(inImage);
    
    BOOL breakOut = NO;
    for (int x = 0;breakOut==NO && x < width; ++x) {
        for (int y = 0; y < height; ++y) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                left = x;
                breakOut = YES;
                break;
            }
        }
    }
    
    breakOut = NO;
    for (int y = 0;breakOut==NO && y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                top = y;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int y = height-1;breakOut==NO && y >= 0; --y) {
        for (int x = width-1; x >= 0; --x) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                bottom = y;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    breakOut = NO;
    for (int x = width-1;breakOut==NO && x >= 0; --x) {
        for (int y = height-1; y >= 0; --y) {
            int loc = x + (y * width);
            loc *= 4;
            if (m_PixelBuf[loc + 3] != 0) {
                right = x;
                breakOut = YES;
                break;
            }
            
        }
    }
    
    CFRelease(m_DataRef);
    
    return CGRectMake(left, top, right-left, bottom-top);
}


// spot --


- (UIImage*)applySpotEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CGFloat R = MIN(image.size.width, image.size.height) * image.scale * 0.5 * (0.5 + 0.1);
    CIVector *vct = [[CIVector alloc] initWithX:image.size.width * image.scale * 0.5 Y:image.size.height * image.scale * (1 - 0.5)];
    [filter setValue:vct forKey:@"inputCenter"];
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage
                                          scale:self.oldImage.scale
                                    orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return result;
}



// Shadow Effect -

- (UIImage*)applyShadowEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
   
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:@"inputShadowAmount"];
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage
                                          scale:self.oldImage.scale
                                    orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return result;
}


// Bloom Effect--


- (UIImage*)applyBloomEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = sliderVal * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:@"inputIntensity"];
    
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage
                                          scale:self.oldImage.scale
                                    orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    CGFloat dW = (result.size.width - image.size.width)/2;
    CGFloat dH = (result.size.height - image.size.height)/2;
    
    CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    return result;
    return [self crop:rct];
}

// Gloom--

- (UIImage*)applyGloomEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIGloom" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    
    CGFloat R = sliderVal * MIN(image.size.width, image.size.height) * 0.05;
    [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:@"inputIntensity"];
    
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage
                                          scale:self.oldImage.scale
                                    orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
//    CGFloat dW = (result.size.width - image.size.width)/2;
//    CGFloat dH = (result.size.height - image.size.height)/2;
    
  //  CGRect rct = CGRectMake(dW, dH, image.size.width, image.size.height);
    return result;
    //return [result crop:rct];
}


//Poster Effects-


- (UIImage*)applyposterEffect:(UIImage*)image withSliderVal:(CGFloat)sliderVal
{
    self.oldImage = image;
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorPosterize" keysAndValues:kCIInputImageKey, ciImage, nil];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:sliderVal] forKey:@"inputLevels"];
    CIContext *contextLocal = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [contextLocal createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *result = [UIImage imageWithCGImage:cgImage
                                          scale:self.oldImage.scale
                                    orientation:self.oldImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return result;
}

-(UIImage *)processImageForEffectsWithImage:(UIImage*)inputImage andSliderVal:(CGFloat)sliderVal andIndex:(NSInteger)indexVal
{
    UIImage * outPutImage = nil;
    switch (indexVal) {
        case 0:
        {
           outPutImage = [self applyHueEffect:inputImage withSliderVal:sliderVal];
        }
            break;
        case 1:
        {
           outPutImage = [self applyposterEffect:inputImage withSliderVal:sliderVal * 10];
        }
            break;
        case 2:
        {
           outPutImage = [self applyGloomEffect:inputImage withSliderVal:sliderVal];
        }
            break;
        case 3:
        {
           outPutImage = [self applyShadowEffect:inputImage withSliderVal:sliderVal];
        }
            break;
        case 4:
        {
           outPutImage = [self applySpotEffect:inputImage withSliderVal:sliderVal];
        }
            break;
        case 5:
        {
           outPutImage = [self applyBloomEffect:inputImage withSliderVal:sliderVal];
        }
            break;
        case 6:
        {
           outPutImage = [self applyPixellateEffect:inputImage withSliderVal:sliderVal];
        }
            break;
            
        default:
            break;
    }
    return outPutImage;
}

@end
