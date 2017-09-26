//
//  PAPagination.h
//  PropertyApp
//
//  Created by Ankit Kumar Gupta on 04/08/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAPagination : NSObject


@property (nonatomic, strong) NSString  *pageNo;
@property (nonatomic, strong) NSString  *maxPageNo;
@property (nonatomic, strong) NSString  *pageSize;
@property (nonatomic, strong) NSString  *totalNumberOfRecords;

+(PAPagination *)getPaginationInfoFromDict : (NSDictionary *)data;

@end
