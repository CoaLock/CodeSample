//
//  BaseApi.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "BaseApi.h"
#import "NSDictionary+Custom.h"

@implementation BaseApi

- (id)init
{
    self = [super init];
    if (self) {
        NSString *serverUrl = [Singleton sharedManager].httpServiceDomain;
        [[HttpRequestTool shareManage] setBaseUrl:serverUrl];
        [[HttpRequestTool shareManage] asynCheckNetworkStatus:^(MiniNetworkStatus networkStatus) {
            
        }];
    }
    return self;
}

- (NSDictionary *)publicParameters
{
    return nil;
}

// 签名
- (NSString *)doSign:(NSDictionary *)params
{
    // 排序遍历字典
    NSMutableString *signStr = [params getDictionaryOfSortString].mutableCopy;

    [signStr appendString:kHttpSignKey];
    NSString *md5Str = [HttpSign doMD5:signStr];
    
    return md5Str;
}

+ (void)cancelAllRequest
{
    [[HttpRequestTool shareManage] cancleAllRequest];
}

@end
