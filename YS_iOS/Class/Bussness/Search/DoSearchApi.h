//
//  DoSearchApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface DoSearchApi : BaseApi


/* 2.6.1 关键词搜索
 * xiaocao.spider.doSearch
 */
 
- (void)doSearchWithKeyword:(NSString*)keyword firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;



@end
