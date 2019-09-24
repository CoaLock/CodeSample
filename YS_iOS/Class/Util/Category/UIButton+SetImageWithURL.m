//
//  UIButton+SetImageWithURL.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UIButton+SetImageWithURL.h"
#import <SDWebImage/UIButton+WebCache.h>

static char *imageLoaded;



@implementation UIButton (SetImageWithURL)

- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage {
    [self setYSImageWithURL:imageStr placeHolderImage:placeHolderImage completed:NULL];
}

- (void)setYSImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage completed:(void(^)(void))completeBlock {
    
    GrassWeakSelf;
    if (PASS_NULL_TO_NIL(imageStr).length == 0) {
        [self setImage:placeHolderImage forState:UIControlStateNormal];
        return ;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
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
            
        }
        else {
            
            [self setImage:image forState:UIControlStateNormal];
        }
        
    }];
    

    
}

@end
