//
//  UIImageView+SetImageWithURL.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/16.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (SetImageWithURL)


- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage;
- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage completed:(void(^)(void))completeBlock;

@end
