//
//  PAPagination.m
//  PropertyApp
//
//  Created by Ankit Kumar Gupta on 04/08/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "PAPagination.h"
#import "Macro.h"

@implementation PAPagination


+(PAPagination *)getPaginationInfoFromDict : (NSDictionary *)data {
    
    PAPagination *page = [[PAPagination alloc] init];
    page.pageNo = [data objectForKeyNotNull:@"pageNo" expectedObj:@""];
   // page.pageSize = [data objectForKeyNotNull:pageSize expectedObj:@"0"];
    page.maxPageNo = [data objectForKeyNotNull:@"totalPages" expectedObj:@""];
   // page.totalNumberOfRecords = [data objectForKeyNotNull:PARAM_TotalNoRecords expectedObj:@"0"];
    
    return page;
}


@end
