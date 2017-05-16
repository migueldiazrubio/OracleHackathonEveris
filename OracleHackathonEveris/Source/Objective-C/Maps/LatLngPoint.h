//
//  LatLongPoint.h
//  NEOL
//
//  Created by Jose Miguel Benedicto Ruiz on 04/07/14.
//  Copyright (c) 2014 ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface LatLngPoint : NSObject
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic, strong) NSString *formatedAddress;

@end
