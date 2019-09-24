//
//  LogoutApi.h
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "BaseApi.h"

@interface LogoutApi : BaseApi

/**
 *  退出登录接口(xiaocao.user.logout)
 */
- (void)logoutWithJpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback;


@end
