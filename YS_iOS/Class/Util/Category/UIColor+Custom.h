//
//  UIColor+Custom.h
//  Utils
//
//  Created by 崔露凯 on 15/10/26.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface UIColor (Custom)

/**  app主要颜色，包含:导航栏，底部tabbar等 */
+ (UIColor*)appCustomMainColor;

+ (UIColor*)appTabbarMainColor;

+ (UIColor*)appTabbarBgColor;

+ (UIColor*)appNavBarMainColor;

+ (UIColor*)appNavBarBgColor;






//16进制转换为UIColor
+ (UIColor*)colorWithHexString:(NSString *)hexString;

+ (UIImage*)createImageWithColor:(UIColor*)color;

//给UIColor添加透明度
+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha;

@end


