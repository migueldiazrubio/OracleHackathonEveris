//
//  NEOLAddress.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 17/06/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLAddress.h"

@implementation NEOLAddress

- (NSString *)completeAddress {
    NSMutableString *completeAddress = [NSMutableString string];
    if (self.streetType.length > 0) {
        //[completeAddress appendFormat:@"%@", [[[NEOLStaticDataManager sharedInstance] streetType][self.streetType] capitalizedString] ? : [self.streetType capitalizedString] ];
    }
    if (self.street.length > 0 && self.number.length > 0) {
        [completeAddress appendFormat:@" %@ %@,", [self.street capitalizedString], [self.number capitalizedString]];
    }
    if (self.stairway. length> 0) {
        [completeAddress appendFormat:@" esc %@", [self.stairway capitalizedString]];
    }
    if (self.floor.length > 0) {
        [completeAddress appendFormat:@" %@", self.floor];
    }
    if (self.door.length > 0) {
        [completeAddress appendFormat:@"-%@", [self.door capitalizedString]];
    }
    if (self.postcode.length > 0) {
        [completeAddress appendFormat:@" %@", [self.postcode capitalizedString]];
    }
    if (self.city.length > 0) {
        [completeAddress appendFormat:@" %@", [self.city capitalizedString]];
    }
    if (self.county.length > 0) {
        [completeAddress appendFormat:@" (%@)", [self.county capitalizedString]];
    }
    if (self.country.length > 0) {
        [completeAddress appendFormat:@" %@", [self.country uppercaseString]];
    }
    return [NSString stringWithString:completeAddress];
}

- (NSString *)description {
    return [self completeAddress];
}

- (id)copyWithZone:(NSZone *)zone
{
    NEOLAddress *copy = [[NEOLAddress alloc] init];
    if (copy) {
        // Copy NSObject subclasses
        copy.streetType = self.streetType;
        copy.street = self.street;
        copy.number = self.number;
        copy.floor = self.floor;
        copy.door = self.door;
        copy.stairway = self.stairway;
        copy.city = self.city;
        copy.postcode = self.postcode;
        copy.region = self.region;
        copy.county = self.county;
        copy.country = self.country;
    }
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[NEOLAddress class]]) {
        NEOLAddress *address = (NEOLAddress *)object;
        if (self.streetType && address.streetType) {
            if (![self.streetType isEqual:address.streetType]) return NO;
        }
        if (self.street && address.street) {
            if (![self.street isEqual:address.street]) return NO;
        }
        if (self.number && address.number) {
            if (![self.number isEqual:address.number]) return NO;
        }
        if (self.floor && address.floor) {
            if (![self.floor isEqual:address.floor]) return NO;
        }
        if (self.door && address.door) {
            if (![self.door isEqual:address.door]) return NO;
        }
        if (self.stairway && address.stairway) {
            if (![self.stairway isEqual:address.stairway]) return NO;
        }
        if (self.city && address.city) {
            if (![self.city isEqual:address.city]) return NO;
        }
        if (self.postcode && address.postcode) {
            if (![self.postcode isEqual:address.postcode]) return NO;
        }
        if (self.region && address.region) {
            if (![self.region isEqual:address.region]) return NO;
        }
        if (self.county && address.county) {
            if (![self.county isEqual:address.county]) return NO;
        }
        if (self.country && address.country) {
            if (![self.country isEqual:address.country]) return NO;
        }
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)addressFirstPart {
    NSMutableString *completeAddress = [NSMutableString string];
    if (self.streetType.length > 0) {
       // [completeAddress appendFormat:@"%@", [[[NEOLStaticDataManager sharedInstance] streetType][self.streetType] capitalizedString] ? : [self.streetType capitalizedString] ];
    }
    if (self.street.length > 0 && self.number.length > 0) {
        [completeAddress appendFormat:@" %@, %@", [self.street capitalizedString], [self.number capitalizedString]];
    }
    if (self.stairway.length> 0) {
        [completeAddress appendFormat:@", esc %@", [self.stairway capitalizedString]];
    }
    if (self.floor.length > 0) {
        [completeAddress appendFormat:@", %@", self.floor];
    }
    if (self.door.length > 0) {
        [completeAddress appendFormat:@"-%@", [self.door capitalizedString]];
    }

    return [NSString stringWithString:completeAddress];
   
}

- (NSString *)addressSecondPart {
    NSMutableString *completeAddress = [NSMutableString string];
    if (self.postcode.length > 0) {
        [completeAddress appendFormat:@"%@", [self.postcode capitalizedString]];
    }
    if (self.city.length > 0) {
        [completeAddress appendFormat:@" %@", [self.city capitalizedString]];
    }
    
    return [NSString stringWithString:completeAddress];
   
}

@end
