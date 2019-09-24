//
//  GetHotKeywordsApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetHotKeywordsApi : BaseApi



/* 2.6.4 获取热门搜索列表
 * xiaocao.spider.getHotKeywords
 */

- (void)getHotKeywordsWithCallback:(ApiRequestCallBack)callback;



@end
