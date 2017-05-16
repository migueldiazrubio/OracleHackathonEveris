//
//  NEOLAnnotationOfficeModel.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 02/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "NEOLOffice.h"

@interface NEOLAnnotationOfficeModel : NSObject <MKAnnotation>

// Inherited from MKAnnotationProtocol
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NEOLOffice *office;

- (id)initWithOffice:(NEOLOffice *)office;

@end
