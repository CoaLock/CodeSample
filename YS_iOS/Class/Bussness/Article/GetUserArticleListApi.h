//
//  GetUserArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/16.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetUserArticleListApi : BaseApi


/*
 * 2.3.1 获取用户文章列表 xiaocao.userArticle.getArticleList
 */

- (void)getArticleListWithIsAudit:(NSInteger)isAudit firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;



@end
