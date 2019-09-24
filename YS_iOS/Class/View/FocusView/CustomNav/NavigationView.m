//
//  NavigationView.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self initSubviews:frame];
    }
    return self;
}

- (void)initSubviews:(CGRect)frame {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:bgView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 32, 11, 20)];
    _backButton = backButton;
    [backButton setImage:[UIImage imageNamed:@"ic_return_wihte"] forState:UIControlStateNormal];
    
    backButton.leftEdge(10).topEdge(10).bottomEdge(10).rightEdge(30);
    
    [self addSubview:backButton];
    
}

@end
