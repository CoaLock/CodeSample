//
//  UIVew+StringTag.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UIVew+StringTag.h"


static char viewStringTag;


@implementation UIView (StringTag)


- (void)setStringTag:(NSString *)stringTag{
        
    objc_setAssociatedObject(self, &viewStringTag, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag{
    
    return objc_getAssociatedObject(self, &viewStringTag);
}




@end
