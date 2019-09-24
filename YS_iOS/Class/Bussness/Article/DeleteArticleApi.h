//
//  DeleteArticleApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DeleteArticleApi : BaseApi


/*
 * 2.3.6 用户删除文章 xiaocao.userArticle.deleteArticle
 */

- (void)deleteArticleWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;





@end
