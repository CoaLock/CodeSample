//
//  JPushRegIdApi.m
//  ArtInteract
//
//  Created by 张阳 on 16/10/25.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "JPushRegIdApi.h"

@implementation JPushRegIdApi {
    
    NSString *_jpushRegId;
}

- (void)setJPushRegIdJpushRegId:(NSString*)jpushRegId callback:(ApiRequestCallBack)callback {
    
    
    STRING_NIL_NULL(jpushRegId);
    _jpushRegId = jpushRegId;
    
    HttpRequestTool * tool = [HttpRequestTool shareManage];
    [tool asynPostWithBaseUrl:nil apiMethod:@"xiaocao.user.setJPushRegId" parameters:[self publicParameters] success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 0) {
            //成功回调
            callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
        }else{
            //失败回调
            callback(responseObj , 1);
        }
        
    } failure:^(NSError *error) {
        //失败回调
        callback(nil , 1);
        
    }];
}

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"xiaocao.user.setJPushRegId";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"jpush_reg_id"] = _jpushRegId;
    
    params[@"token"] = [self doSign:params];
    
    return params;
}
@end
