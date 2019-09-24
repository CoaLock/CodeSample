//
//  ChangeMobileApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/2.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ChangeMobileApi.h"


@interface ChangeMobileApi ()





@end

@implementation ChangeMobileApi {

    NSString *_oldVerifyCode;
    NSString *_newMobile;
    NSString *_newVerifyCode;
}

- (void)userBindMobileWithOldVerifyCode:(NSString*)oldVerifyCode newMobile:(NSString*)newMobile newVerifyCode:(NSString*)newVerifyCode callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(oldVerifyCode);
    STRING_NIL_NULL(newMobile);
    STRING_NIL_NULL(newVerifyCode);

    _oldVerifyCode = oldVerifyCode.copy;
    _newMobile = newMobile.copy;
    _newVerifyCode = newVerifyCode.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.changeMobile"
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


- (NSDictionary *)publicParameters {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"old_verify_code"] = _oldVerifyCode;
    params[@"new_mobile"] = _newMobile;
    params[@"new_verify_code"] = _newVerifyCode;
    
    params[@"api_name"] = @"xiaocao.user.changeMobile";

    
    params[@"token"] = [self doSign:params];
    return params;
}




@end
