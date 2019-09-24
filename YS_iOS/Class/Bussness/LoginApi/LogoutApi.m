//
//  LogoutApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "LogoutApi.h"

@implementation LogoutApi {

    NSString *_jpushRegId;
}

- (void)logoutWithJpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback {

    STRING_NIL_NULL(jpushRegId);
    _jpushRegId = jpushRegId.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.logout"
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
    params[@"api_name"] = @"xiaocao.user.logout";
    
    params[@"jpush_reg_id"] = _jpushRegId;
    
    params[@"token"] = [self doSign:params];
    return params;
}
@end
