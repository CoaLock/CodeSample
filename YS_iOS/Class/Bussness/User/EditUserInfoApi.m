//
//  EditUserInfoApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "EditUserInfoApi.h"
@interface EditUserInfoApi () {
    
    NSString *_field;
    NSString *_value;
}

@end


@implementation EditUserInfoApi

- (void)editUserInfoWithField:(NSString*)field value:(NSString*)value callback:(ApiRequestCallBack)callback {
    
    
    STRING_NIL_NULL(field);
    STRING_NIL_NULL(value);
    
    _field  = field.copy;
    _value = value.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.editUserInfo"
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
    params[@"api_name"] = @"xiaocao.user.editUserInfo";
    
    params[@"field"] = _field;
    params[@"value"] = _value;
   
    params[@"token"] = [self doSign:params];
    return params;
}

@end
