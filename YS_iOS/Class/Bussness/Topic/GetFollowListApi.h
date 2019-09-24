//
//  GetFollowListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetFollowListApi : BaseApi


/*
 *  2.5.8 获取用户关注列表 xiaocao.socialArticle.getFollowList
 *  @type 关注类型：1标签，2作者，3话题。
 */

- (void)getFollowListWithType:(NSInteger)type firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
