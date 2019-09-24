//
//  GetHistoryApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetHistoryApi : BaseApi


/* 2.6.3 获取用户搜索历史
 * xiaocao.spider.getHistory
 */


- (void)getHistoryWithFirstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;



@end
