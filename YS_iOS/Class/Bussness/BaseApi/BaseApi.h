//
//  BaseApi.h
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestTool.h"
#import "Singleton.h"
#import "HttpSign.h"

// 请求回调, code = 0 成功， code = 1 失败
typedef void (^ApiRequestCallBack) (id resultData, NSInteger code);

@interface BaseApi : NSObject


/**
 *  获取接口公共参数
 *
 *  @return 公共参数
 */
- (NSDictionary *)publicParameters;

/**
 *  url参数签名（加密）
 *
 *  @param dict 接口参数
 *
 *  @return 40位大写字母数字
 */
- (NSString *)doSign:(NSDictionary *)params;

// 取消请求
+ (void)cancelAllRequest;


@end
