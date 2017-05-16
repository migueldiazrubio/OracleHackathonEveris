//
//  NEOLAddress.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 17/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NEOLAddress : NSObject <NSCopying>
@property (strong, nonatomic) NSString *streetType;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *floor;
@property (strong, nonatomic) NSString *door;
@property (strong, nonatomic) NSString *stairway;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postcode;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *county;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *municipaly;

- (NSString *)completeAddress;
- (NSString *)addressFirstPart;
- (NSString *)addressSecondPart;


@end
