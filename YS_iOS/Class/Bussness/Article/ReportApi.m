//
//  ReportApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ReportApi.h"

@implementation ReportApi {

    NSInteger _type;
    NSInteger _relationId;
    NSString *_description;
}


- (void)reportWithType:(NSInteger)type relationId:(NSInteger)relationId description:(NSString*)description callback:(ApiRequestCallBack)callback {
    
    STRING_NIL_NULL(description);
    
    _type = type;
    _relationId = relationId;
    _description = description;
    
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.socialArticle.report"
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
    
    
    params[@"api_name"] = @"xiaocao.socialArticle.report";
    
    params[@"type"] = @(_type);
    params[@"relation_id"] = @(_relationId);
    params[@"description"] = _description;

    
    
    params[@"token"] = [self doSign:params];
    return params;
}


@end

