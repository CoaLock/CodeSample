//
//  UserInfoApi.m
//  B2CShop
//
//  Created by 张阳 on 16/7/19.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "UserInfoApi.h"

@implementation UserInfoApi {

    NSString *_fields;
}

- (void)getUserInfoWithFields:(NSString*)fields callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(fields);
    _fields = fields.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.getUserInfo"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          NSInteger code = [responseObj[@"code"] integerValue];
                          if ( code == 0) {
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
    
    params[@"api_name"] = @"xiaocao.user.getUserInfo";
    
    _fields = _fields.length >0 ? _fields : @"user_id,is_push,left_money,mobile,nickname,realname,headimgurl,sex,birthday,signature,city_id,is_rec,fans_num";
    
    params[@"fields"] = _fields;
    
    params[@"token"] = [self doSign:params];
    return params;
}
@end
