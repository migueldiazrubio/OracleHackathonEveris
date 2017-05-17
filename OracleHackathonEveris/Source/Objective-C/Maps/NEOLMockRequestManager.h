//
//  NEOLMockRequestManager.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 22/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NEOLUser;
@class NEOLContractValidationResponse;

@interface NEOLMockRequestManager : NSObject

+ (NEOLUser *)mockUserInfoRequest;

@end
