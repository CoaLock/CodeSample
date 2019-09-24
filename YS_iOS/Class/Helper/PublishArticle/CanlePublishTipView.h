//
//  CanlePublishTipView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CanlePublishTipView : UIView


@property (nonatomic, strong) void (^eventBlock) (NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles;

- (void)setTitleColor:(UIColor*)color index:(NSInteger)index;



- (void)show;

- (void)hide;



@end
