//
//  FFMessageModal.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 30/03/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFMessageModal.h"
#import "Macro.h"

@implementation FFMessageModal

+(FFMessageModal*)userMessageList:(NSDictionary *)userMessageDict {
    
    FFMessageModal *tempUserMessageInfo = [[FFMessageModal alloc] init];
    tempUserMessageInfo.chatArray = [NSMutableArray array];
    
    NSArray *chatTempArray = [userMessageDict objectForKeyNotNull:KChat expectedObj:[NSArray array]];
    
    tempUserMessageInfo.otherUserId = [userMessageDict objectForKeyNotNull:KOtheruserID expectedObj:@""];
    tempUserMessageInfo.userName = [userMessageDict objectForKeyNotNull:KUserName expectedObj:@""];
    tempUserMessageInfo.displayName = [userMessageDict objectForKeyNotNull:kContactDisplayName expectedObj:@""];
    tempUserMessageInfo.firstName = [userMessageDict objectForKeyNotNull:KFirstName expectedObj:@""];
    tempUserMessageInfo.lastName = [userMessageDict objectForKeyNotNull:KLastName expectedObj:@""];
    tempUserMessageInfo.userProfileImage = [userMessageDict objectForKeyNotNull:KProfilePicture expectedObj:@""];
    tempUserMessageInfo.textMessage = [userMessageDict objectForKeyNotNull:KMessages expectedObj:@""];
    tempUserMessageInfo.imageUrl = [userMessageDict objectForKeyNotNull:KMessagesImage expectedObj:@""];
    tempUserMessageInfo.isRead = [userMessageDict objectForKeyNotNull:KIsRead expectedObj:@""];
    tempUserMessageInfo.userConnectionStatus = [userMessageDict objectForKeyNotNull:KUserConnectionStatus expectedObj:@""];
    tempUserMessageInfo.messageTitle = [userMessageDict objectForKeyNotNull:KTitle expectedObj:@""];
    tempUserMessageInfo.stylePoints = [userMessageDict objectForKeyNotNull:KStylePoints expectedObj:@""];

    for (NSDictionary *tempDict in chatTempArray) {
        
        FFMessageModal *tempUserChatInfo = [[FFMessageModal alloc] init];
        
        tempUserChatInfo.senderID = [tempDict objectForKeyNotNull:KSenderId expectedObj:@""];
        tempUserChatInfo.senderName = [tempDict objectForKeyNotNull:KSenderName expectedObj:@""];
        tempUserChatInfo.senderImage = [tempDict objectForKeyNotNull:KSenderImage expectedObj:@""];
        tempUserChatInfo.receiverID = [tempDict objectForKeyNotNull:KReceiverID expectedObj:@""];
        tempUserChatInfo.receiverName = [tempDict objectForKeyNotNull:KReceiverName expectedObj:@""];
        tempUserChatInfo.receiverImage = [tempDict objectForKeyNotNull:KRecieverImage expectedObj:@""];
        tempUserChatInfo.sendFrom = [tempDict objectForKeyNotNull:KSendFrom expectedObj:@""];
        tempUserChatInfo.message = [tempDict objectForKeyNotNull:KMessages expectedObj:@""];
        tempUserChatInfo.status = [tempDict objectForKeyNotNull:KStatus expectedObj:@""];
        tempUserChatInfo.message_id = [tempDict objectForKeyNotNull:KMessageID expectedObj:@""];
        tempUserChatInfo.imageUrl = [tempDict objectForKeyNotNull:KMessagesImage expectedObj:@""];
        tempUserChatInfo.isRead = [tempDict objectForKeyNotNull:KIsRead expectedObj:@""];
        tempUserChatInfo.messageTitle = [tempDict objectForKeyNotNull:KTitle expectedObj:@""];
        tempUserChatInfo.stylePoints = [tempDict objectForKeyNotNull:KStylePoints expectedObj:@""];

        [tempUserMessageInfo.chatArray addObject:tempUserChatInfo];

    }

    return tempUserMessageInfo;
}


+(FFMessageModal*)userThreadList:(NSDictionary *)tempDict {
    
    FFMessageModal *tempUserChatInfo = [[FFMessageModal alloc] init];
    
    tempUserChatInfo.senderID = [tempDict objectForKeyNotNull:KSenderId expectedObj:@""];
    tempUserChatInfo.senderName = [tempDict objectForKeyNotNull:KSenderName expectedObj:@""];
    tempUserChatInfo.senderImage = [tempDict objectForKeyNotNull:KSenderImage expectedObj:@""];
    tempUserChatInfo.receiverID = [tempDict objectForKeyNotNull:KReceiverID expectedObj:@""];
    tempUserChatInfo.receiverName = [tempDict objectForKeyNotNull:KReceiverName expectedObj:@""];
    tempUserChatInfo.receiverImage = [tempDict objectForKeyNotNull:KRecieverImage expectedObj:@""];
    tempUserChatInfo.sendFrom = [tempDict objectForKeyNotNull:KSendFrom expectedObj:@""];
    tempUserChatInfo.message = [tempDict objectForKeyNotNull:KMessages expectedObj:@""];
    tempUserChatInfo.status = [tempDict objectForKeyNotNull:KStatus expectedObj:@""];
    tempUserChatInfo.stylePoints = [tempDict objectForKeyNotNull:KStylePoints expectedObj:@""];
    tempUserChatInfo.imageUrl = [tempDict objectForKeyNotNull:KMessagesImage expectedObj:@""];
 return tempUserChatInfo;
}



+(FFMessageModal*)allUserList:(NSDictionary *)userDict {
    
    FFMessageModal *tempUserMessageInfo = [[FFMessageModal alloc] init];
    tempUserMessageInfo.otherUserId = [userDict objectForKeyNotNull:KUserIdContactList expectedObj:@""];
    tempUserMessageInfo.displayName = [userDict objectForKeyNotNull:kContactDisplayName expectedObj:@""];
    tempUserMessageInfo.userProfileImage = [userDict objectForKeyNotNull:KProfilePicture expectedObj:@""];
   return tempUserMessageInfo;
}
@end
