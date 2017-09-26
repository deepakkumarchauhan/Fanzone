//
//  FFFanzoneModelInfo.h
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 02/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FFFanzoneModelInfo : NSObject

+(FFFanzoneModelInfo *)fanzoneCategoryFromResponse:(NSDictionary*)dictTemp;

+(FFFanzoneModelInfo *)fanzoneListFromResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)fanzoneGetEditorialFromResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)fanzoneGetExploreFromResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)profileResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)fanzoneDetailResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)fanzoneFetchExploreSearchFromResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)fanzoneUserDetailResponse:(NSDictionary*)dictTemp;

+(FFFanzoneModelInfo *)fanzoneManageFlowResponse:(NSDictionary*)dictTemp;
+(FFFanzoneModelInfo *)offerListResponse:(NSDictionary*)dict;




+(FFFanzoneModelInfo *)profilePostResponse:(NSDictionary*)dictTemp;
@property (nonatomic,strong)NSString *categoryName;
@property (nonatomic,strong)NSString *categoryID;
@property (nonatomic,strong)NSString *guestUserID;
@property (nonatomic,strong)NSString *guestUserName;
@property (nonatomic,strong)NSString *guestUserImage;

@property (nonatomic,strong)NSString *categorySlugName;

@property (nonatomic,strong)UIImage *commentImage;


@property (nonatomic,strong)NSString *publishId;
@property (nonatomic,strong)NSString *fanzoneDescription;
@property (nonatomic,strong)NSString *profileImage;
@property (nonatomic,strong)NSString *publishImage;
@property (nonatomic,strong)NSString *publishImage_length;
@property (nonatomic,strong)NSString *publishImage_width;
@property (nonatomic,strong)NSString *authorType;
@property (nonatomic,strong)NSString *displayName;
@property (nonatomic,strong)NSString *img_type;

@property (nonatomic,strong)NSString *firstName;
@property (nonatomic,strong)NSString *lastName;

@property (nonatomic,strong)NSString *lattitude;
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *likeCount;
@property (nonatomic,strong)NSString *commentCount;
@property (nonatomic,strong)NSString *fanzoneTitle;
@property (nonatomic,strong)NSString *bannerImageSize;
@property (nonatomic,strong)NSString *bannerImage;
@property (nonatomic,strong)NSString *imageWidth;
@property (nonatomic,strong)NSString *imageHeight;
@property (nonatomic,strong)NSString *comment;
@property (nonatomic,strong)NSString *commentId;

@property (nonatomic,strong)NSString *postId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *flowName;
@property (nonatomic,strong)NSString *achievementName;

@property (nonatomic,strong)UIImage* editProfileImage;
@property (nonatomic,strong)UIImage* editBannerImage;

@property (nonatomic,strong)NSString *maxLikeCount;
@property (nonatomic,strong)NSString *totalLikeCount;


@property (nonatomic,strong)NSString *commentUserId;


@property (nonatomic,strong)NSString *status;


@property (nonatomic,strong)NSString *connectionsCount;
@property (nonatomic,strong)NSString *followersCount;
@property (nonatomic,strong)NSString *numberOfTags;
@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *postAddUserId;
@property (nonatomic,strong)NSString *bio;
@property (nonatomic,strong)NSString *userUrl;

@property (nonatomic,strong)NSString *likeStatus;


@property (nonatomic,strong)NSString *offerTitle;
@property (nonatomic,strong)NSString *offerDescription;


@property (nonatomic,strong)NSString *isVerify;


@property (nonatomic,strong)NSString *userType;
@property (nonatomic,assign)BOOL isFollow;
@property (nonatomic,strong)NSString *userEmail;
@property (nonatomic,strong)NSString *stylePoints;
@property (nonatomic,strong)NSMutableArray *categoryArray;
@property (nonatomic,strong)NSMutableArray *guserArray;
@property (nonatomic,strong)NSString *stylePicture;


@property (nonatomic,strong)NSString *viewPermissionName;
@property (nonatomic,strong)NSString *viewPermissionType;

@property (nonatomic,strong)NSString *postPermissionName;
@property (nonatomic,strong)NSString *postPermissionType;

@property (nonatomic,strong)NSMutableArray *userPostArray;
@property (nonatomic,strong)NSMutableArray *userDetailArray;
@property (nonatomic,strong)NSMutableArray *editorialArray;
@property (nonatomic,strong)NSString * dataArrayType;

@property (nonatomic,strong)NSMutableArray *userBannerImageArray;
@property (nonatomic,strong)NSMutableArray *commentArray;
@property (nonatomic,strong)NSMutableArray *replytArray;

@property (nonatomic,strong)NSMutableArray *publishImageArray;

@property (nonatomic,strong)NSMutableArray *flowArray;
@property (nonatomic,strong)NSMutableArray *achievementArray;

@property (nonatomic,strong)NSMutableArray *viewPermissionArray;
@property (nonatomic,strong)NSMutableArray *postPermissionArray;



@property (nonatomic,strong)NSMutableArray *selectedViewByUserArray;
@property (nonatomic,strong)NSMutableArray *selectedPostByUserArray;

@property (nonatomic,strong)NSMutableArray *selectedViewArray;
@property (nonatomic,strong)NSMutableArray *selectedPostArray;


@end
