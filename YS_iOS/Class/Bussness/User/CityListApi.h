//
//  CityListApi.h
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseApi.h"

@interface CityListApi : BaseApi
/**
 *  获取城市列表(xiaocao.other.getCityList)
 */
- (void)getCityListWithProvinceId:(NSInteger)provinceId callBack:(ApiRequestCallBack)callBack;

@end
