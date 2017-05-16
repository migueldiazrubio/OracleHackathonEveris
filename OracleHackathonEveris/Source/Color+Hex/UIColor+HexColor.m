//
//  UIColor+HexColor.m
//  BBVAZenit
//
//  Created by Alexis Santos Pérez on 27/08/12.
//  Copyright (c) 2012 Ameu8. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)


/**
 * Get a color from an hex string
 * @param hex - NSString text with the color
 * @return UIColor - color returned from string
 **/
+ (UIColor*) colorWithHexString:(NSString *)hex {
    return [UIColor colorWithHexString:hex alpha:1.0];
}

/**
 * Get a color from an hex string and alpha
 * @param hex - NSString text with the color
 * @param alpha - CGFloat alpha of color
 * @return UIColor - color returned from string
 **/
+ (UIColor*) colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];  
    
    // String should be 6 or 8 characters  
    if ([cString length] < 6) return [UIColor grayColor];  
    
    // strip 0X if it appears  
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];  
    
    if ([cString length] != 6) return  [UIColor grayColor];  
    
    // Separate into r, g, b substrings  
    NSRange range;  
    range.location = 0;  
    range.length = 2;  
    NSString *rString = [cString substringWithRange:range];  
    
    range.location = 2;  
    NSString *gString = [cString substringWithRange:range];  
    
    range.location = 4;  
    NSString *bString = [cString substringWithRange:range];  
    
    // Scan values  
    unsigned int r, g, b;  
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  
    [[NSScanner scannerWithString:gString] scanHexInt:&g];  
    [[NSScanner scannerWithString:bString] scanHexInt:&b];  
    
    return [UIColor colorWithRed:((float) r / 255.0f)  
                           green:((float) g / 255.0f)  
                            blue:((float) b / 255.0f)  
                           alpha:alpha];
}


/**
 * GAMA COLORES POPULAR
**/

+(UIColor *) popularDarkBlue{
    
    return [UIColor colorWithHexString:@"002668"];
    
}

+(UIColor *) popularTurquoise

{
    return [UIColor colorWithHexString:@"47BBB8"];

    
}

+(UIColor *) popularGrey

{
    return [UIColor colorWithHexString:@"616161"];
    
    
}

+(UIColor *) popularLightGrey

{
    return [UIColor colorWithHexString:@"F9F9F9"];


}

+(UIColor *) popularSelectedGrey

{
    return [UIColor colorWithHexString:@"ECECEC"];

    
}

+(UIColor *) popularGreyDark

{
    return [UIColor colorWithHexString:@"333333"];
    
    
}


+(UIColor *) popularRed

{
    return [UIColor colorWithHexString:@"FF4F4E"];
    
    
}

@end
