//
//  FFMessageModal.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 30/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFMessageModal : NSObject

@property (nonatomic, strong) NSString * message_id;
@property (nonatomic, strong) NSString * textMessage;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * vedioURL;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * stylePoints;
@property (nonatomic, strong) NSString * userProfileImage;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * messageTitle;



@property (nonatomic, strong) NSString * senderID;
@property (nonatomic, strong) NSString * senderName;
@property (nonatomic, strong) NSString * senderImage;
@property (nonatomic, strong) NSString * receiverID;
@property (nonatomic, strong) NSString * receiverName;
@property (nonatomic, strong) NSString * receiverImage;
@property (nonatomic, strong) NSString * sendFrom;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * isRead;
@property (nonatomic, strong) NSString * userConnectionStatus;


@property (nonatomic, strong) NSString * otherUserId;
@property (nonatomic, strong) NSString * displayName;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;


@property (nonatomic, strong) NSMutableArray * chatArray;

+(FFMessageModal*)userMessageList:(NSDictionary *)userMessageDict;
+(FFMessageModal*)allUserList:(NSDictionary *)userDict;
//+(FFMessageModal*)oneToOneChatListList:(NSDictionary *)userMessageDict;

+(FFMessageModal*)userThreadList:(NSDictionary *)tempDict;

@end
