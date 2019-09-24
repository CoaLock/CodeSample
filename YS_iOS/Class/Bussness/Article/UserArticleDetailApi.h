//
//  UserArticleDetailApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface UserArticleDetailApi : BaseApi



/*
 *  2.3.2 获取用户文章详情 接口名：xiaocao.userArticle.getArticleDetail
 */

- (void)getArticleDetailWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;



@end
