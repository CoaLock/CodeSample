//
//  ReadMessageApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ReadMessageApi : BaseApi


/*  2.8.9 将消息设为已读
 *  xiaocao.other.readMessage
 */

- (void)readMessageWithType:(NSInteger)type relationId:(NSInteger)relationId callback:(ApiRequestCallBack)callback;


@end
