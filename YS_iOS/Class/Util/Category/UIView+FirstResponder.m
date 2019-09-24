//
//  UIView+FirstResponder.m
//  YS_iOS
//
//  Created by 崔露凯 on 17/2/5.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)


- (UIView*)getFirstResponder {
    
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        
        if (subview.isFirstResponder) {
            return subview;
        }
        
        UIView *firstResponder = [subview getFirstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}


@end
