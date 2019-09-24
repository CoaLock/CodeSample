//
//  SaveArticleaPI.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/13.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SaveArticleaPI.h"

@implementation SaveArticleaPI {

    NSInteger _articleId;
    NSString *_title;
    NSString *_tagList;
    NSString *_textList;
}


- (void)saveArticleWithArticleId:(NSInteger)articleId title:(NSString*)title tagList:(NSString*)tagList textList:(NSString*)textList callback:(ApiRequestCallBack)callback {
    
    _articleId = articleId;

    STRING_NIL_NULL(title);
    STRING_NIL_NULL(tagList);
    STRING_NIL_NULL(textList);

    _title = title;
    _tagList = tagList;
    _textList = textList;
    
    
    HttpRequestTool *tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.userArticle.saveArticle"
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
    
    params[@"api_name"] = @"xiaocao.userArticle.saveArticle";
    
    if (_articleId > 0) {
        params[@"article_id"] = @(_articleId);
    }
    params[@"title"] = _title;
    params[@"tag_list"] = _tagList;
    params[@"text_list"] = _textList;
    
    
    params[@"token"] = [self doSign:params];
    return params;
}




@end