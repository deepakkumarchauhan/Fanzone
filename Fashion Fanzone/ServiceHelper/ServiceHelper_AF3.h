//
//  ServiceHelper_AF3.h
//  SaruPayPOS
//
//  Created by Mirza Zuhaib Beg on 9/21/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Macro.h"


// staging
//#define SERVICE_BASE_URL @"http://172.16.0.9/PROJECTS/PhotoVideoApp/website/web-api"


//#define SERVICE_BASE_URL @"http://172.16.0.9/PROJECTS/PhotoVideoApp/website/web-api"


#define SERVICE_BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/PhotoVideo/website/web-api"



static NSString * apiAction                       = @"action";
static NSString * apiSignUp                       = @"signup";
static NSString * apiLogIn                        = @"login";
static NSString * apiForgot                       = @"forgotPassword";
static NSString * apiLogout                       = @"logout";
static NSString * apiPublish                      = @"createPublishPost";
static NSString * apiFanzonePublish               = @"createPublishFanzone";
static NSString * apiGetMessageList               = @"getMessageList";
static NSString * apiGetFlows                     = @"getManageFlow";
static NSString * apiReadMessage                  = @"readMessage";
static NSString * apiAccountSetting               = @"getAccountSetting";


static NSString * apiVerifyOTP                     = @"verifyOTP";
static NSString * apiResendOTP                     = @"resendOTP";


static NSString * apiSetAccountSetting            = @"setAccountSetting";

static NSString * apiGetAllUserList               = @"getAllUserList";
static NSString * apiAddChat                      = @"addChatMessage";
static NSString * apiGetFanzoneCategory           = @"getFanzoneCategory";
static NSString * apiToGetConnectedUser           = @"getConnected";
static NSString * apiGetFanzone                   = @"getPublishFanzone";
static NSString * apiPostDetail                   = @"getFanzoneDetailBasedOnFlow";
static NSString * apiCreateCategory               = @"createCategory";
static NSString * apiUpdateManageFlow             = @"updateManageFlow";


static NSString * apiPostComment                  = @"addPostComment";
static NSString * apiNearByLocation               = @"nearbyLocation";
static NSString * apiLikeUnlikeComment            = @"likeUnlikeComment";
static NSString * apiLikeUnlikePost               = @"likeUnlikePost";
static NSString * apiDeleteComment                = @"deletePostComment";
static NSString * apiInteractionHistory           = @"interactioHistory";

static NSString * apiDeletePost                   = @"deletePost";


static NSString * apiCheckUser                    = @"checkUser";

static NSString * apiShowProfile                  = @"getProfile";
static NSString * apiGetRecentList                = @"getRecentList";
static NSString * apiGetConnectionList            = @"getConnectionsList";
static NSString * apiGetConnecctionFollowersList  = @"getFollowersList";
static NSString * apiGetRecentStylePointList      = @"getRecentStylePointsList";
static NSString * apiGetRecivedStylePointList     = @"getReceivedStylePointsList";
static NSString * apiGetGivenStylePointList       = @"getGivenStylePointsList";
static NSString * apiSendInvitation               = @"sendInvitation";
static NSString * apiEditorial                    = @"get_editorial";
static NSString * apiUserProfile                  = @"userSelfProfile";
static NSString * apiReportProblem                = @"reportProblem";


static NSString * apiUpdateUserName               = @"changeUserName";
static NSString * apiGetBlockUserList             = @"getBlockedUserList";
static NSString * apiBlockUnblockUser             = @"blockUnblockUser";
static NSString * apiVerifyUser                   = @"verifyUser";
static NSString * apiSetting                      = @"setting";
static NSString * apiUpdateUserProfile            = @"updateSelfProfile";
static NSString * apiSearchPost                   = @"searchPosts";
static NSString * apiExplore                      = @"exploreList";
static NSString * apiStaticContent                = @"getStaticContent";
static NSString * apiUserMessageList              = @"getMessageThread";
static NSString * apiOffer                        = @"offer";



typedef void (^ServiceCompletionBlock)(BOOL suceeded, NSString *error,id response);

@interface ServiceHelper_AF3 : NSObject

@property (strong,nonatomic) ServiceCompletionBlock completionBlock;

@property (strong,nonatomic) AFHTTPSessionManager *manager;

+(id)instance;

-(void)makeGETWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
-(void)makeDeleteWebApiCallWithParameters:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
- (void)makeMultipartWebApiCallWithParametersForMultipleFile:(id)dict AndPath:(NSString*)strApi WithCompletion:(ServiceCompletionBlock)completionBlock;
@end
