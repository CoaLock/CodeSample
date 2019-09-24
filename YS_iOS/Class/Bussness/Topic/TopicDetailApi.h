//
//  TopicDetailApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface TopicDetailApi : BaseApi


/*
 * 2.7.2 获取话题详情  xiaocao.topic.getTopicDetail
 */

- (void)getTopicDetailWith:(NSInteger)topicId callback:(ApiRequestCallBack)callback;


@end
