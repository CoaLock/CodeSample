//
//  UserArticleDetailApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserArticleDetailApi.h"

@implementation UserArticleDetailApi {
    
    NSInteger _articleId;
}

- (void)getArticleDetailWithArticleId:(NSInteger)articleId callback:(ApiRequestCallBack)callback {

    _articleId = articleId;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.userArticle.getArticleDetail"
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
    
    params[@"api_name"] = @"xiaocao.userArticle.getArticleDetail";
    
    
    params[@"article_id"] = @(_articleId);
    
    
    params[@"token"] = [self doSign:params];
    return params;
}


@end
