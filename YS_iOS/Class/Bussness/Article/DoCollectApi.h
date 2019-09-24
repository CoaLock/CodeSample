//
//  DoCollectApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoCollectApi : BaseApi


/* 2.5.5 收藏
 * xiaocao.socialArticle.doCollect
 */

- (void)doCollectWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;


@end
