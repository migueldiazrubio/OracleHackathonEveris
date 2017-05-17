//
//  MKMapView+ZoomLevel.h
//  MapKitExample
//
//  Created by ameu8 on 13/03/13.
//  Copyright (c) 2013 ameu8. All rights reserved.
//

#import <MapKit/MapKit.h>

#define kNO_ZOOM_LEVEL  -1

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (int) getZoomLevel;

@end
