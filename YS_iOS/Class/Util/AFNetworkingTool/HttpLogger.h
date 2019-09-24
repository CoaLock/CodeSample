//
//  HttpLogger.h
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request
                        apiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSURLResponse *)response
                         apiName:(NSString *)apiName
                   resposeString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

@end
