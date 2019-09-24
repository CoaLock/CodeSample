//
//  GetAuthorArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetAuthorArticleListApi : BaseApi


/* 2.5.13 获取用户关注的作者文章列表
 * xiaocao.socialArticle.getAuthorArticleList
 */


- (void)getAuthorArticleListWithAuthorId:(NSInteger)authorId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
