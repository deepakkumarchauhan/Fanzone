//
//  FFBlockUserInfo.h
//  Fashion Fanzone
//
//  Created by Deepak Chauhan on 15/06/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFBlockUserInfo : NSObject

+(FFBlockUserInfo *)blockUserListFromResponse:(NSDictionary*)dictTemp;

@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *blockId;


@end
