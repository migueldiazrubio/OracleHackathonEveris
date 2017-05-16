//
//  NEOLMockRequestManager.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 22/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLMockRequestManager.h"
#import "NEOLOffice.h"
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

+ (NSArray *)mockLocateOfficesRequest {
    NEOLAddress *address1 = [[NEOLAddress alloc] init];
    address1.streetType = @"Avenida";
    address1.street = @"Manoteras";
    address1.number = @"32";
    address1.floor = @"5";
    address1.postcode = @"28050";
    address1.city = @"Madrid";
    address1.region = @"Madrid";
    address1.country = @"SPAIN";
    
    NEOLOffice *office1 = [[NEOLOffice alloc] init];
    office1.officeId = @"1";
    office1.type = kPOITypeGarage;
    office1.latitude = @"40.488025";
    office1.longitude = @"-3.665616";
    office1.name = @"Oficina Primera";
    office1.physicalAddress = address1;

    NEOLAddress *address2 = [[NEOLAddress alloc] init];
    address2.streetType = @"Avenida";
    address2.street = @"Manoteras";
    address2.number = @"52";
    address2.floor = @"6";
    address2.postcode = @"28050";
    address2.city = @"Madrid";
    address2.region = @"Madrid";
    address2.country = @"SPAIN";
    
    NEOLOffice *office2 = [[NEOLOffice alloc] init];
    office2.officeId = @"2";
    office2.type = kPOITypeOffice;
    office2.latitude = @"40.487502";
    office2.longitude = @"-3.661755";
    office2.name = @"Oficina Segunda";
    office2.physicalAddress = address2;
    
    NEOLAddress *address3 = [[NEOLAddress alloc] init];
    address3.streetType = @"Avenida";
    address3.street = @"General Perón";
    address3.number = @"10";
    address3.floor = @"1";
    address3.postcode = @"28020";
    address3.city = @"Madrid";
    address3.region = @"Madrid";
    address3.country = @"SPAIN";
    
    NEOLOffice *office3 = [[NEOLOffice alloc] init];
    office3.officeId = @"3";
    office3.type = kPOITypeOffice;
    office3.latitude = @"40.452473";
    office3.longitude = @"-3.698075";
    office3.name = @"Oficina Tercera";
    office3.physicalAddress = address3;
    
    NEOLAddress *address4 = [[NEOLAddress alloc] init];
    address4.streetType = @"Calle";
    address4.street = @"General Moscardó";
    address4.number = @"10";
    address4.floor = @"2";
    address4.postcode = @"28020";
    address4.city = @"Madrid";
    address4.region = @"Madrid";
    address4.country = @"SPAIN";
    
    NEOLOffice *office4 = [[NEOLOffice alloc] init];
    office4.officeId = @"4";
    office4.type = kPOITypeGarage;
    office4.latitude = @"40.447578";
    office4.longitude = @"-3.696885";
    office4.name = @"Oficina Cuarta";
    office4.physicalAddress = address4;
    
    return @[office1, office2, office3, office4];
}




@end
