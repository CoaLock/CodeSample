//
//  TopicListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface TopicListApi : BaseApi

/*
 * 2.7.1 获取话题列表 xiaocao.topic.getTopicList
 */

- (void)getTopicListWithFirstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;

@end
