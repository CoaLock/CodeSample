//
//  UIButton+EnLargeEdge.h
//  EnLargeEdge
//
//  Created by 崔露凯 on 16/3/8.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIButton* (^EdgeBlock) (CGFloat size);

@interface UIButton (EnLargeEdge)

- (EdgeBlock)topEdge;

- (EdgeBlock)leftEdge;

- (EdgeBlock)bottomEdge;

- (EdgeBlock)rightEdge;

- (void)setEnlargeEdge:(CGFloat) size;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


@end
