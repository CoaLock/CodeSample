//
//  JPushRegIdApi.h
//  ArtInteract
//
//  Created by 张阳 on 16/10/25.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface JPushRegIdApi : BaseApi

/**
 *   设置极光推送的用户识别码 xiaocao.user.setJPushRegId
 */

- (void)setJPushRegIdJpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback;

@end
