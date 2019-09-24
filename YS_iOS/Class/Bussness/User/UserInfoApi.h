//
//  UserInfoApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"


@interface UserInfoApi : BaseApi

/**
 *   2.2.8 获取用户信息 xiaocao.user.getUserInfo
 */

- (void)getUserInfoWithFields:(NSString*)fields callback:(ApiRequestCallBack)callback;

@end
