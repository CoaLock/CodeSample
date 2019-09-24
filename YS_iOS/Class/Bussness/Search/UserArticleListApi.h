//
//  UserArticleListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 17/3/15.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface UserArticleListApi : BaseApi


/* 根据user_id搜索文章列表
 * xiaocao.spider.getUserArticleList
 */

- (void)doSearchWithUserId:(NSInteger)userId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;




@end
