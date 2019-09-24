//
//  GetFlashListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetFlashListApi : BaseApi


/*  2.8.3 获取轮播图列表
 *  xiaocao.other.getFlashList
 */

- (void)getFlashListWithCallback:(ApiRequestCallBack)callback;



@end
