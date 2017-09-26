//
//  NSString+FFStringValidator.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/24/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "Macro.h"

@interface NSString (FFStringValidator)

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withExtraHeight:(CGFloat)ht;

- (BOOL)isBlank;
- (BOOL)isValid;
- (NSString *)removeWhiteSpacesFromString;


- (NSUInteger)countNumberOfWords;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;

NSString * toAddPriceSymbol (NSString *str);

- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;

- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;

+ (NSString *)getStringFromArray:(NSArray *)array;
- (NSArray *)getArray;

+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;

- (NSData *)convertToData;
+ (NSString *)getStringFromData:(NSData *)data;

- (BOOL)isValidEmail;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isValidUrl;
- (BOOL)isValidPassword;
- (BOOL) isValidFirstName;
- (BOOL)isValidMobileNumber;
- (BOOL)isValidName ;

- (NSString *)trimWhitespace;
NSString * imageToNSString (UIImage *image );
+ (NSString*)ordinalNumberFormat:(NSNumber *)numObj;

@end
