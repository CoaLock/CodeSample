//
//  CanlePublishTipView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CanlePublishTipView.h"


@interface CanlePublishTipView ()

@property (nonatomic, strong) UIView *whiteBg;
@property (nonatomic, strong) UIVisualEffectView *effectView;


@property (nonatomic, strong) NSArray *titles;


@end

@implementation CanlePublishTipView


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];

        _titles = titles;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:effectView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [effectView addGestureRecognizer:tap];
        
        
        _effectView = effectView;
        _effectView.alpha = 0.001;
        
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, kScreenWidth, titles.count *45)];
        whiteView.backgroundColor = kWhiteColor;
        [self addSubview:whiteView];
        
        _whiteBg = whiteView;
        
        for (NSInteger i = 0; i < titles.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 45*i, kScreenWidth, 45);
            btn.lk_attribute
            .normalTitle(titles[i])
            .normalTitleColor([UIColor blackColor])
            .font(16)
            .tag(1000+i)
            .event(self, @selector(buttonOnClicked:))
            .superView(whiteView);
         
            if (i > 0) {
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45*i, kScreenWidth, 1)];
                line.lk_attribute
                .backgroundColor(kSeperateLineColor)
                .superView(whiteView);
            }
            
            if (i == titles.count -1) {
                
                [btn setTitleColor:kAuxiliaryTipColor forState:UIControlStateNormal];
            }
    
        }
        
        [self hide];
    }
    return self;
}

- (void)buttonOnClicked:(UIButton*)btn {

    [self hide];

    if (_eventBlock) {
        _eventBlock(btn.tag -1000);
    }
}


- (void)setTitleColor:(UIColor*)color index:(NSInteger)index {

    UIButton *btn = [_whiteBg viewWithTag:1000+index];

    [btn setTitleColor:color forState:UIControlStateNormal];
}


- (void)tapAction {

    [self hide];
}


- (void)show {

    self.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _effectView.alpha = 0.4;
        
        _whiteBg.frame = CGRectMake(0, self.height - _titles.count*45, kScreenWidth, _titles.count*45);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)hide {

    [UIView animateWithDuration:0.25 animations:^{
       
        _effectView.alpha = 0.001;
        
        _whiteBg.frame = CGRectMake(0, self.height, kScreenWidth, _titles.count*45);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
    
}





@end
