//
//  CityListApi.m
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "CityListApi.h"

@interface CityListApi ()

@property (nonatomic, assign) NSInteger provinceId;

@end

@implementation CityListApi

- (void)getCityListWithProvinceId:(NSInteger)provinceId callBack:(ApiRequestCallBack)callBack {
    
    _provinceId = provinceId;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.other.getCityList"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          NSInteger code = [responseObj[@"code"] integerValue];
                          if (code == 0) {
                              // 成功回调
                              callBack(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
                          }
                          else {
                              // 失败回调
                              callBack(responseObj, code);
                          }
                      }
                      failure:^(NSError *error) {
                          // 失败回调
                          callBack(nil, 1);
                      }];
}

- (NSDictionary *)publicParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    params[@"api_name"] = @"xiaocao.other.getCityList";
    
    params[@"province_id"] = @(_provinceId);
    
    params[@"token"] = [self doSign:params];
    return params;
}

@end
