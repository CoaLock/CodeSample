//
//  UploadImageApi.m
//  ZhiYou
//
//  Created by 崔露凯 on 15/11/24.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "UploadImageApi.h"

@implementation UploadImageApi

- (void)uploadImageWithData:(NSData*)imageData dir:(NSString*)dir callback:(ApiRequestCallBack)callback {
    if (imageData == nil) {
        return;
    }
    NSDictionary *params = nil;
    if (dir.length > 0) {
        params = @{@"dir": dir};
    }
    
    HttpRequestTool *adapter = [HttpRequestTool shareManage];
    [adapter asynPostUploadWithUrl:[Singleton sharedManager].httpImageServiceSubmitDomain  apiMethod:@"" parameters:params fileData:imageData success:^(id responseObj) {
        
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 0) {
            callback(PASS_NULL_TO_NIL(responseObj[@"data"]), 0);
        }
        else {
            callback(responseObj, code);
        }
    } failure:^(NSError *error) {
        callback(nil, 1);
    }];
}


@end
