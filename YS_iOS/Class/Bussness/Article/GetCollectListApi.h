//
//  GetCollectListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetCollectListApi : BaseApi


/* 2.5.6 获取用户收藏列表
 * xiaocao.socialArticle.getCollectList
 */


- (void)getCollectListWithFirstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;


@end
