//
//  GetConfigApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GetConfigApi.h"

@implementation GetConfigApi {

    NSString *_fields;
}


- (void)getSyetemConfigWithField:(NSString*)fields callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(fields);
    _fields = fields.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.system.getConfig"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          NSInteger code = [responseObj[@"code"] integerValue];
                          if (code == 0) {
                              // 成功回调
                              callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
                          }
                          else {
                              // 失败回调
                              callback(responseObj, code);
                          }
                      }
                      failure:^(NSError *error) {
                          // 失败回调
                          callback(nil, 1);
                      }];
}

- (NSDictionary *)publicParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"api_name"] = @"xiaocao.system.getConfig";
    
    _fields = _fields.length ? _fields : @"personal_background,ios_verify,app_style,customer_service_telephone";
    params[@"fields"] = _fields;
    
    params[@"token"] = [self doSign:params];
    return params;
}



@end
