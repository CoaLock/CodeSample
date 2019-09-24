//
//  GetTagArticleListApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "GetTagArticleListApi.h"

@implementation GetTagArticleListApi {

    NSInteger _tagId;
    
    NSInteger _firstRow;
    NSInteger _fetchNum;
}


- (void)getTagArticleListWithTagId:(NSInteger)tagId firstRow:(NSInteger)firstRow fetchNum:(NSInteger)fetchNum callback:(ApiRequestCallBack)callback {
    
    _firstRow= firstRow;
    _fetchNum = fetchNum;
    _tagId = tagId;;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.socialArticle.getTagArticleList"
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
    
    params[@"api_name"] = @"xiaocao.socialArticle.getTagArticleList";
    
    
    
    params[@"tag_id"] = @(_tagId);
    
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
