//
//  ProvinceListApi.h
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface ProvinceListApi : BaseApi
/**
 *  获取省份列表(xiaocao.other.getProvinceList)
 */

- (void)getProvinceListWithCallBack:(ApiRequestCallBack)callBack;

@end
