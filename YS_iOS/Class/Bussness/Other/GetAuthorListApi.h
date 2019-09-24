//
//  GetAuthorListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetAuthorListApi : BaseApi



/* 2.8.5 获取推荐作者列表
 * xiaocao.other.getAuthorList
 */

- (void)getAuthorListWithFirstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback;




@end
