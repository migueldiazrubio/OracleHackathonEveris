//
//  GGeocodeResponse.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 04/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGeocodeResponse : NSObject
@property (nonatomic, strong) NSMutableArray *positions; // [LatLongPoint]
@end
