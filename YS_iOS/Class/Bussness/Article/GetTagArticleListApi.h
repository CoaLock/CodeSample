//
//  GetTagArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetTagArticleListApi : BaseApi


/* 2.5.12 获取用户关注的标签文章列表
 * xiaocao.socialArticle.getTagArticleList
 */

- (void)getTagArticleListWithTagId:(NSInteger)tagId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;



@end
