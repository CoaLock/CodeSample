//
//  DoZanApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoZanApi : BaseApi

/* 2.5.9 点赞
 * xiaocao.socialArticle.doZan
 * 点赞类型：1文章，2评论。
 */



- (void)doZanWithType:(NSInteger)type relationId:(NSInteger)relationId callback:(ApiRequestCallBack)callback;


@end
