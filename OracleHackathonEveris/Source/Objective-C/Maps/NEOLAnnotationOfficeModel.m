//
//  NEOLAnnotationOfficeModel.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 02/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLAnnotationOfficeModel.h"
#import <CoreLocation/CoreLocation.h>
#import "Poi.h"


@implementation NEOLAnnotationOfficeModel

- (id)initWithOffice:(Poi* )office {
    self = [super init];
    if (self) {
        self.office = office;
        [self initializeSynthesizedProperties];
    }
    return self;
}

- (void)initializeSynthesizedProperties {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @".";
    
    NSNumber *numberLatitude = [numberFormatter numberFromString:self.office.latitude];
    NSNumber *numberLongitude = [numberFormatter numberFromString:self.office.longitude];
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    self.coordinate = CLLocationCoordinate2DMake(numberLatitude.doubleValue,
                                                 numberLongitude.doubleValue);
    self.title = self.office.address;
    self.subtitle = [self.office.address description];
}

@end
