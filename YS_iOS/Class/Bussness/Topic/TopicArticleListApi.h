//
//  TopicArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface TopicArticleListApi : BaseApi

/* 2.7.3 获取话题文章列表
 * xiaocao.topic.getTopicArticleList
 */


- (void)getTopicArticleListWithTopicId:(NSInteger)topicId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
