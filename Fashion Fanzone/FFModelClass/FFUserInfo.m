//
//  FFUserInfo.m
//  Fashion Fanzone
//
//  Created by Ratneshwar Singh on 3/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFUserInfo.h"
#import "Macro.h"

@implementation FFUserInfo



+(FFUserInfo*)userDetail:(NSDictionary *)userDict {
    
    FFUserInfo *tempUserInfo = [[FFUserInfo alloc] init];
    
    return tempUserInfo;
}

+(FFUserInfo *)userInfoGetPrivateAccountResponse:(NSDictionary*)dict {
    
    
    FFUserInfo *tempInfo = [[FFUserInfo alloc]init];
    
    tempInfo.userId = [dict objectForKeyNotNull:KUser_ID expectedObj:@""];
    tempInfo.connectionType = [dict objectForKeyNotNull:KType expectedObj:@""];
    tempInfo.connection = [dict objectForKeyNotNull:KConnection expectedObj:@""];
    tempInfo.none = [dict objectForKeyNotNull:KNone expectedObj:@""];
    tempInfo.every = [dict objectForKeyNotNull:KEvery expectedObj:@""];
    
    tempInfo.name = [dict objectForKeyNotNull:KName expectedObj:@""];

    
    return tempInfo;
}
@end
