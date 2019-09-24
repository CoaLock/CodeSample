//
//  EmptyHistotyApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface EmptyHistotyApi : BaseApi


/*  2.6.2 清空搜索历史
 *  xiaocao.spider.emptyHistory
 */


- (void)emptyHistoryWithCallback:(ApiRequestCallBack)callback;


@end
