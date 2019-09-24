//
//  HttpRequestService.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/9/25.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "HttpRequestService.h"
#import "AFNetworking.h"
#import "HttpLogger.h"
#import "UserDefaultsUtil.h"

@implementation HttpRequestService

+ (void)asynRequest:(HttpRequestObject *)requestObj success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = requestObj.requestTimeout;
    //GET
    if (requestObj.requestMethod == MiniRequestMethodGet) {
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        
        requestObj.requestOperation = [manager GET:requestObj.requestUrl parameters:requestObj.requestParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [HttpLogger logDebugInfoWithResponse:task.response apiName:requestObj.apiMethod resposeString:responseObject request:task.originalRequest error:nil];
            if (responseObject) {
                success(responseObject);
            }
            else {
                success(nil);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [HttpLogger logDebugInfoWithResponse:task.response apiName:requestObj.apiMethod resposeString:nil request:task.originalRequest error:error];
            failure(error);
        }];
        [HttpLogger logDebugInfoWithRequest:requestObj.requestOperation.originalRequest apiName:requestObj.apiMethod requestParams:requestObj.requestParams httpMethod:@"GET"];
    }
    //POST
    else if (requestObj.requestMethod == MiniRequestMethodPost) {
    
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        
        NSString *phpsesionid = [UserDefaultsUtil getUsetDefaultCookie];
        if (PASS_NULL_TO_NIL(phpsesionid).length > 0) {
            
//            [manager.requestSerializer setValue:phpsesionid forHTTPHeaderField:@"PHPSESSID"];
            
            NSString *cookieString = [NSString stringWithFormat:@"%@=%@",@"PHPSESSID", phpsesionid]; // Cookie
            [manager.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];

        }
        
        requestObj.requestOperation = [manager POST:requestObj.requestUrl parameters:requestObj.requestParams progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [HttpLogger logDebugInfoWithResponse:task.response apiName:requestObj.apiMethod resposeString:responseObject request:task.originalRequest error:nil];
            
            NSHTTPURLResponse *response = (NSHTTPURLResponse*)task.response;
            NSDictionary *headerFields = response.allHeaderFields;
            
            NSLog(@"%@", headerFields.mj_keyValues);
            
            //保存登陆cookie
            NSArray *cookieList = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
            for (NSHTTPCookie *cookie in cookieList) {

                NSDictionary *properties = cookie.properties;
                
                if ([properties[@"Name"] isEqualToString:@"PHPSESSID"]) {

                    [UserDefaultsUtil setUserDefaultCookie:properties[@"Value"]];
                    //NSLog(@"🍎🍎%@", properties[@"Value"]);

                    break;
                }
                
            }
            
            success(PASS_NULL_TO_NIL(responseObject));

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [HttpLogger logDebugInfoWithResponse:task.response apiName:requestObj.apiMethod resposeString:nil request:task.originalRequest error:error];
            
            failure(error);
        }];
        
        
        [HttpLogger logDebugInfoWithRequest:requestObj.requestOperation.originalRequest apiName:requestObj.apiMethod requestParams:requestObj.requestParams httpMethod:@"POST"];
        
    }
}

+ (void)uploadRequest:(HttpRequestObject *)requestObj fileData:(NSData *)data success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure
{
    NSError *error = nil;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:requestObj.requestUrl
                                                                          parameters:requestObj.requestParams
                                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                               
                                                               [formData appendPartWithFileData:data name:@"upfile" fileName:@"boris.png" mimeType:@"image/png"];
                                                           }
                                                                               error:&error];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    AFHTTPResponseSerializer *responseSerializer = (AFHTTPResponseSerializer *)manager.responseSerializer;
    
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSString *phpsesionid = [UserDefaultsUtil getUsetDefaultCookie];
    if (PASS_NULL_TO_NIL(phpsesionid)) {
        //            [manager.requestSerializer setValue:phpsesionid forHTTPHeaderField:@"PHPSESSID"];
        
        NSString *cookieString = [NSString stringWithFormat:@"%@=%@",@"PHPSESSID", phpsesionid]; // Cookie
        
        [request setValue:cookieString forHTTPHeaderField:@"Cookie"];
    }

    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
       
        if (error) {
            failure(error);
        } else {
            success(responseObject);
        }
    }];
 
    [uploadTask resume];
}

+ (void)cancleRequest:(HttpRequestObject *)requestObj {

    [requestObj.requestOperation cancel];
    requestObj.successBlock = nil;
    requestObj.failureBlock = nil;
}

@end
