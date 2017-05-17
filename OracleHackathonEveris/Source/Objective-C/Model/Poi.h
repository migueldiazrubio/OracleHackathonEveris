//
//  Poi.h
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 17/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Poi : NSObject

@property (nonatomic, strong) NSString *identificator;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *requestTimestamp;
@property (nonatomic, strong) NSString *deliveryTimestamp;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *deliveredBy;

-(void)initWithIdentifier:(NSInteger) identificator latitude:(NSString*)latitude longitude: (NSString*) longitude status: (NSString*) status requestTimestamp: (NSString*) requestTimestamp deliveryTimestamp: (NSString*)deliveryTimestamp  address: (NSString*) address deliveredBy: (NSString*) deliveredBy;

@end
