//
//  UIColor+HexColor.h
//  BBVAZenit
//
//  Created by Alexis Santos Pérez on 27/08/12.
//  Copyright (c) 2012 Ameu8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (HexColor)
+ (UIColor*) colorWithHexString:(NSString *)hex;
+ (UIColor*) colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;



+(UIColor *) popularDarkBlue;
+(UIColor *) popularTurquoise;
+(UIColor *) popularRed;
+(UIColor *) popularGrey;
+(UIColor *) popularGreyDark;
+(UIColor *) popularSelectedGrey;
+(UIColor *) popularLightGrey;


@end
