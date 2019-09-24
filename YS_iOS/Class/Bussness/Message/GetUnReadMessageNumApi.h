//
//  GetUnReadMessageNumApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetUnReadMessageNumApi : BaseApi


/* 2.8.2 获取未读消息数量
 * xiaocao.other.getUnReadMessageNum
 */


- (void)getUnReadMessageNumWithCallback:(ApiRequestCallBack)callback;


@end

