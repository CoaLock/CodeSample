//
//  EffectView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "EffectView.h"


@interface EffectView ()


@property (nonatomic, strong) UIVisualEffectView *effectView;


@end



@implementation EffectView



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        _effectView.frame = self.bounds;
        [self addSubview:_effectView];
        
        
        self.hidden = YES;
        
    }
    return self;
}


- (void)show {

    self.hidden = NO;
    _effectView.layer.opacity = 0.001;
    [UIView animateWithDuration:0.25 animations:^{
       
        _effectView.layer.opacity = 0.4;
        
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hide {

    [UIView animateWithDuration:0.25 animations:^{
        _effectView.layer.opacity = 0.001;
        
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];

}



@end
