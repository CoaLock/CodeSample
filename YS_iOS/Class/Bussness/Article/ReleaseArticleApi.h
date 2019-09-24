//
//  ReleaseArticleApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ReleaseArticleApi : BaseApi



/**
 * 2.3.5 用户发布文章 xiaocao.userArticle.releaseArticle
 */

- (void)releaseArticleWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;




@end

