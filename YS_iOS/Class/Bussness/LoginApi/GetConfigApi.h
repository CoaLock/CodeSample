//
//  GetConfigApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetConfigApi : BaseApi

/**
 * 2.1.1 获取系统配置 xiaocao.system.getConfig
 */

- (void)getSyetemConfigWithField:(NSString*)fields callback:(ApiRequestCallBack)callback;



@end
