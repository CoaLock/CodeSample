//
//  DoRewardApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DoRewardApi.h"

@implementation DoRewardApi {

    NSInteger _articleId;
    NSInteger _money;
}



- (void)doRewardWithArticleId:(NSInteger)articleId money:(NSInteger)money callback:(ApiRequestCallBack)callback {
    
    _articleId = articleId;
    _money = money;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.socialArticle.doReward"
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
    
    params[@"api_name"] = @"xiaocao.socialArticle.doReward";
    
    params[@"article_id"] = @(_articleId);

    params[@"money"] = @(_money);
    
    
    
    params[@"token"] = [self doSign:params];
    return params;
}





@end
