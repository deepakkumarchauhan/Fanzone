//
//  FFConnectionModal.h
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFConnectionModal : NSObject
//recent
@property (nonatomic, strong) NSString *  iconStatus;
@property (nonatomic, strong) NSString *  userID;
@property (nonatomic, strong) NSString *  message;
@property (nonatomic, strong) NSString *  profilePicture;
//connection
@property (nonatomic, strong) NSString *  displayName;
@property (nonatomic, strong) NSString *  firstName;
@property (nonatomic, strong) NSString *  lastName;
@property (nonatomic, strong) NSString *  otherUserID;
@property (nonatomic, strong) NSString *  userName;

@property (nonatomic, assign) BOOL   isSelect;


//StylePoints

@property (nonatomic, strong) NSString *  stylePointCount;



+(NSMutableArray*)parseConenctionRecentData:(NSDictionary *)response;
+(NSMutableArray*)parseConenctionData:(NSDictionary *)response;
+(NSMutableArray*)parseConenctionFollowersData:(NSDictionary *)response;
+(NSMutableArray*)parseRecentstylePointData:(NSDictionary*)response;
+(NSMutableArray*)parseRecievedStylePointData:(NSDictionary*)response;
+(NSMutableArray*)parseGivenStylePointData:(NSDictionary*)response;
@end
