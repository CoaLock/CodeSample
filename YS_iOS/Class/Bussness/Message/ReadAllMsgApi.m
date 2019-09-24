//
//  ReadAllMsgApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ReadAllMsgApi.h"

@implementation ReadAllMsgApi


- (void)readAllMessageWith:(ApiRequestCallBack)callback {
    
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.other.readAllMessage"
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
    params[@"api_name"] = @"xiaocao.other.readAllMessage";
    params[@"token"] = [self doSign:params];
    return params;
}




@end
