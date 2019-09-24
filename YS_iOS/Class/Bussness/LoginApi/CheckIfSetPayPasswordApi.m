//
//  CheckIfSetPayPasswordApi.m
//  ArtInteract
//
//  Created by 蔡卓越 on 2016/10/11.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "CheckIfSetPayPasswordApi.h"

@implementation CheckIfSetPayPasswordApi

- (void)checkIfSetPayPasswordWithCallBack:(ApiRequestCallBack)callBack {

    HttpRequestTool * tool = [HttpRequestTool shareManage];
    
    [tool asynPostWithBaseUrl:nil apiMethod:@"artist.user.checkIfSetPayPassword" parameters:[self publicParameters] success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 0) {
            //成功回调
            callBack(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
            
        }else{
            //失败回调
            callBack(responseObj, 1);
        }
        
    } failure:^(NSError *error) {
        //失败回调
        callBack(nil, 1);
        
    }];

}

- (NSDictionary *)publicParameters
{
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"appid"] = SEAVER_APP_ID;
    params[@"api_name"] = @"artist.user.checkIfSetPayPassword";
    params[@"PHPSESSID"] = [Singleton sharedManager].phpSesionId;
    
    params[@"token"] = [self doSign:params];
    
    return params;
    
}

@end
