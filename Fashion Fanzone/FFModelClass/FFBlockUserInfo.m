//
//  FFBlockUserInfo.m
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 15/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FFBlockUserInfo.h"
#import "Macro.h"

@implementation FFBlockUserInfo



+(FFBlockUserInfo *)blockUserListFromResponse:(NSDictionary*)dictTemp {

    FFBlockUserInfo *blockInfo = [[FFBlockUserInfo alloc]init];
    
    blockInfo.email = [dictTemp objectForKeyNotNull:KUserEmail expectedObj:@""];
    
    return blockInfo;
    
}
@end
