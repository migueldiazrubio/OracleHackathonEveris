//
//  NEOLAnnotationOfficeView.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 02/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "NEOLAnnotationOfficeModel.h"

@interface NEOLAnnotationOfficeView : MKAnnotationView <MKAnnotation>


-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
