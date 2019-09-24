//
//  ArticleListApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticleListApi.h"

@implementation ArticleListApi {
    
    
    NSInteger _type;
    NSInteger _firstRow;
    NSInteger _fetchNum;
}


- (void)getHotArticleListWithType:(NSInteger)type firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback {
    
    _type = type;
    _firstRow = firstRow;
    _fetchNum = fetchNum;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.generalArticle.getArticleList"
                   parameters:[self publicParameters]
                      success:^(id responseObj) {
                          
                          if ([responseObj[@"code"] integerValue] == 0) {
                              // 成功回调
                              callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
                          }
                          else {
                              // 失败回调
                              callback(responseObj, 1);
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
    
    
    params[@"api_name"] = @"xiaocao.generalArticle.getArticleList";
    
    if (_type >= 0) {
        params[@"type"] = @(_type);
    }
    
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
