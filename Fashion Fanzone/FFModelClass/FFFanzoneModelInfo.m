//
//  FFFanzoneModelInfo.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 02/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFFanzoneModelInfo.h"
#import "NSDictionary+NullChecker.h"
#import "Macro.h"

@implementation FFFanzoneModelInfo


+(FFFanzoneModelInfo *)fanzoneCategoryFromResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.categoryArray = [NSMutableArray array];
    fanzoneInfo.guserArray = [NSMutableArray array];
    
    NSArray *categoryArray = [dictTemp objectForKeyNotNull:KCategoryList expectedObj:[NSArray array]];
    NSArray *guestArray = [dictTemp objectForKeyNotNull:KGuestList expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in categoryArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.categoryID = [dict objectForKeyNotNull:KCategoryId expectedObj:@""];
        tempInfo.categorySlugName = [dict objectForKeyNotNull:KCategorySlug expectedObj:@""];
        tempInfo.categoryName = [dict objectForKeyNotNull:KCategoryName expectedObj:@""];
        [fanzoneInfo.categoryArray addObject:tempInfo];
    }
    
    for (NSDictionary *dict in guestArray) {
        
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.categoryID = [dict objectForKeyNotNull:KCategoryId expectedObj:@""];
        tempInfo.guestUserName = [dict objectForKeyNotNull:KUserName expectedObj:@""];
        tempInfo.guestUserImage = [dict objectForKeyNotNull:KProfilePicture expectedObj:@""];
        tempInfo.categoryName = [dict objectForKeyNotNull:KCategoryName expectedObj:@""];
        tempInfo.guestUserID = [dict objectForKeyNotNull:KUserId expectedObj:@""];

        [fanzoneInfo.guserArray addObject:tempInfo];
    }
    
    return fanzoneInfo;
}



+(FFFanzoneModelInfo *)fanzoneListFromResponse:(NSDictionary*)dictTemp{
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    
    fanzoneInfo.userPostArray = [NSMutableArray array];
    
    NSArray *postArray = [dictTemp objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
    
    for (NSDictionary *tempDict in postArray) {
        
        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        fanzoneTempInfo.publishImage = [tempDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
        fanzoneTempInfo.img_type = [tempDict objectForKeyNotNull:Kimg_type expectedObj:@""];
       
        
        [fanzoneInfo.userPostArray addObject:fanzoneTempInfo];
    }
    
    fanzoneInfo.publishId = [dictTemp objectForKeyNotNull:KPublishId expectedObj:@""];
    fanzoneInfo.fanzoneDescription = [dictTemp objectForKeyNotNull:KHtmlContent expectedObj:@""];
    fanzoneInfo.profileImage = [dictTemp objectForKeyNotNull:KUserImage expectedObj:@""];
    fanzoneInfo.authorType = [dictTemp objectForKeyNotNull:KUserType expectedObj:@""];
    fanzoneInfo.lattitude = [dictTemp objectForKeyNotNull:KDefaultlatitude expectedObj:@""];
    fanzoneInfo.longitude = [dictTemp objectForKeyNotNull:KDefaultlongitude expectedObj:@""];
    fanzoneInfo.likeCount = [dictTemp objectForKeyNotNull:KLikeCount expectedObj:@""];
    fanzoneInfo.commentCount = [dictTemp objectForKeyNotNull:KCommentCount expectedObj:@""];
    fanzoneInfo.guestUserName = [dictTemp objectForKeyNotNull:KUserName expectedObj:@""];
    fanzoneInfo.userEmail = [dictTemp objectForKeyNotNull:KEmail expectedObj:@""];
    fanzoneInfo.postAddUserId = [dictTemp objectForKeyNotNull:KPostUserId expectedObj:@""];
    fanzoneInfo.stylePoints = [dictTemp objectForKeyNotNull:KStylePoints expectedObj:@""];
    
    return fanzoneInfo;
}

+(FFFanzoneModelInfo *)fanzoneGetEditorialFromResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.publishId = [dictTemp objectForKeyNotNull:KPostId expectedObj:@""];
    
    fanzoneInfo.likeCount = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:KLikeCount expectedObj:@""]];
    fanzoneInfo.likeStatus = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:KLikeStatus expectedObj:@""]];
    fanzoneInfo.commentCount = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:KCommentCount expectedObj:@""]];
    fanzoneInfo.profileImage = [dictTemp objectForKeyNotNull:KProfilePicture expectedObj:@""];
    fanzoneInfo.bannerImage = [dictTemp objectForKeyNotNull:KBannerImage expectedObj:@""];
    fanzoneInfo.fanzoneTitle = [dictTemp objectForKeyNotNull:KFanzoneTitle expectedObj:@""];
    fanzoneInfo.bannerImageSize = [dictTemp objectForKeyNotNull:KBannerImageSize expectedObj:@""];
    fanzoneInfo.fanzoneDescription = [dictTemp objectForKeyNotNull:KHtmlContent expectedObj:@""];
    
    fanzoneInfo.imageWidth = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:KImageWidth expectedObj:@""]];
    fanzoneInfo.imageHeight = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:KImageHeight expectedObj:@""]];
    fanzoneInfo.userId = [NSString stringWithFormat:@"%@",[dictTemp objectForKeyNotNull:@"userId" expectedObj:@""]];
    
    return fanzoneInfo;
    
}

+(FFFanzoneModelInfo *)fanzoneGetExploreFromResponse:(NSDictionary*)dictTemp {
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    
    fanzoneInfo.userPostArray = [NSMutableArray array];
    
    NSArray *postArray = [dictTemp objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
    
    for (NSDictionary *tempDict in postArray) {
        
        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        fanzoneTempInfo.publishImage = [tempDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
        [fanzoneInfo.userPostArray addObject:fanzoneTempInfo];
    }
    
    fanzoneInfo.publishId = [dictTemp objectForKeyNotNull:KPublishId expectedObj:@""];
    fanzoneInfo.fanzoneDescription = [dictTemp objectForKeyNotNull:KHtmlContent expectedObj:@""];
    fanzoneInfo.profileImage = [dictTemp objectForKeyNotNull:KUserImage expectedObj:@""];
    
    //    fanzoneInfo.publishImage = [dictTemp objectForKeyNotNull:KFanzonePublishImage expectedObj:@""];
    
    fanzoneInfo.authorType = [dictTemp objectForKeyNotNull:KUserType expectedObj:@""];
    fanzoneInfo.lattitude = [dictTemp objectForKeyNotNull:KDefaultlatitude expectedObj:@""];
    fanzoneInfo.longitude = [dictTemp objectForKeyNotNull:KDefaultlongitude expectedObj:@""];
    fanzoneInfo.likeCount = [dictTemp objectForKeyNotNull:KLikeCount expectedObj:@""];
    fanzoneInfo.commentCount = [dictTemp objectForKeyNotNull:KCommentCount expectedObj:@""];
    fanzoneInfo.guestUserName = [dictTemp objectForKeyNotNull:KUserName expectedObj:@""];
    fanzoneInfo.userEmail = [dictTemp objectForKeyNotNull:KEmail expectedObj:@""];
    fanzoneInfo.postAddUserId = [dictTemp objectForKeyNotNull:KPostUserId expectedObj:@""];
    fanzoneInfo.stylePoints = [dictTemp objectForKeyNotNull:KStylePoints expectedObj:@""];
    
    return fanzoneInfo;
    
}


+(FFFanzoneModelInfo *)profileResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.userPostArray = [NSMutableArray array];
    fanzoneInfo.userBannerImageArray = [NSMutableArray array];
    
    NSArray *userPostArray = [dictTemp objectForKeyNotNull:KUserPost expectedObj:[NSArray array]];
    NSArray *styleImageArray = [dictTemp objectForKeyNotNull:KStyleImage expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in userPostArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.likeCount = [dict objectForKeyNotNull:KLikeCount expectedObj:@""];
        tempInfo.commentCount = [dict objectForKeyNotNull:KCommentCount expectedObj:@""];
        tempInfo.publishId = [dict objectForKeyNotNull:KPublishId expectedObj:@""];
        tempInfo.postAddUserId = [dict objectForKeyNotNull:KPostUserId expectedObj:@""];
        tempInfo.fanzoneDescription = [dict objectForKeyNotNull:KHtmlContent expectedObj:@""];

        tempInfo.userPostArray = [NSMutableArray array];
        
        NSArray *userPostArray = [dict objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
        
        for (NSDictionary *bannerImageDict in userPostArray) {
            FFFanzoneModelInfo *tempBannerInfo = [[FFFanzoneModelInfo alloc]init];
            tempBannerInfo.publishImage = [bannerImageDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
            [tempInfo.userPostArray addObject:tempBannerInfo];
        }
        [fanzoneInfo.userPostArray addObject:tempInfo];
    }
    
    
    for (NSDictionary *styleDict in styleImageArray) {
        
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.likeCount = [styleDict objectForKeyNotNull:KLikeCount expectedObj:@""];
        tempInfo.commentCount = [styleDict objectForKeyNotNull:KCommentCount expectedObj:@""];
        tempInfo.publishId = [styleDict objectForKeyNotNull:KPublishId expectedObj:@""];
        tempInfo.postAddUserId = [styleDict objectForKeyNotNull:KPostUserId expectedObj:@""];
        tempInfo.fanzoneDescription = [styleDict objectForKeyNotNull:KHtmlContent expectedObj:@""];

        tempInfo.userPostArray = [NSMutableArray array];
        
        NSArray *userPostArray = [styleDict objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
        
        for (NSDictionary *bannerImageDict in userPostArray) {
            FFFanzoneModelInfo *tempBannerInfo = [[FFFanzoneModelInfo alloc]init];
            tempBannerInfo.publishImage = [bannerImageDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
            [tempInfo.userPostArray addObject:tempBannerInfo];
        }
        [fanzoneInfo.userBannerImageArray addObject:tempInfo];
        
    }
    
    return fanzoneInfo;
}


+(FFFanzoneModelInfo *)profilePostResponse:(NSDictionary*)dict {
    
    FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
    tempInfo.likeCount = [dict objectForKeyNotNull:KLikeCount expectedObj:@""];
    tempInfo.commentCount = [dict objectForKeyNotNull:KCommentCount expectedObj:@""];
    tempInfo.publishId = [dict objectForKeyNotNull:KPublishId expectedObj:@""];
    tempInfo.fanzoneDescription = [dict objectForKeyNotNull:KHtmlContent expectedObj:@""];
    tempInfo.postAddUserId = [dict objectForKeyNotNull:KPostUserId expectedObj:@""];
    tempInfo.stylePoints = [dict objectForKeyNotNull:KStylePoints expectedObj:@""];
    tempInfo.profileImage = [dict objectForKeyNotNull:KProfileImage expectedObj:@""];
    tempInfo.guestUserName = [dict objectForKeyNotNull:KUserName expectedObj:@""];

    tempInfo.userPostArray = [NSMutableArray array];

    NSArray *userPostArray = [dict objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
    
    for (NSDictionary *bannerImageDict in userPostArray) {
        FFFanzoneModelInfo *tempBannerInfo = [[FFFanzoneModelInfo alloc]init];
        tempBannerInfo.publishImage = [bannerImageDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
        [tempInfo.userPostArray addObject:tempBannerInfo];
    }

    return tempInfo;
}




+(FFFanzoneModelInfo *)fanzoneDetailResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.commentArray = [NSMutableArray array];
    
    NSArray *userPostArray = [dictTemp objectForKeyNotNull:KCommentList expectedObj:[NSArray array]];
    
    // User Details
    NSDictionary *userDict = [dictTemp objectForKeyNotNull:KUserDetail expectedObj:[NSDictionary dictionary]];
    
    fanzoneInfo.profileImage = [userDict objectForKeyNotNull:KUserImage expectedObj:@""];
    fanzoneInfo.userName = [userDict objectForKeyNotNull:KUserName expectedObj:@""];
    fanzoneInfo.bannerImage = [userDict objectForKeyNotNull:KBannerImage expectedObj:@""];
    fanzoneInfo.fanzoneDescription = [userDict objectForKeyNotNull:KHtmlContent expectedObj:@""];
    fanzoneInfo.likeCount = [userDict objectForKeyNotNull:KLikeCount expectedObj:@""];
    fanzoneInfo.stylePoints = [userDict objectForKeyNotNull:KStylePoints expectedObj:@""];
    fanzoneInfo.commentCount = [userDict objectForKeyNotNull:KCommentCount expectedObj:@""];
    fanzoneInfo.postId = [userDict objectForKeyNotNull:KPostID expectedObj:@""];
    fanzoneInfo.userId = [userDict objectForKeyNotNull:KUserId expectedObj:@""];
    fanzoneInfo.fanzoneTitle = [userDict objectForKeyNotNull:KPost_title expectedObj:@""];

    
    fanzoneInfo.likeStatus = [userDict objectForKeyNotNull:KLikeStatus expectedObj:@""];
    
    for (NSDictionary *tempDict in userPostArray) {
        
        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        fanzoneTempInfo.replytArray = [NSMutableArray array];
        
        fanzoneTempInfo.profileImage = [tempDict objectForKeyNotNull:KUserImage expectedObj:@""];
        fanzoneTempInfo.userName = [tempDict objectForKeyNotNull:KUserName expectedObj:@""];
        fanzoneTempInfo.comment = [tempDict objectForKeyNotNull:KComment expectedObj:@""];
        fanzoneTempInfo.commentId = [tempDict objectForKeyNotNull:KComment_ID expectedObj:@""];
        fanzoneTempInfo.commentUserId = [tempDict objectForKeyNotNull:KUserId expectedObj:@""];
        fanzoneTempInfo.publishImage = [tempDict objectForKeyNotNull:KPublishImage expectedObj:@""];
        fanzoneTempInfo.likeStatus = [tempDict objectForKeyNotNull:KLikeCommentStatus expectedObj:@""];
        fanzoneTempInfo.likeCount = [tempDict objectForKeyNotNull:KLikeCount expectedObj:@""];
        fanzoneTempInfo.commentCount = [tempDict objectForKeyNotNull:KCommentCount expectedObj:@""];


        NSArray *userReplyArray = [tempDict objectForKeyNotNull:KReply expectedObj:[NSArray array]];
        
        for (NSDictionary *tempDict in userReplyArray) {
            
            FFFanzoneModelInfo *replyInfo = [[FFFanzoneModelInfo alloc]init];
            replyInfo.profileImage = [tempDict objectForKeyNotNull:KUserImage expectedObj:@""];
            replyInfo.userName = [tempDict objectForKeyNotNull:KUserName expectedObj:@""];
            replyInfo.comment = [tempDict objectForKeyNotNull:KComment expectedObj:@""];
            replyInfo.commentId = [tempDict objectForKeyNotNull:KComment_ID expectedObj:@""];
            replyInfo.commentUserId = [tempDict objectForKeyNotNull:KUserId expectedObj:@""];
            replyInfo.profileImage = [tempDict objectForKeyNotNull:KPublishImage expectedObj:@""];
            [fanzoneTempInfo.replytArray addObject:replyInfo];
        }
        
        [fanzoneInfo.commentArray addObject:fanzoneTempInfo];
    }
    
    
    return fanzoneInfo;
}


+(FFFanzoneModelInfo *)fanzoneUserDetailResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    
    fanzoneInfo.userBannerImageArray = [NSMutableArray array];
    fanzoneInfo.flowArray = [NSMutableArray array];
    fanzoneInfo.achievementArray = [NSMutableArray array];
    
    NSArray *userProfileArray = [dictTemp objectForKeyNotNull:KStyleImages expectedObj:[NSArray array]];
    
    // User Details
    NSDictionary *userDict = [dictTemp objectForKeyNotNull:KUserDetail expectedObj:[NSDictionary dictionary]];
    NSArray *flowArray = [dictTemp objectForKeyNotNull:kAllFlows expectedObj:[NSArray array]];
    
    NSDictionary *achievementDictionary = [userDict objectForKeyNotNull:KAllAchievement expectedObj:[NSDictionary dictionary]];
    
    
    fanzoneInfo.profileImage = [userDict objectForKeyNotNull:KUserImage expectedObj:@""];
    fanzoneInfo.userName = [userDict objectForKeyNotNull:KUserName expectedObj:@""];
    fanzoneInfo.bannerImage = [userDict objectForKeyNotNull:KBannerImage expectedObj:@""];
    fanzoneInfo.fanzoneDescription = [userDict objectForKeyNotNull:KHtmlContent expectedObj:@""];
    fanzoneInfo.followersCount = [userDict objectForKeyNotNull:kFollowerCount expectedObj:@""];
    fanzoneInfo.connectionsCount = [userDict objectForKeyNotNull:kConnectionsCount expectedObj:@""];
    fanzoneInfo.stylePoints = [userDict objectForKeyNotNull:KStylePoints expectedObj:@""];
    fanzoneInfo.bio = ([[userDict objectForKeyNotNull:KBio expectedObj:@""] length]) ? [userDict objectForKeyNotNull:KBio expectedObj:@""] : @"No bio.";
    fanzoneInfo.userUrl = ([[userDict objectForKeyNotNull:KUrl expectedObj:@""] length]) ? [userDict objectForKeyNotNull:KUrl expectedObj:@""] : @"No URL.";
    fanzoneInfo.isVerify = [userDict objectForKeyNotNull:KIsVerify expectedObj:@""];
    fanzoneInfo.userType = [userDict objectForKeyNotNull:KType expectedObj:@""];
    fanzoneInfo.userId = [userDict objectForKeyNotNull:KUserId expectedObj:@""];
    
    for (NSDictionary *tempDict in userProfileArray) {
        
        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        fanzoneTempInfo.publishImage = [tempDict objectForKeyNotNull:KBannerImage expectedObj:@""];
        [fanzoneInfo.userBannerImageArray addObject:fanzoneTempInfo];
    }
    
    for (NSDictionary *tempDict in flowArray) {

        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        fanzoneTempInfo.flowName = [tempDict objectForKeyNotNull:KFlow expectedObj:@""];
        [fanzoneInfo.flowArray addObject:fanzoneTempInfo];
    }
    
    for (NSString *tempStr in achievementDictionary) {
        
        FFFanzoneModelInfo *fanzoneTempInfo = [[FFFanzoneModelInfo alloc]init];
        
        if ([tempStr isEqualToString:@"connections"]) {
            fanzoneTempInfo.connectionsCount = [achievementDictionary objectForKeyNotNull:KConnections expectedObj:@""];
        }else if ([tempStr isEqualToString:@"followers"]){
            fanzoneTempInfo.connectionsCount = [achievementDictionary objectForKeyNotNull:KFollowers expectedObj:@""];
        }else if ([tempStr isEqualToString:@"maxLikeSInglePost"]) {
            fanzoneTempInfo.connectionsCount = [achievementDictionary objectForKeyNotNull:KMaxLike expectedObj:@""];

        }else if ([tempStr isEqualToString:@"stylePoints"]) {
            fanzoneTempInfo.connectionsCount = [achievementDictionary objectForKeyNotNull:KStylePoints expectedObj:@""];
        }else if ([tempStr isEqualToString:@"totalLikesOnAllPosts"]) {
            fanzoneTempInfo.connectionsCount = [achievementDictionary objectForKeyNotNull:KTotalLikeOnPost expectedObj:@""];
        }
        
        [fanzoneInfo.achievementArray addObject:fanzoneTempInfo];
    }
    
    return fanzoneInfo;
}


+(FFFanzoneModelInfo *)fanzoneFetchExploreSearchFromResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.userPostArray = [NSMutableArray array];
    fanzoneInfo.userDetailArray = [NSMutableArray array];
    fanzoneInfo.editorialArray = [NSMutableArray array];
    
    
    NSArray *userPostArray = [dictTemp objectForKeyNotNull:kPostList expectedObj:[NSArray array]];
    NSArray *userListArray = [dictTemp objectForKeyNotNull:KUserList expectedObj:[NSArray array]];
    NSArray *editorialListArray = [dictTemp objectForKeyNotNull:KEditorialList expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in userPostArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.likeCount = [dict objectForKeyNotNull:KLikeCount expectedObj:@""];
        tempInfo.commentCount = [dict objectForKeyNotNull:KCommentCount expectedObj:@""];
        tempInfo.publishId = [dict objectForKeyNotNull:KPublishId expectedObj:@""];
        tempInfo.stylePoints = [dict objectForKeyNotNull:KStylePoints expectedObj:@""];
        tempInfo.fanzoneDescription = [dict objectForKeyNotNull:KHtmlContent expectedObj:@""];
        tempInfo.userName = [dict objectForKeyNotNull:KUserName expectedObj:@""];
        
        tempInfo.userPostArray = [NSMutableArray array];
        
        NSArray *userPostArray = [dict objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
        
        
        for (NSDictionary *bannerImageDict in userPostArray) {
            FFFanzoneModelInfo *tempBannerInfo = [[FFFanzoneModelInfo alloc]init];
            tempBannerInfo.publishImage = [bannerImageDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
            [tempInfo.userPostArray addObject:tempBannerInfo];
        }
        fanzoneInfo.dataArrayType = @"postArray";
        [fanzoneInfo.userPostArray addObject:tempInfo];
    }
    
    
    for (NSDictionary *dict in userListArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.userName = [dict objectForKeyNotNull:KUserName expectedObj:@""];
        tempInfo.displayName = [dict objectForKeyNotNull:KDisplayName expectedObj:@""];
        tempInfo.firstName = [dict objectForKeyNotNull:KFirstName expectedObj:@""];
        tempInfo.lastName = [dict objectForKeyNotNull:KLastName expectedObj:@""];
        tempInfo.profileImage = [dict objectForKeyNotNull:KProfilePicture expectedObj:@""];
        tempInfo.status = [dict objectForKeyNotNull:KConnectionStatus expectedObj:@""];
        tempInfo.stylePoints = [dict objectForKeyNotNull:KStylePoints expectedObj:@""];
        tempInfo.postAddUserId = [dict objectForKeyNotNull:KOtheruserID expectedObj:@""];
        fanzoneInfo.dataArrayType = @"userListArray";
        [fanzoneInfo.userDetailArray addObject:tempInfo];
    }
    
    
    for (NSDictionary *dict in editorialListArray) {
        
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.likeCount = [dict objectForKeyNotNull:KLikeCount expectedObj:@""];
        tempInfo.commentCount = [dict objectForKeyNotNull:KCommentCount expectedObj:@""];
        tempInfo.publishId = [dict objectForKeyNotNull:KPublishId expectedObj:@""];
        tempInfo.fanzoneDescription = [dict objectForKeyNotNull:KHtmlContent expectedObj:@""];
        tempInfo.bannerImage = [dict objectForKeyNotNull:KBannerImage expectedObj:@""];
        tempInfo.profileImage = [dict objectForKeyNotNull:KProfilePicture expectedObj:@""];
        tempInfo.bannerImageSize = [dict objectForKeyNotNull:KBannerImageSize expectedObj:@""];
        tempInfo.fanzoneTitle = [dict objectForKeyNotNull:KTitle expectedObj:@""];
        tempInfo.imageWidth = [NSString stringWithFormat:@"%@",[dict objectForKeyNotNull:KImageWidth expectedObj:@""]];
        tempInfo.imageHeight = [NSString stringWithFormat:@"%@",[dict objectForKeyNotNull:KImageHeight expectedObj:@""]];
        tempInfo.userPostArray = [NSMutableArray array];
        
        NSArray *userPostArray = [dict objectForKeyNotNull:KallPublishImages expectedObj:[NSArray array]];
        
        
        for (NSDictionary *bannerImageDict in userPostArray) {
            FFFanzoneModelInfo *tempBannerInfo = [[FFFanzoneModelInfo alloc]init];
            tempBannerInfo.publishImage = [bannerImageDict objectForKeyNotNull:KallPublishImages expectedObj:@""];
            [tempInfo.userPostArray addObject:tempBannerInfo];
        }
        fanzoneInfo.dataArrayType = @"editorialArray";
        [fanzoneInfo.editorialArray addObject:tempInfo];
    }
    
    return fanzoneInfo;
}


+(FFFanzoneModelInfo *)fanzoneManageFlowResponse:(NSDictionary*)dictTemp {
    
    FFFanzoneModelInfo *fanzoneInfo = [[FFFanzoneModelInfo alloc]init];
    fanzoneInfo.viewPermissionArray = [NSMutableArray array];
    fanzoneInfo.postPermissionArray = [NSMutableArray array];
    fanzoneInfo.categoryArray = [NSMutableArray array];
    
    fanzoneInfo.selectedViewArray = [NSMutableArray array];
    fanzoneInfo.selectedPostArray = [NSMutableArray array];

    
    
    NSArray *viewPermissionArray = [dictTemp objectForKeyNotNull:kViewPermission expectedObj:[NSArray array]];
    NSArray *postPermissionArray = [dictTemp objectForKeyNotNull:kPostPermission expectedObj:[NSArray array]];
    NSArray *flowListArray = [dictTemp objectForKeyNotNull:kFlows expectedObj:[NSArray array]];
    
    NSArray *postUserNameArr = [dictTemp objectForKeyNotNull:@"postUserName" expectedObj:[NSArray array]];
    NSArray *viewUserNameArr = [dictTemp objectForKeyNotNull:@"viewUserName" expectedObj:[NSArray array]];
    
    for (NSDictionary *dict in postUserNameArr) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.userName = [dict objectForKeyNotNull:KUserName expectedObj:@""];
        tempInfo.userId = [dict objectForKeyNotNull:KUserId expectedObj:@""];
        
        [fanzoneInfo.selectedPostArray addObject:tempInfo];
    }
    
    for (NSDictionary *dict in viewUserNameArr) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.userName = [dict objectForKeyNotNull:KUserName expectedObj:@""];
        tempInfo.userId = [dict objectForKeyNotNull:KUserId expectedObj:@""];
        
        [fanzoneInfo.selectedViewArray addObject:tempInfo];
    }
    
    
    for (NSDictionary *dict in flowListArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.categoryName = [dict objectForKeyNotNull:KCategoryName expectedObj:@""];
        tempInfo.categoryID = [dict objectForKeyNotNull:KCategoryId expectedObj:@""];
        tempInfo.categorySlugName = [dict objectForKeyNotNull:KCategorySlug expectedObj:@""];
      //  tempInfo.isVerify = [dict objectForKeyNotNull:KIsFollow expectedObj:@""];

        [fanzoneInfo.categoryArray addObject:tempInfo];
    }
    
    for (NSDictionary *dict in postPermissionArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.postPermissionName = [dict objectForKeyNotNull:KName expectedObj:@""];
        tempInfo.postPermissionType = [dict objectForKeyNotNull:KPostType expectedObj:@""];
      //  tempInfo.lastName = [dict objectForKeyNotNull:KLastName expectedObj:@""];

        [fanzoneInfo.postPermissionArray addObject:tempInfo];
    }
    
    for (NSDictionary *dict in viewPermissionArray) {
        FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
        tempInfo.viewPermissionName = [dict objectForKeyNotNull:KName expectedObj:@""];
        tempInfo.viewPermissionType = [dict objectForKeyNotNull:KViewType expectedObj:@""];
        //tempInfo.fanzoneDescription = [dict objectForKeyNotNull:KHtmlContent expectedObj:@""];

        [fanzoneInfo.viewPermissionArray addObject:tempInfo];
    }
    
    return fanzoneInfo;
}


+(FFFanzoneModelInfo *)offerListResponse:(NSDictionary*)dict {
    
    FFFanzoneModelInfo *tempInfo = [[FFFanzoneModelInfo alloc]init];
    tempInfo.offerTitle = [dict objectForKeyNotNull:KOfferTitle expectedObj:@""];
    tempInfo.offerDescription = [dict objectForKeyNotNull:KOfferDescription expectedObj:@""];

    return tempInfo;
}



@end
