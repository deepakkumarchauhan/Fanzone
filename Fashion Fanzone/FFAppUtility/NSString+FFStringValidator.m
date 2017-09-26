//
//  NSString+FFStringValidator.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/24/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "NSString+FFStringValidator.h"

@implementation NSString (FFStringValidator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withExtraHeight:(CGFloat)ht{
    
    if (!self || !self.length)
        return 0;
    
    CGFloat labelSize;
    CGRect rect = [self boundingRectWithSize : (CGSize){width, CGFLOAT_MAX}
                                     options : NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes : @{ NSFontAttributeName: font }
                                     context : nil];
    labelSize = rect.size.height;
    
    return labelSize + ht;
}
/*
 method to remove white spaces
 */

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

// Checking if String is Empty
-(BOOL)isBlank {
    
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""]) ? YES : NO;
}

NSString * toAddPriceSymbol (NSString *str){
    NSString *attributedString = [NSString stringWithFormat:@"%@ %@",@"$",str];
    return attributedString;
}

//Checking if String is empty or nil
-(BOOL)isValid {
    
    return ([[self removeWhiteSpacesFromString] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

// remove white spaces from String
- (NSString *)removeWhiteSpacesFromString {
    
    NSString *trimmedString = [self stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

// Counts number of Words in String
- (NSUInteger)countNumberOfWords {
    
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSUInteger count = 0;
    while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil])
        count++;
    
    return count;
}

// If string contains substring
- (BOOL)containsString:(NSString *)subString {
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

// If my string starts with given string
- (BOOL)isBeginsWith:(NSString *)string {
    return ([self hasPrefix:string]) ? YES : NO;
}

// If my string ends with given string
- (BOOL)isEndssWith:(NSString *)string {
    return ([self hasSuffix:string]) ? YES : NO;
}


// Replace particular characters in my string with new character
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar {
    return  [self stringByReplacingOccurrencesOfString:olderChar withString:newerChar];
}

// Get Substring from particular location to given lenght
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end {
    
    NSRange r;
    r.location = begin;
    r.length = end - begin;
    return [self substringWithRange:r];
}

// Add substring to main String
- (NSString *)addString:(NSString *)string {
    
    if(!string || string.length == 0)
        return self;
    
    return [self stringByAppendingString:string];
}

// Remove particular sub string from main string
-(NSString *)removeSubString:(NSString *)subString {
    
    if ([self containsString:subString]) {
        NSRange range = [self rangeOfString:subString];
        return  [self stringByReplacingCharactersInRange:range withString:@""];
    }
    return self;
}

// If my string contains ony letters
- (BOOL)containsOnlyLetters {
    
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

// If my string contains only numbers
- (BOOL)containsOnlyNumbers {
    
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

// If my string contains letters and numbers
- (BOOL)containsOnlyNumbersAndLetters {
    
    NSCharacterSet *numAndLetterCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:numAndLetterCharSet].location == NSNotFound);
}

// If my string is available in particular array
- (BOOL)isInThisarray:(NSArray*)array {
    
    for(NSString *string in array) {
        if([self isEqualToString:string])
            return YES;
    }
    return NO;
}

// Get String from array
+ (NSString *)getStringFromArray:(NSArray *)array {
    return [array componentsJoinedByString:@" "];
}

// Convert Array from my String
- (NSArray *)getArray {
    return [self componentsSeparatedByString:@" "];
}

// Get My Application Version number
+ (NSString *)getMyApplicationVersion {
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleVersion"];
    return version;
}

// Get My Application name
+ (NSString *)getMyApplicationName {
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [info objectForKey:@"CFBundleDisplayName"];
    return name;
}

// Convert string to NSData
- (NSData *)convertToData {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

// Get String from NSData
+ (NSString *)getStringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

// Is Valid Email
- (BOOL)isValidEmail {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

- (BOOL)isValidName {
    
    NSString *regex = @"^[a-z A-Z_ 0-9 ]*$";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

// Is Valid Phone
- (BOOL)isVAlidPhoneNumber {
    
    NSString *regex = @"\\+?[0-9]{10,13}";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:self];
}
// is valid Password
- (BOOL)isValidPassword{
    if([self rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location == NSNotFound)
        return NO;
    
    if([self rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location == NSNotFound)
        return NO;
    
    return YES;
}

// Is Valid FirstName
- (BOOL) isValidFirstName{
    NSString *exprs =@"^[a-zA-Z]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exprs];
    return [test evaluateWithObject:self];
}

// Is Valid MobileNo
- (BOOL)isValidMobileNumber{
    
    NSString *exprs =@"^[0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", exprs];
    return [test evaluateWithObject:self];
}

// Is Valid URL
- (BOOL)isValidUrl {
    
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

+ (NSString*)ordinalNumberFormat:(NSNumber *)numObj {
    NSString *ending;
    NSInteger num = [numObj integerValue];
    
    int ones = num % 10;
    int tens = floor(num / 10);
    tens = tens % 10;
    
    if(tens == 1){
        ending = @"th";
    } else {
        switch (ones) {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }
    
    return [NSString stringWithFormat:@"%ld%@", (long)num, ending];
}

NSString * imageToNSString (UIImage *image ){
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return (imageStr.length) ? imageStr: @"";
}
@end
