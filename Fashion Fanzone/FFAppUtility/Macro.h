//
//  Macro.h
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
/***************************************************************
 *                               Frameworks                                   *
 ***************************************************************/
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


/***************************************************************
 *                               App Macros                                    *
 ***************************************************************/



// Api's Keys
#define kAPPName                @"Fashion Fanzone"
#define KresponseMessage        @"responseMessage"
#define KresponseCode           @"responseCode"
#define KSuccessCode            200
#define KUserId                 @"userID"

#define KUserIdContactList      @"UserID"

#define KOtheruserID            @"otherUserID"
#define KAction                 @"action"
#define KReceiverID             @"receiverID"
#define KLikeStatus             @"likeStatus"

#define KPost_title             @"post_title"
#define KStaticID               @"staticID"

#define KMessages               @"message"
#define KMessagesImage          @"image"
#define KIsRead                 @"isRead"
#define KUserConnectionStatus   @"connectionStatus"

#define KChat                   @"chat"


#define KReportProblem          @"problemType"

#define KMessageID              @"messageID"

#define KOtp                    @"otp"


#define KAlert                  @"Alert!"
#define KSuccess                @"Success!"
#define KError                  @"Error!"
#define KEmail                  @"userEmail"
#define KPassword               @"userPassword"
#define KConfirmPassword        @"confirmPassword"
#define KUserName               @"userName"
#define KFirstName              @"firstName"
#define KLastName               @"lastName"
#define KBannerImage            @"bannerPicture"
#define KUserImage              @"profilePicture"
#define KDeviceToken            @"deviceToken"
#define KDeviceType             @"deviceType"
#define KUserType               @"userType"
#define KHtmlContent            @"description"
#define KPublishImage           @"image"
#define KConnectedStatus        @"status"
#define kConnectionCount        @"connectionsCount"
#define kFollowerCount          @"followerCounts"
#define KNumberOfTag            @"numberOfTags"



#define KViewSelectedUserId     @"viewSelectedUserID"
#define KPostSelectedUserId     @"postSelectedUserID"


#define KName                   @"name"

#define KPhoneNumber            @"phoneNumber"
#define KGender                 @"gender"

#define KViewType               @"viewType"

#define KPostType               @"postType"

#define kConnectionsCount       @"connectionCount"

#define KType                   @"type"
#define KUrl                    @"url"
#define KBio                    @"bio"
#define KIsVerify               @"isVerify"
#define KIsVerified             @"isVerified"

#define KBlockUserList          @"blockedList"


#define KEditPassword           @"editPasswordStatus"
#define KImageStatus            @"imageStatus"
#define KDLocationStatus        @"locationStatus"
#define KMobileDataStatus       @"mobileDataStatus"
#define KNotificationStatus     @"notificationStatus"


#define KDesc                   @"desc"
#define KEditorail              @"postData"
#define KImageWidth             @"img_width"
#define KImageHeight            @"img_height"
#define KExplores               @"exploreList"
#define KDisplayName            @"display_name"
#define KIsFollow               @"isFollow"
#define kPostAddId              @"postAddUserId"
#define kContactDisplayName     @"displayName"
#define KStylePicture           @"stylePicture"

#define KStyleImages            @"styleImages"
#define kAllFlows               @"allFlows"


#define kFlows                  @"flows"
#define kViewPermission         @"viewPermissions"
#define kPostPermission         @"postPermissions"



#define KFlow                   @"flow"
#define KAllAchievement         @"allAchivments"

#define KConnections            @"connections"
#define KFollowers              @"followers"
#define KMaxLike                @"maxLikeSInglePost"
#define KTotalLikeOnPost        @"totalLikesOnAllPosts"


#define KAchievement            @"achivements"



#define KDefaultlongitude       @"longitude"
#define KDefaultlatitude        @"latitude"
#define KCaption                @"caption"
#define KFlowID                 @"flowID"
#define KTitle                  @"title"
#define KHtmlFanzoneContent     @"html_content"
#define KDefaultLocation        @"location"

#define KCategoryList           @"categoryList"
#define KGuestList              @"guestUsers"
#define KUserPost               @"postData"

#define KUserDetail             @"userDetail"

#define KStyleImage             @"styleData"
#define KUserList               @"userList"
#define KEditorialList          @"editorialList"

#define KInteractionList        @"interactionList"



#define KComments               @"comments"

#define KCommentList            @"commentList"

#define KComment                @"comment"




#define KComment_ID             @"comment_ID"
#define KCommentID             @"commentID"

#define KPost_ID                @"post_ID"

#define KCommentDate            @"comment_date"

#define KReply                  @"reply"

#define KSetting                @"setting"



#define KCommentUserId          @"commentUserID"

#define KCategoryName           @"categoryName"
#define KCategoryId             @"categoryID"
#define KCategorySlug           @"categorySlug"


#define KGuestId                @"ID"
#define KGuestName              @"displayName"
#define KKGuestImage            @"displayImage"
#define KStylePoints            @"stylePoints"
#define KPostUserId             @"postUserID"
#define KData                   @"fanzoneList"
#define kPostList               @"postList"

#define kOffers                 @"offers"


#define kVsPost                 @"vsPost"

#define KPublishId              @"publishId"
#define KPublishId              @"publishId"
#define KProfileImage           @"profileImage"
#define KPublishFanzoneImage    @"publishImage"
#define KPostId                 @"postId"
#define KallPublishImages       @"allPublishImage"
#define KBlockStatus            @"blockStatus"
#define KImage_Height           @"img_height"
#define KImage_Width            @"img_width"
#define KVerifyStatus           @"verifyStatus"
#define Kimg_type               @"img_type"

#define KPostID                 @"postID"

#define KUserEmail              @"userName/email"
#define KLikeCount              @"likeCount"


#define KUser_ID                @"user_id"
#define KConnection             @"connection"
#define KNone                   @"none"
#define KEvery                  @"every"


#define KLikeCommentStatus      @"likeCommentStatus"

#define KOfferTitle             @"offerTitle"
#define KOfferDescription       @"offerDescription"



#define KCommentCount           @"commentCount"
#define KPageSize               @"pageSize"
#define KPageNumber             @"pageNo"

#define KSearchText              @"searchText"

#define KPagination             @"pagination"

#define KFanzonePublishImage    @"publishImage"
#define KFanzoneTitle           @"title"

#define KBannerImage            @"bannerPicture"
#define KBannerImageSize        @"bannerPictureSize"

#define KConnectionStatus       @"connectionStatus"

#define KProfilePicture         @"profilePicture"

#define KBannerImageWidth       @"img_width"
#define KBannerImageHeight      @"img_height"


#define KSenderId               @"senderID"
#define KSenderName             @"senderName"
#define KSenderImage            @"senderImage"
#define KReceiverName           @"receiverName"
#define KRecieverImage          @"receiverImage"
#define KSendFrom               @"sendFrom"
#define KStatus                 @"status"



#define NSUSERDEFAULT       [NSUserDefaults standardUserDefaults]
#define TRIM_SPACE(str)         [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define APPDELEGATE                 (AppDelegate *)[[UIApplication sharedApplication] delegate];
#define windowWidth                 [UIScreen mainScreen].bounds.size.width
#define windowHeight                [UIScreen mainScreen].bounds.size.height
#define RGBCOLOR(r,g,b,a)     [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define AppFont(X)                    [UIFont fontWithName:@"AvantGarde-Book" size:X]
#define AppFontBOLD(X)          [UIFont fontWithName:@"AvantGarde-Book Bold" size:X]

#define AppFontDEMIBOLD(X) [UIFont fontWithName:@"ITCKabelStd-Demi" size:X]
#define AppTextColor                 [UIColor colorWithRed:255/255.0f green:234/255.0f blue:67/255.0f alpha:1.0f]
#define AppBgColor                    [UIColor colorWithRed:222.0/255.0f green:222.0/255.0f blue:222.0/255.0f alpha:1.0f]
#define TextFieldPlaceHolderColor                    [UIColor colorWithRed:(10.0f/255.0f) green:(10.0f/255.0f) blue:(10.0f/255.0f) alpha:1.0f]
#define MainScreenWidth    [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight    [UIScreen mainScreen].bounds.size.height
#define KContrast   @"contrast"
#define KBrightness @"brightness"
#define KSaturation @"saturation"
#define KEffects    @"effects"
#define KSketch     @"Sketch"
#define KFilter     @"Filter"
#define KTouch      @"Touch"
#define KIcon       @"Icon"

#define KAppStartCount       @"AppStartCount"
#define KGooglePlusClientID   @"242250473898-vorbaq1dv2m0rdpj4js4d4kr61qedlu7.apps.googleusercontent.com"


//log label

#define LOG_LEVEL           1

#define logInfo(frmt, ...)                 if(LOG_LEVEL) NSLog((@"%s" frmt), __PRETTY_FUNCTION__, ## __VA_ARGS__)

///***************************** User Default Keys   ***************************

#define RecentSearchObjectkey  @"reachSearchKey"


#pragma mark - Web Services Helper Classes
#import "MBProgressHUD.h"

#pragma mark - Category Classes


/***************************************************************
 *                                      Utility                                      *
 ***************************************************************/
#import "FFUtility.h"
#import "AlertView.h"
#import "NSString+FFStringValidator.h"

/***************************************************************
 *                                  Model Classes                            *
 ***************************************************************/
#import "FFUserInfo.h"
#import "FFMessageModal.h"
#import "FFProfileModal.h"
#import "IQKeyboardManager.h"
#import "FFImageProcess.h"
#import "FFPostModal.h"
#import "FFConnectionModal.h"
#import "FFFilerModals.h"
#import "FFBlockUserInfo.h"

/***************************************************************
 *                               External Class                               *
 ***************************************************************/


#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>
#import "ServiceHelper_AF3.h"
#import "NSDictionary+NullChecker.h"
#import "NSData+Base64.h"
#import "TOCropViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "PAPagination.h"
#import "AppDelegate.h"
/***************************************************************
 *                          Custom UI Component                       *
 ***************************************************************/
#import "FFTextField.h"
#import "FFTextView.h"

/***************************************************************
 *                               Custome Cells                               *
 ***************************************************************/
#import "FFMessageListTableCell.h"
#import "FFExploreCollectionViewCell.h"
#import "ImageCollectionViewCell.h"
#import "FFExploreSearchTableViewCell.h"
#import "FFFanzoneTableViewCell.h"
#import "FFFanzoneMultipleProfileCell.h"
#import "FFProfileCollectionCell.h"
#import "FFDetailTableViewCell.h"
#import "FFDetailTableViewCell.h"
#import "FFConnectionListCell.h"
#import "FFStylePointTableViewCell.h"
#import "FFPostCommentsTableViewCell.h"
#import "FFPostDescriptionTableViewCell.h"
#import "FFDarkroomCollectionViewCell.h"
#import "FFAddFlowCollectionViewCell.h"
#import "FFFlowTableViewCell.h"
#import "FFEditproTableViewCell.h"
#import "FFBlockUserTableViewCell.h"
#import "FFReportTableViewCell.h"
#import "FFPrivateAccountTableViewCell.h"
#import "FFInteractionHistoryCollectionViewCell.h"

#import "FFEditorialExploreTableViewCell.h"
#import "FFConnectUserTableViewCell.h"
#import "FFSelectedUserTableViewCell.h"



/***************************************************************
 *                               View Controller                               *
 ***************************************************************/


#import "FFMessagelistViewController.h"
#import "FFExploreViewController.h"
#import "ViewController.h"
#import "FFExploreViewController.h"
#import "FFFashionViewController.h"
#import "FFMainViewController.h"
#import "FFMessagelistViewController.h"
#import "FFMessageDecriptionViewController.h"
#import "FFMessageDiscriptionController.h"
#import "FFProfileViewController.h"
#import "StretchyHeaderCollectionViewLayout.h"
#import "FFHeader.h"
#import "FFprofileDetailViewController.h"
#import "FFUserDetailSectionHeader.h"
#import "FFConnectionListViewController.h"
#import "FFStylePointViewController.h"
#import "FFStylelistViewController.h"
#import "FFPostDetailViewController.h"
#import "FFPostDetailHeaderView.h"
#import "FFCameraViewController.h"
#import "FFImageViewController.h"
#import "FFImageColourPickerVC.h"
#import "SYEmojiPopover.h"
#import "FFDarkRoomViewController.h"
#import "FFCompileViewController.h"
#import "TempImageView.h"
#import "FFCaptionViewController.h"
#import "FFAddToFlowViewController.h"
#import "FFTextEditiorViewController.h"
#import "FFEditorialDetailViewController.h"
#import "FFSettingsViewController.h"
#import "FFEditProfileViewController.h"
#import "FFCreateFlowViewController.h"
#import "FFTextEditiorViewController.h"
#import "FFBlockUserViewController.h"
#import "FFTermsPolicyViewController.h"
#import "FFReportViewController.h"
#import "FFPrivateAccountViewController.h"
#import "FFGuideMeViewController.h"
#import "FFConnectionsViewController.h"
#import "FFLinkAccountViewController.h"
#import "FFInviteFriendsViewController.h"
#import "FFInteractionHistoryViewController.h"
#import "FFFiltersViewController.h"
#import "FFMembersViewController.h"
#import "FFSelectedUserViewController.h"
#import "FFDirectMessageContactList.h"
#import "FFMessageThreadViewController.h"
#import "FFOTPViewController.h"


#import "FFImageViewerViewController.h"

#endif /* Macro_h */

