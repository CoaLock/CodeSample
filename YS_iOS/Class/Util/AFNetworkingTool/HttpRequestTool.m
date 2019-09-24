//
//  HttpRequestTool.m
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/9/25.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import "HttpRequestTool.h"
#import "HttpRequestService.h"
#import "AFNetworking.h"


#import "MainDrawerController.h"
#import "TabbarViewController.h"
#import "LoginViewController.h"



#import "SigninApi.h"
#import "UserDefaultsUtil.h"

#import <MBProgressHUD.h>

#import "AppDelegate.h"


@interface HttpRequestTool () <MBProgressHUDDelegate>


@property (nonatomic, strong) NSMutableDictionary *requestList;

@property (nonatomic, strong) MBProgressHUD *progressHUD;


@end

@implementation HttpRequestTool {
    
    
}

+ (HttpRequestTool *)shareManage {
    
    static HttpRequestTool *httpRequestTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        httpRequestTool = [[super alloc] init];
        
    });
    return httpRequestTool;
}

- (instancetype)init {
    if (self = [super init]) {
        _requestList = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSTimeInterval)timeOut {
    if (_timeOut == 0) {
        _timeOut = 15;
    }
    return _timeOut;
}

- (void)asynCheckNetworkStatus:(MiniNetworkStatusCallback)networkBlock {
    
    AFNetworkReachabilityManager *reachabilityManage = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManage startMonitoring];
    [reachabilityManage setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            networkBlock(MiniNetworkStatusUnknown);
        }
        else if (status == AFNetworkReachabilityStatusNotReachable) {
            networkBlock(MiniNetworkStatusReachable);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            networkBlock(MiniNetworkStatusReachableViaWWAN);
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            networkBlock(MiniNetworkStatusReachableViaWifi);
        }
    }];
}

- (void)asynGetWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = params;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodGet;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {
        [_requestList removeObjectForKey:apiMethod];
        successBlock(responseObj);
        
    } failure:^(NSError *error) {
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostWithBaseUrl:(NSString *)baseUrl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)params success:(MiniHttpRequestServiceSuccess)successBlock failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseUrl) {
        requestObj.requestUrl = baseUrl;
    }
    else {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = params;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = successBlock;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [HttpRequestService asynRequest:requestObj success:^(id responseObj) {

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

        
        NSInteger code = [PASS_NULL_TO_NIL(responseObj[@"code"]) integerValue];
        
        if (code != 0) {
#ifdef DEBUG

           // [self showTextOnly:[NSString stringWithFormat:@"错误码:%li,错误信息:%@", code, responseObj[@"msg"]]];
#endif
        }
        
        
        // 1.系统维护，退出应用程序
        if (code == 50000) {
            
            [self exitApp:responseObj[@"msg"]];
            return;
        }
        
        
        // 2.登录失效、用户被禁用，清空缓存信息，用户重新登录
        if (code == 55555 || code == 55550) {
            
            [self handleLoginInvalid];
            
            //return;
        }
        
        successBlock(responseObj);

        
//        // 判断是否为Session失效,或者用户未登录
//        if (code == 55555) {
//            
//            NSString *mobile = [UserDefaultsUtil getUserDefaultName];
//            NSString *password = [UserDefaultsUtil getUserDefaultPassword];
//            
//            // 用户登录
//            SignInApi *signInApi = [[SignInApi alloc] init];
//            [signInApi userSigninMobile:mobile password:password callback:^(id resultData, NSInteger code) {
//                
//                // 登录成功后，继续请求上一条失败的请求
//                if (code == 0) {
//                    [self asynPostWithBaseUrl:baseUrl apiMethod:apiMethod parameters:params success:successBlock failure:failure];
//                }
//                else {
//                    
//                    successBlock(@{@"code": @"47006", @"msg": @"用户未登录"});
//                }
//                
//            }];
//            
//        }
//        else {
//            
//            // 若Session过期,  则不回调block
//            successBlock(responseObj);
//        }
        
        [_requestList removeObjectForKey:apiMethod];
        
    } failure:^(NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

#ifdef DEBUG
         //[self showTextOnly:[NSString stringWithFormat:@"连接服务器失败%@", error.domain]];
#endif
        [_requestList removeObjectForKey:apiMethod];
        failure(error);
    }];
}

- (void)asynPostUploadWithUrl:(NSString *)baseurl apiMethod:(NSString *)apiMethod parameters:(NSDictionary *)parameters fileData:(NSData *)data success:(MiniHttpRequestServiceSuccess)success failure:(MiniHttpRequestServiceFailure)failure {
    
    HttpRequestObject *requestObj = [[HttpRequestObject alloc] init];
    if (baseurl)
    {
        requestObj.requestUrl = baseurl;
    }
    else
    {
        requestObj.requestUrl = self.baseUrl;
    }
    requestObj.requestTimeout = self.timeOut;
    requestObj.requestParams = parameters;
    requestObj.apiMethod = apiMethod;
    requestObj.requestMethod = MiniRequestMethodPost;
    requestObj.responseType = MiniRequestResponseTypeJSON;
    requestObj.successBlock = success;
    requestObj.failureBlock = failure;
    _requestList[apiMethod] = requestObj;
    
    [HttpRequestService uploadRequest:requestObj
                             fileData:data
                              success:^(id responseObj){
                                  [_requestList removeObjectForKey:apiMethod];
                                  success(responseObj);
                              }
                              failure:^(NSError *error){
                                  [_requestList removeObjectForKey:apiMethod];
                                  failure(error);
                              }];
    
}

- (void)resumeRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation resume];
}

- (void)suspendRequestWithApiMethid:(NSString*)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [requestObj.requestOperation suspend];
}

- (void)cancleRequestWithApiMethod:(NSString *)apiMethod {
    
    HttpRequestObject *requestObj = _requestList[apiMethod];
    [HttpRequestService cancleRequest:requestObj];
    [_requestList removeObjectForKey:apiMethod];
}

- (void)cancleAllRequest {
    
    for (NSString *apiMethod in [_requestList allKeys]) {
        
        HttpRequestObject *requestObj = _requestList[apiMethod];
        [HttpRequestService cancleRequest:requestObj];
        [_requestList removeObjectForKey:apiMethod];
    }
}


#pragma mark - 请求成功 错误码处理
- (void)exitApp:(NSString*)msg {

    NSString *msgStr = PASS_NULL_TO_NIL(msg) ? msg : @"服务器维护中..." ;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        [UIView animateWithDuration:0.5 animations:^{
        
            appDelegate.window.alpha = 0;
            appDelegate.window.frame = CGRectMake(0, appDelegate.window.bounds.size.width, 0, 0);
            
        } completion:^(BOOL finished) {
            
            exit(0);
        }];
        
    }];
    
    [alertVC addAction:sureAction];
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    [rootVC presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)handleLoginInvalid {
    
    // 1.设置用户登录 成功
    [UserDefaultsUtil removeUserLogin];
    
    
    // 2.保存
    [Singleton sharedManager].userId = @"";
    // [Singleton sharedManager].mobile = mobile;
    [Singleton sharedManager].userPassward = @"";
    
    [Singleton sharedManager].thirdLoginType = -1;
    
    
   // [UserDefaultsUtil setUserDefaultName:@""];
    [UserDefaultsUtil setUserDefaultPassword:@""];

    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    
//    MainDrawerController *mainVC = (MainDrawerController*)window.rootViewController;
//    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
//        
//        [mainVC closeDrawerAnimated:NO completion:nil];
//        
//        TabbarViewController *tabbar = (TabbarViewController*)mainVC.centerViewController;
//        NavigationController *nav = tabbar.viewControllers[tabbar.currentIndex];
//        BaseViewController *topVC = (BaseViewController*)nav.topViewController;
//        [topVC showReLoginVC];
//    }
}

#pragma mark - show error message when debug
- (void)showTextOnly:(NSString *)text {
    
    if (_progressHUD) {
        return;
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    _progressHUD = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    _progressHUD.mode = MBProgressHUDModeText;
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    _progressHUD.delegate = self;
    _progressHUD.labelText = text;
    _progressHUD.labelFont = Font(12.0);
    _progressHUD.margin = 10.f;
    _progressHUD.yOffset = 100;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color = [UIColor whiteColor];
    _progressHUD.labelColor = [UIColor redColor];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_progressHUD hide:YES];
        _progressHUD = nil;
        
    });
}



@end
