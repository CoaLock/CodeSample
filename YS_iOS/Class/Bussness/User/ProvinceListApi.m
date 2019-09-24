//
//  ProvinceListApi.m
//  ArtInteract
//
//  Created by 蔡卓越 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "ProvinceListApi.h"

@implementation ProvinceListApi

- (void)getProvinceListWithCallBack:(ApiRequestCallBack)callBack {

    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.other.getProvinceList"
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
    
    params[@"api_name"] = @"xiaocao.other.getProvinceList";
    
    params[@"token"] = [self doSign:params];
    return params;
}

@end
