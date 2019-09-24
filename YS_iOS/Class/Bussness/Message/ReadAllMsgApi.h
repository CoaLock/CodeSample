//
//  ReadAllMsgApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ReadAllMsgApi : BaseApi


/* 2.8.10 将用户的所有消息设为已读
 * xiaocao.other.readAllMessage
 */

- (void)readAllMessageWith:(ApiRequestCallBack)callback;


@end
