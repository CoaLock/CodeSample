//
//  BindMobileApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/8/29.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BindMobileApi.h"

@implementation BindMobileApi {
    
    NSString *_mobile;
    NSString *_verifyCode;
    NSString *_thirdId;
}


- (void)userBindMobileWithThirdId:(NSString*)thirdId mobile:(NSString*)mobile verifyCode:(NSString*)verifyCode callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(mobile);
    STRING_NIL_NULL(verifyCode);
    STRING_NIL_NULL(thirdId);

    _mobile = mobile.copy;
    _verifyCode = verifyCode.copy;
    _thirdId = thirdId.copy;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.bindMobile" parameters:[self publicParameters] success:^(id responseObj) {
        
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 0) {
            
            //成功回调
            callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
        }else{
            //失败回调
            callback(responseObj , code);
        }
        
    } failure:^(NSError *error) {
        //失败回调
        callback(nil , 1);
        
    }];
}

- (NSDictionary *)publicParameters {
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"xiaocao.user.bindMobile";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"mobile"] = _mobile;
    params[@"user_third_id"] = _thirdId;
    params[@"verify_code"] = _verifyCode;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}

@end
