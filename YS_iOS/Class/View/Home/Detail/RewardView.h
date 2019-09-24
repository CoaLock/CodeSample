//
//  RewardView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/15.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardView : UIView


@property (nonatomic, copy) void (^selectedBlock) (CGFloat count);


- (void)show;


@end
