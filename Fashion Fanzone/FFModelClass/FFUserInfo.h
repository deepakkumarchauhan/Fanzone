//
//  FFUserInfo.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FFUserInfo : NSObject

@property (strong, nonatomic) NSString *userNameString;
@property (strong, nonatomic) NSString *passwordString;
@property (strong, nonatomic) NSString *emailAddressString;
@property (strong, nonatomic) NSString *firstNameString;
@property (strong, nonatomic) NSString *lastNameString;
@property (strong, nonatomic) NSString *businessNameString;
@property (strong, nonatomic) NSString *userPhotoBase64String;
@property (strong, nonatomic) NSString *bannerBase64String;

@property (strong, nonatomic) NSString *userType;


@property (strong, nonatomic) UIImage* userPhotoImage;
@property (strong, nonatomic) UIImage* bannerPhotoImage;



// Report Screen
@property (strong, nonatomic) NSString *titleText;
@property (assign, nonatomic) BOOL isSelect;
@property (strong, nonatomic) NSMutableArray *privateSubCategoryArray;

//Personal Info
@property (strong, nonatomic) NSString *displayNameString;
@property (strong, nonatomic) NSString *changeUserNameString;
@property (strong, nonatomic) NSString *bioString;
@property (strong, nonatomic) NSString *websiteString;
@property (strong, nonatomic) NSString *emailString;
@property (strong, nonatomic) NSString *phoneNumberString;
@property (strong, nonatomic) NSString *genderString;
@property (strong, nonatomic) NSString *isVerify;


//Contact Info

@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSString *friendEmailAddress;
@property (nonatomic, assign) BOOL isSelected;

@property (strong, nonatomic) NSString *name;



@property (nonatomic,strong)NSString *connectionType;
@property (nonatomic,strong)NSString *connection;
@property (nonatomic,strong)NSString *none;
@property (nonatomic,strong)NSString *every;
@property (nonatomic,strong)NSString *userId;


+(FFUserInfo*)userDetail:(NSDictionary *)userDict;
+(FFUserInfo *)userInfoGetPrivateAccountResponse:(NSDictionary*)dict;
@end
