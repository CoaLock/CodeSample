//
//  RetrievePasswordApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/3.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RetrievePasswordApi.h"



@interface RetrievePasswordApi ()



@end


@implementation RetrievePasswordApi {


    NSString *_mobile;
    NSString *_verifyCode;
    NSString *_newPassword;
}


- (void)retrievePasswordWithMobile:(NSString*)mobile verifyCode:(NSString*)verifyCode newPassword:(NSString*)newPassword callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(mobile);
    STRING_NIL_NULL(verifyCode);
    STRING_NIL_NULL(newPassword);

    _mobile = mobile.copy;
    _verifyCode = verifyCode.copy;
    _newPassword = newPassword.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.retrievePassword"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          NSInteger code = [responseObj[@"code"] integerValue];
                          
                          callback(PASS_NULL_TO_NIL(responseObj[@"data"]), code);

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
    params[@"api_name"] = @"xiaocao.user.retrievePassword";
    
    params[@"mobile"] = _mobile;
    params[@"verify_code"] = _verifyCode;
    params[@"new_password"] = _newPassword;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}






@end
