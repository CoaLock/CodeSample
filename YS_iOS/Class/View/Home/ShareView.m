//
//  ShareView.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/8.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ShareView.h"


static float anitionDuration = 0.6;


@implementation ShareView



+ (instancetype)shareView {

    static dispatch_once_t onceToken;
    
    static ShareView *instance = nil;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        
    });
    
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = frame;
        [self addSubview:effectView];

        
        NSArray *imgNames = @[@"wx_ic.png", @"timeline_ic.png"];
        NSArray *titles = @[@"微信", @"朋友圈"];
        
        
        for (NSInteger i = 0; i < 2; i++) {
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareBtn setBackgroundImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
            
            [self addSubview:shareBtn];

            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
            titleLabel.font = Font(12.0);
            titleLabel.text = titles[i];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLabel];
            
            
            if (i ==0 ) {
                
                shareBtn.frame = CGRectMake(0, (kScreenHeight - 60)/2, 40, 40);
                shareBtn.right = (kScreenWidth - 40)/2;
                [shareBtn addTarget:self action:@selector(shareToWX) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                
                shareBtn.frame = CGRectMake(0, (kScreenHeight - 60)/2, 40, 40);
                shareBtn.left = (kScreenWidth + 40)/2;
                [shareBtn addTarget:self action:@selector(shareToTimeLine) forControlEvents:UIControlEventTouchUpInside];
            }

            
            titleLabel.top = shareBtn.bottom + 10;
            titleLabel.centerX = shareBtn.centerX;
        }
        
        
        self.layer.opacity = 0.001;
        
        [self addTarget:self action:@selector(hideAction) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (void)showWithAnimation {

    self.layer.opacity = 0.01;
    
    [UIView animateWithDuration:anitionDuration animations:^{
       
        self.layer.opacity = 1;
    }];
}

- (void)hideWithAnimation {
    
    [UIView animateWithDuration:anitionDuration animations:^{
        
        self.layer.opacity = 0.001;
    }];
}


- (void)hideAction {

    [self hideWithAnimation];
    if (_shareBlock) {
        _shareBlock(ShareTypeDefault);
    }
}

- (void)shareToWX {
    
    [self hideWithAnimation];
    if (_shareBlock) {
        _shareBlock(ShareTypeWX);
    }
}

- (void)shareToTimeLine {
    
    [self hideWithAnimation];
    if (_shareBlock) {
        _shareBlock(ShareTypeTimeLine);
    }
}





@end
