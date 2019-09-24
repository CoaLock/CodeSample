//
//  UIImage+Custom.h
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/22.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

- (UIImage*)antialiasedImage;

+ (UIImage*)getHumbnailImage:(UIImage*)image scaledToSize:(CGSize)size;

+ (UIImage*)getImage:(UIImage*)image withColor:(UIColor*)color;


- (UIImage *)imageWithColor:(UIColor *)color;


@end
