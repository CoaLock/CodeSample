//
//  ArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface ArticleListApi : BaseApi

/*
 * 2.4.1 获取通用文章列表 xiaocao.generalArticle.getArticleList
 */

- (void)getHotArticleListWithType:(NSInteger)type firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;




@end
