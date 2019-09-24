//
//  GetRewardListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetRewardListApi : BaseApi


/* 2.5.4 获取文章打赏列表
 * xiaocao.socialArticle.getRewardList
 */

- (void)getRewaedListWithArticleId:(NSInteger)articleId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
