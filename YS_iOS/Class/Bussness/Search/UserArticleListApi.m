//
//  UserArticleListApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 17/3/15.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import "UserArticleListApi.h"

@implementation UserArticleListApi {
    
    NSInteger _userId;
    
    NSInteger _firstRow;
    NSInteger _fetchNum;
}


- (void)doSearchWithUserId:(NSInteger)userId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback {
    
    _firstRow = firstRow;
    _fetchNum = fetchNum;
    _userId = userId;
    
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.spider.getUserArticleList"
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
    
    params[@"api_name"] = @"xiaocao.spider.getUserArticleList";
    
    params[@"user_id"] = @(_userId);
    
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
