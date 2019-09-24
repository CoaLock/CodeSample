//
//  GetMessageListApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GetMessageListApi.h"

@implementation GetMessageListApi {

    NSInteger _type;
    NSInteger _firstRow;
    NSInteger _fetchNum;
}


- (void)getMessageListWithType:(NSInteger)type firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback {
    
    _type = type;
    _firstRow = firstRow;
    _fetchNum = fetchNum;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.other.getMessageList"
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
    
    
    params[@"api_name"] = @"xiaocao.other.getMessageList";
    
    
    params[@"type"] = @(_type);

    
    if (_firstRow >= 0) {
        params[@"first_row"] = @(_firstRow);
    }
    if (_fetchNum > 0) {
        params[@"fetch_num"] = @(_fetchNum);
    }
    
    
    params[@"token"] = [self doSign:params];
    return params;
}


@end
