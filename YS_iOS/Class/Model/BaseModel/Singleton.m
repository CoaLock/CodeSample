//
//  Singleton.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "Singleton.h"
#import "UserDefaultsUtil.h"
#import "AFNetworking.h"

@implementation Singleton

+ (Singleton *)sharedManager {
    
    static Singleton *g_singleton = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        g_singleton = [[super alloc] init];
    });
    return g_singleton;
}

- (NSString *)phpSesionId {
    
    if (_phpSesionId == nil || [_phpSesionId isEqualToString:@""]) {
        
        NSString *cookie = [UserDefaultsUtil getUsetDefaultCookie];
        if (cookie) {
            _phpSesionId = cookie;
        }
        else {
            _phpSesionId = @"";
        }
    }
    return _phpSesionId;
}

- (void)checkUpdateWithVC:(BaseViewController *)vc {

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    NSString *encodingUrl=[[@"http://itunes.apple.com/lookup?id=" stringByAppendingString:kAPPID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSString * versionStr = resultDic[@"results"][0][@"version"];
        
        _version = versionStr;
        
        float version =[versionStr floatValue];
        
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        
        float currentVersion = [[infoDic valueForKey:@"CFBundleShortVersionString"] floatValue];
        
        if(version>currentVersion) {
            
            [self showUpdateResultWithVC:vc];
            
        }else if (version == currentVersion) {
        
            [vc showTextOnly:@"当前版本已经是最新版本"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [vc showErrorMsg:@"检查更新失败，请检查网络"];

    }];

}

- (void)showUpdateResultWithVC:(BaseViewController *)vc {

    NSString *promptStr = [NSString stringWithFormat:@"小草v%@,赶快体验吧!", _version];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发现新版本" message:promptStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", kAPPID];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:updateAction];
    [vc presentViewController:alertController animated:YES completion:nil];
    
}

@end
