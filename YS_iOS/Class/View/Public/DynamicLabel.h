//
//  DynamicLabel.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DynamicLabel : UIView


@property (nonatomic, assign) NSInteger limitedNum;


@property (nonatomic, copy) void (^limitTipBlock) (void);


@property (nonatomic, copy) void (^tagChangeBlock) (UIButton *button, NSInteger index);


- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray*)tagList needSelected:(BOOL)needSelected heightChangeBlock:(void (^) (CGFloat height))heightChangeBlock;


@end
