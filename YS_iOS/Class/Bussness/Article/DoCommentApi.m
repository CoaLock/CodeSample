//
//  DoCommentApi.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DoCommentApi.h"


@implementation DoCommentApi {

    NSInteger _articleId;
    NSInteger _commentId;
    NSString *_contents;
}

- (void)doCommentWithArticleId:(NSInteger)articleId contents:(NSString*)contents commentId:(NSInteger)commentId callback:(ApiRequestCallBack)callback {
    
    
    STRING_NIL_NULL(contents);
    _articleId = articleId;
    _contents = contents.copy;
    _commentId = commentId;
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.socialArticle.doComment"
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
    params[@"api_name"] = @"xiaocao.socialArticle.doComment";
    
    
    params[@"article_id"] = @(_articleId);
    params[@"contents"] = _contents;
    
    if (_commentId > 0) {
        
        params[@"comment_id"] = @(_commentId);
    }


    params[@"token"] = [self doSign:params];
    return params;
}



@end
