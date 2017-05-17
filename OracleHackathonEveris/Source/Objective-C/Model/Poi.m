//
//  Poi.m
//  OracleHackathonEveris
//
//  Created by Paul Alava Doncel on 17/5/17.
//  Copyright © 2017 everis. All rights reserved.
//

#import "Poi.h"

@implementation Poi

-(void)initWithIdentifier:(NSString*) identificator latitude:(NSString*)latitude longitude: (NSString*) longitude status: (NSString*) status requestTimestamp: (NSString*) requestTimestamp deliveryTimestamp: (NSString*)deliveryTimestamp  address: (NSString*) address deliveredBy: (NSString*) deliveredBy{
    self.identificator = identificator;
    self.latitude = latitude;
    self.longitude = longitude;
    self.status = status;
    self.requestTimestamp = requestTimestamp;
    self.deliveryTimestamp = deliveryTimestamp;
    self.address = address;
    self.deliveredBy = deliveredBy;
}


@end
