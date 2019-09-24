//
//  DoZanApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DoZanApi.h"

@implementation DoZanApi {

    NSInteger _type;
    NSInteger _relationId;
}


- (void)doZanWithType:(NSInteger)type relationId:(NSInteger)relationId callback:(ApiRequestCallBack)callback {
    
    _type = type;
    _relationId = relationId;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.socialArticle.doZan"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          NSInteger code = [responseObj[@"code"] integerValue] ;
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
    
    params[@"api_name"] = @"xiaocao.socialArticle.doZan";
    
    params[@"type"] = @(_type);
    params[@"relation_id"] = @(_relationId);

    
    params[@"token"] = [self doSign:params];
    return params;
}



@end
