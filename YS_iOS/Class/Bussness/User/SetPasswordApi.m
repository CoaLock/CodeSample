//
//  SetPasswordApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "SetPasswordApi.h"
@interface SetPasswordApi () {
    
    
    NSString *_verifyCode;
    NSString *_newPassword;
}

@end

@implementation SetPasswordApi

- (void)setPasswordWithVerifyCode:(NSString*)verifyCode newPassword:(NSString*)newPassword callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(verifyCode);
    STRING_NIL_NULL(newPassword);
    _verifyCode = verifyCode;
    _newPassword = newPassword;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.setPassword"
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
    
    params[@"api_name"] = @"xiaocao.user.setPassword";
    
    params[@"verify_code"] = _verifyCode;
    params[@"new_password"] = _newPassword;
 
    params[@"token"] = [self doSign:params];
    return params;
}
@end
