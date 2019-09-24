//
//  HotArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface HotArticleListApi : BaseApi


/*
 * 2.4.2 获取最热文章列表 xiaocao.generalArticle.getHotArticleList
 */

- (void)getHotArticleListWithFirstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
