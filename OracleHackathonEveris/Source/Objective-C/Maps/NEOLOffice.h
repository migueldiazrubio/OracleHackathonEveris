//
//  NEOLOffice.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 17/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "NEOLAddress.h"

@interface NEOLOffice : NSObject
@property (nonatomic, strong) NSString *officeId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic,strong) NSString *streetAddress; //Used a temp var to fill "physicalAddress" after using converter
@property (nonatomic, strong) NEOLAddress *physicalAddress;
@end
