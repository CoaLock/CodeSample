//
//  GeneralArticleDetailApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/17.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GeneralArticleDetailApi : BaseApi


/*
 * 2.4.3 获取通用文章详情 xiaocao.generalArticle.getArticleDetail
 */

- (void)getArticleDetailWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback;



@end
