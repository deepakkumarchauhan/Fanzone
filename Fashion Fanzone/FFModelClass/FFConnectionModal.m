//
//  FFConnectionModal.m
//  Fashion Fanzone
//
//  Created by Chandra Prakash on 06/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFConnectionModal.h"
#import "NSDictionary+NullChecker.h"
#import "Macro.h"
@implementation FFConnectionModal



+(NSMutableArray*)parseConenctionRecentData:(NSDictionary *)response
{
    
    NSArray * recentarray = [response valueForKey:@"recentList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in recentarray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.iconStatus = [NSString stringWithFormat:@"%@", dict[@"iconStatus"]];
        modal.message = [NSString stringWithFormat:@"%@", dict[@"message"]];
        modal.profilePicture = [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        NSString * userid = [NSString stringWithFormat:@"%@", dict[@"myFollowerID"]];
        if (userid==nil) {
            userid = [NSString stringWithFormat:@"%@", dict[@"connectedUserID"]];
        }
        modal.userID = userid;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}

+(NSMutableArray*)parseConenctionData:(NSDictionary *)response
{
    NSArray * connectionarray = [response valueForKey:@"connectionsList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in connectionarray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.displayName = [NSString stringWithFormat:@"%@", dict[@"displayName"]];
        modal.firstName = [NSString stringWithFormat:@"%@", dict[@"firstName"]];
        modal.lastName = [NSString stringWithFormat:@"%@", dict[@"lastName"]];
        modal.profilePicture = [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        modal.userName = [NSString stringWithFormat:@"%@", dict[@"userName"]];
        NSString * userid = [NSString stringWithFormat:@"%@", dict[@"otherUserID"]];
        modal.otherUserID = userid;
        modal.isSelect = NO;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}
+(NSMutableArray*)parseConenctionFollowersData:(NSDictionary *)response
{
    NSArray * connectionFollowersarray = [response valueForKey:@"followersList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in connectionFollowersarray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.displayName = [NSString stringWithFormat:@"%@", dict[@"displayName"]];
        modal.firstName = [NSString stringWithFormat:@"%@", dict[@"firstName"]];
        modal.lastName = [NSString stringWithFormat:@"%@", dict[@"lastName"]];
        modal.profilePicture = [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        modal.userName = [NSString stringWithFormat:@"%@", dict[@"userName"]];
        NSString * userid = [NSString stringWithFormat:@"%@", dict[@"myFollowerID"]];
        modal.otherUserID = userid;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}

//parse recent style point data-


+(NSMutableArray*)parseRecentstylePointData:(NSDictionary*)response
{
    NSArray * recentStylePointArray = [response valueForKey:@"recentList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in recentStylePointArray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.iconStatus =  [dict objectForKeyNotNull:@"iconStatus" expectedObj:@""];//            [NSString stringWithFormat:@"%@", dict[@"iconStatus"]];
        modal.message =      [dict objectForKeyNotNull:@"message" expectedObj:@""];//                       [NSString stringWithFormat:@"%@", dict[@"message"]];
        modal.profilePicture = [dict objectForKeyNotNull:@"profilePicture" expectedObj:@""];//  [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        modal.stylePointCount = [dict objectForKeyNotNull:@"connectedStylePoints" expectedObj:@""];//[NSString stringWithFormat:@"%@", dict[@"connectedStylePoints"]];
        NSString * userid = [dict objectForKeyNotNull:@"connectedUserID" expectedObj:@""];//[NSString stringWithFormat:@"%@", dict[@"connectedUserID"]];
        modal.otherUserID = userid;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}

//parse recent style point data-


+(NSMutableArray*)parseGivenStylePointData:(NSDictionary*)response
{
    NSArray * recentStylePointArray = [response valueForKey:@"connectionsList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in recentStylePointArray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.displayName = [NSString stringWithFormat:@"%@", dict[@"displayName"]];
        modal.message = [NSString stringWithFormat:@"%@-%@", dict[@"displayName"], dict[@"activityType"]];
        modal.profilePicture = [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        modal.stylePointCount = [NSString stringWithFormat:@"%@", dict[@"stylePoints"]];
        modal.firstName = [NSString stringWithFormat:@"%@", dict[@"firstName"]];
        modal.lastName = [NSString stringWithFormat:@"%@", dict[@"lastName"]];
        NSString * userid = [NSString stringWithFormat:@"%@", dict[@"otherUserID"]];
        modal.otherUserID = userid;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}



//parse Recieved style point data-


+(NSMutableArray*)parseRecievedStylePointData:(NSDictionary*)response
{
    NSArray * recentStylePointArray = [response valueForKey:@"connectionsList"];
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSDictionary * dict in recentStylePointArray) {
        FFConnectionModal * modal = [[FFConnectionModal alloc] init];
        modal.displayName = [NSString stringWithFormat:@"%@", dict[@"displayName"]];
        modal.message = [NSString stringWithFormat:@"%@-%@", dict[@"displayName"], dict[@"activityType"]];
        modal.profilePicture = [NSString stringWithFormat:@"%@", dict[@"profilePicture"]];
        modal.stylePointCount = [NSString stringWithFormat:@"%@", dict[@"stylePoints"]];
        modal.firstName = [NSString stringWithFormat:@"%@", dict[@"firstName"]];
        modal.lastName = [NSString stringWithFormat:@"%@", dict[@"lastName"]];
        NSString * userid = [NSString stringWithFormat:@"%@", dict[@"otherUserID"]];
        modal.otherUserID = userid;
        
        [tempArray addObject:modal];
    }
    return tempArray;
}
@end
