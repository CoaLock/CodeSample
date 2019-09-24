//
//  UMShareView.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseViewController.h"

#import <UMSocialCore/UMSocialCore.h>

//typedef void (^ShareBlock) (id result);

typedef void (^ShareBlock) (UMSocialPlatformType platType);


@class BaseViewController;

@class GArticleModel;

@interface UMShareView : UIView


@property (nonatomic, strong) GArticleModel *articleModel;

- (instancetype)initWithFrame:(CGRect)frame viewController:(BaseViewController*)viewController eventType:(ShareBlock)shareBlock;



- (void)show;


- (void)hide;



@end
