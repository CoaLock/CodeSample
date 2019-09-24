//
//  SendVerifyCodeApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/28.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "SendVerifyCodeApi.h"

@implementation SendVerifyCodeApi {
    
    NSString *_mobile;
}

- (void)userSendVerifyCodeWithMobile:(NSString *)mobile callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(mobile);
    _mobile = mobile;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.sendVerifyCode"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          if ([responseObj[@"code"] integerValue] == 0) {
                              // 成功回调
                              callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
                          }
                          else {
                              // 失败回调
                              callback(responseObj, 1);
                          }
                      }
                      failure:^(NSError *error) {
                          // 失败回调
                          callback(nil, 1);
                      }];
}

- (NSDictionary *)publicParameters {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    params[@"api_name"] = @"xiaocao.user.sendVerifyCode";
    
    params[@"mobile"] = _mobile;
    
    params[@"token"] = [self doSign:params];
    return params;
}

@end
