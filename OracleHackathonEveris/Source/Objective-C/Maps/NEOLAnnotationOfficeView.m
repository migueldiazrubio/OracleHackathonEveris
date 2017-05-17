//
//  NEOLAnnotationOfficeView.m
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 02/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import "NEOLAnnotationOfficeView.h"
#import "OracleHackathonEveris-swift.h"

#define kPOITypeOffice  @"0"
#define kPOITypeGarage  @"1"

@implementation NEOLAnnotationOfficeView

@synthesize annotation = _annotation;
@synthesize coordinate = _coordinate;

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    _annotation = annotation;
    NEOLAnnotationOfficeModel *annotationOffice = (NEOLAnnotationOfficeModel *)annotation;
    if ([annotationOffice.office.status isEqualToString:kPOITypeOffice]) {
        self.image =[UIImage imageNamed:@"offices_poid_office"];
    } else if ([annotationOffice.office.status isEqualToString:kPOITypeGarage]) {
        self.image = [UIImage imageNamed:@"offices_poid_garage"];
    }else{
        self.image = [UIImage imageNamed:@"offices_img_point"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NEOLAnnotationOfficeModel *annotationOffice = (NEOLAnnotationOfficeModel *)self.annotation;
    if ([annotationOffice.office.status isEqualToString:kPOITypeOffice]) {
        self.image = selected ? [UIImage imageNamed:@"offices_poid_office_on"] : [UIImage imageNamed:@"offices_poid_office"];
    } else if ([annotationOffice.office.status isEqualToString:kPOITypeGarage]) {
        self.image = selected ? [UIImage imageNamed:@"offices_poid_garage_on"] : [UIImage imageNamed:@"offices_poid_garage"];
    }else{
        self.image = selected ? [UIImage imageNamed:@"offices_img_point"] : [UIImage imageNamed:@"offices_img_point"];
    }
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
}

@end
