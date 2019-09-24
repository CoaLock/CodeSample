//
//  UIImageView+SetImageWithURL.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/16.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UIImageView+SetImageWithURL.h"
#import <SDWebImage/UIImageView+WebCache.h>

static char *imageLoaded;

@implementation UIImageView (SetImageWithURL)

- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage {
    [self setYSImageWithURL:imageStr placeHolderImage:placeHolderImage completed:NULL];
}

- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage completed:(void(^)(void))completeBlock {
    
    GrassWeakSelf;
    if (PASS_NULL_TO_NIL(imageStr).length == 0) {
        self.image = placeHolderImage;
        return ;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageStr]
            placeholderImage:placeHolderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       BOOL isLoaded = [objc_getAssociatedObject(imageStr, &imageLoaded) boolValue];
                       if (!isLoaded) {
                           weakSelf.alpha = 0.;
                           objc_setAssociatedObject(imageStr, &imageLoaded, @(1), OBJC_ASSOCIATION_RETAIN);
                           [UIView animateWithDuration:.6 delay:0.
                                               options:UIViewAnimationOptionAllowUserInteraction
                                            animations:^{
                                                weakSelf.alpha = 1.;
                                            } completion:NULL];
                           if (completeBlock) {
                               completeBlock();
                           }
                           
                       } else {
                           weakSelf.image = image;
                       }
                   }];
    
}

@end
