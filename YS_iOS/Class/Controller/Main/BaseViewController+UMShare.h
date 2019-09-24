//
//  BaseViewController+UMShare.h
//  YS_iOS
//
//  Created by 崔露凯 on 17/1/9.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseViewController.h"

#import "GArticleModel.h"
#import <UMSocialCore/UMSocialCore.h>


@interface BaseViewController (UMShare)


@property (nonatomic, strong) GArticleModel *shareObj;


#pragma mark - UMShare

- (void)sharePromoCodePlatType:(UMSocialPlatformType)platType;


@end
