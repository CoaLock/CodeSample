//
//  DoSearchApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DoSearchApi.h"



@implementation DoSearchApi {

    NSString *_keyword;
    
    NSInteger _firstRow;
    NSInteger _fetchNum;
}


- (void)doSearchWithKeyword:(NSString*)keyword firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback {

    STRING_NIL_NULL(keyword);
    
    _firstRow = firstRow;
    _fetchNum = fetchNum;
    
    _keyword = keyword.copy;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.spider.doSearch"
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
    
    
    params[@"api_name"] = @"xiaocao.spider.doSearch";
    
    params[@"keyword"] = _keyword;
    
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
