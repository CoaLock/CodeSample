//
//  GetTagListApi.h
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "BaseApi.h"

@interface GetTagListApi : BaseApi



/*
 * 2.8.4 获取推荐标签列表  xiaocao.other.getTagList
 */


- (void)getTagListWithCallback:(ApiRequestCallBack)callback;



@end
