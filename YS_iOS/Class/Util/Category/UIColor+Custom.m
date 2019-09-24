//
//  UIColor+Custom.m
//  Utils
//
//  Created by 崔露凯 on 15/10/26.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor*)appCustomMainColor {

    static dispatch_once_t onceToken;

    static UIColor *mainColor = nil;
    dispatch_once(&onceToken, ^{
       
        CGFloat r = (arc4random()%200 +50)%200/255.0;
        CGFloat g = (arc4random()%200 +50)%200/255.0;
        CGFloat b = (arc4random()%200 +50)%200/255.0;
        
        mainColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    });
    
    // 232427
    NSInteger style = [[Singleton sharedManager].app_style integerValue];
    if (style == 2) {
        
        // 黑色色值
        return [UIColor colorWithHexString:@"#232427"];
        
        // 红色
        // [UIColor colorWithHexString:@"#E3556A"];
    }
    
    return [UIColor colorWithHexString:@"#F1CBBE"];
}


+ (UIColor*)appNavBarMainColor {

    NSInteger style = [[Singleton sharedManager].app_style integerValue];
    if (style == 2) {
        
        // 黑色色值  #232427
      //  return [UIColor colorWithHexString:@"#232427"];
    }
    
    return [UIColor whiteColor];
}

+ (UIColor*)appNavBarBgColor {

    NSInteger style = [[Singleton sharedManager].app_style integerValue];
    if (style == 2) {
        
        // 黑色色值  #232427
        return [UIColor colorWithHexString:@"#232427"];
    }
    
    return [UIColor colorWithHexString:@"#F1CBBE"];
}


+ (UIColor*)appTabbarMainColor {

    NSInteger style = [[Singleton sharedManager].app_style integerValue];
    if (style == 2) {
        
        // 黑色色值  #232427
        return [UIColor colorWithHexString:@"#232427"];
    }
    
    return [UIColor colorWithHexString:@"#F1CBBE"];
}

+ (UIColor*)appTabbarBgColor {

    return [UIColor whiteColor];
}




+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return [UIColor whiteColor];
    }
    
    //    if ([cString hasPrefix:@"#FF"])
    //    {
    //        cString = [cString substringFromIndex:3];
    //    }
    //    else if ([cString hasPrefix:@"#"])
    //    {
    cString = [cString substringFromIndex:1];
    //    }
    
    if ([cString length] != 6)
    {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    UIColor *resultColor = RGB(r, g, b);
    
    return resultColor;
}

+ (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha {

    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

@end
