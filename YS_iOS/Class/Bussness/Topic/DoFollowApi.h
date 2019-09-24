//
//  DoFollowApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoFollowApi : BaseApi


/*
 * 2.5.7 关注 xiaocao.socialArticle.doFollow
 * @type 类型：1标签，2作者，3话题。
 */

- (void)doFollowWithType:(NSInteger)type relationId:(NSInteger)relationId callback:(ApiRequestCallBack)callback;

@end
