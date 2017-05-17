//
//  NEOLMockRequestManager.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 22/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLMockRequestManager.h"
#import "UserInfo.h"

#define kPOITypeOffice  @"OFICINA"
#define kPOITypeGarage  @"PDS"

@implementation NEOLMockRequestManager

+ (UserInfo*)mockUserInfoRequest{
     UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.userId = @"1";
    userInfo.name = @"Usuario 1";
    userInfo.pass = @"";
    
    return userInfo;
}

@end
