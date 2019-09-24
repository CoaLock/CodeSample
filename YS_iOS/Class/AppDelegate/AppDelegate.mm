//
//  AppDelegate.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/10/31.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AppDelegate.h"


#import "AppDelegate+Launch.h"

#import "GuideViewController.h"
#import "LaunchController.h"
#import "TabbarViewController.h"
#import "MainDrawerController.h"

#import "LoginViewController.h"
#import "NavigationController.h"
#import "DetailViewController.h"
#import "PersonArticleViewController.h"
#import "BaseWKWebViewController.h"
#import "PersonNoticeViewController.h"
#import "CommentViewController.h"

#import "JPushRegIdApi.h"
#import "GetMessageListApi.h"

#import "ApnsModel.h"


#import <PgySDk/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import "WXApi.h"

#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;


@interface AppDelegate () <CLLocationManagerDelegate, JPUSHRegisterDelegate>

@property (nonatomic, strong) CLLocationManager *locationManage;


@end

@implementation AppDelegate



#pragma mark - App Life Cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    //配置服务器
    [self configServiceAddress];
    
    //配置根控制器
    [self configRootViewController];
    
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timeTextAppActive) userInfo:nil repeats:YES];
    
    // 配置友盟分享
    [self configUMShare];
    
    
    // 配置友盟统计
    [self umengTrack];
    
    
    // 配置蒲公英
    [self configPgy];
    
    
    //配置地图
   // [self configMapKit];
    
    
    //配置极光
    [self configJPushWithOptions:launchOptions];

    
//    NSLog(@"%@",NSHomeDirectory());

    
    return YES;
}

- (void)timeTextAppActive {
    
    UIViewController *vc = self.window.rootViewController;
    
    NSLog(@"---%@, %i 程序活跃中", [vc class], vc.view.userInteractionEnabled);
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

// iOS9 NS_AVAILABLE_IOS
/*
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    
    return YES;
}
*/

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        
    }
    return result;
}

#pragma mark DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}

#pragma mark - Config
- (void)configServiceAddress {

    //测试环境
    [Singleton sharedManager].httpServiceDomain = kHttpServiceDomainSandbox;
    [Singleton sharedManager].httpImageServiceDomain = kHttpImageServiceSandbox;
    [Singleton sharedManager].httpImageServiceSubmitDomain = kHttpImageServiceSubmitSandbox;
    [Singleton sharedManager].webServiceDomain = kWebServiceDomainSandbox;
}

- (void)configRootViewController {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    LaunchController *launchVC = [[LaunchController alloc] init];
    self.window.rootViewController = launchVC;

    [self launchEventWithCompletionHandle:^(LaunchOption launchOption) {
        if (launchOption == LaunchOptionGuide) {
            
//            GuideViewController *guideVC =[[GuideViewController alloc] init];
//            self.window.rootViewController = guideVC;
        }
        else {
        
//            TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//            self.window.rootViewController = tabbarCtrl;

//            MainDrawerController *mainVC = [[MainDrawerController alloc] init];
//            self.window.rootViewController = mainVC;
            
        }
    }];
}


- (void)configUMShare {

    //打开日志
    [[UMSocialManager defaultManager] openLog:NO];
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    
    // 获取友盟social版本号
    NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
 
    /*
     * 添加某一平台会加入平台下所有分享渠道，如微信：好友、朋友圈、收藏，QQ：QQ和QQ空间
     */
    
    //设置微信的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppID appSecret:kWXAppSecret redirectURL:kWXURL];
    
    //设置分享到QQ互联的appID
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppID  appSecret:kQQAppKey redirectURL:kQQURL];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:kWBAppKey  appSecret:kWBAppSecret redirectURL:kWBURL];
    
}

- (void)umengTrack {
    
    //    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setLogEnabled:NO];
    UMConfigInstance.appKey = kUMAppKey;
    //UMConfigInstance.secret = @"secretstringaldfkals";
    [MobClick startWithConfigure:UMConfigInstance];
}

- (void)configPgy {

    // 关闭用户反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PGYER_KEY_ID];
    
    // 检查更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGYER_KEY_ID];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
}

- (void)configMapKit {
    
    _locationManage = [[CLLocationManager alloc] init];
    _locationManage.distanceFilter = 10;
    _locationManage.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManage.delegate = self;
    
    // 请求定位授权
    [_locationManage requestAlwaysAuthorization];
    
    //启动LocationService
    if (![CLLocationManager locationServicesEnabled]) {
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"未成功定位，请先前往“系统设置->分销商城->位置“中开启本应用的定位服务" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCtrl addAction:actionSure];
        [self.window.rootViewController presentViewController:alertCtrl animated:YES completion:nil];
    }
    else {
        
        [_locationManage startUpdatingLocation];
    }
}

//配置极光推送
- (void)configJPushWithOptions:(NSDictionary *)launchOptions {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
        
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0) {
    
            [Singleton sharedManager].registrationID = registrationID;
            NSLog(@"registrationID获取成功：%@",registrationID);
            
            if ([UserDefaultsUtil isContainUserDefault]) {
                
                JPushRegIdApi *pushRegIdApi = [[JPushRegIdApi alloc] init];
                NSString *pushId = [Singleton sharedManager].registrationID;
                [pushRegIdApi setJPushRegIdJpushRegId:pushId callback:^(id resultData, NSInteger code) {
                    
                }];
            }
            
        }
        else {
            
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

#pragma mark - JPUSHRegisterDelegate
//  iOS 8 .9 后台进入前台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    
    
    // UIApplicationStateInactive 后台进入前台
    if (application.applicationState > 0) {
        
        [self handleAppBackgroundIntoForegroundNotification:userInfo];

        [[NSNotificationCenter defaultCenter] postNotificationName:kInActiveApplePushNotificaiton object:nil userInfo:userInfo];
    }
    // UIApplicationStateActive 在前台运行
    else if (application.applicationState == 0) {
        
        [self handleAppActiveInForegroundNotification:userInfo];

        [[NSNotificationCenter defaultCenter] postNotificationName:kActiveApplePushNotificaiton object:nil userInfo:userInfo];
    }
    

    completionHandler(UIBackgroundFetchResultNewData);
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
// iOS10 运行在前台接受消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
        

        [self handleAppActiveInForegroundNotification:userInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kActiveApplePushNotificaiton object:nil userInfo:userInfo];
        
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10后台进入前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kInActiveApplePushNotificaiton object:nil userInfo:userInfo];
     
        [self handleAppBackgroundIntoForegroundNotification:userInfo];
        
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);

    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


- (void)handleAppBackgroundIntoForegroundNotification:(NSDictionary*)userInfo {
    
    ApnsModel *apnsModel = [ApnsModel mj_objectWithKeyValues:userInfo];
    NSInteger type = [PASS_NULL_TO_NIL(apnsModel.type) integerValue];
    
    ApsTxtModel *txtModel = apnsModel.txt;
    
    //  1.推送好文
    //  2-7... 文章相关
    //  审核通过8
    
    MainDrawerController *mainVC = (MainDrawerController*)self.window.rootViewController;
    if (![mainVC isKindOfClass:[MainDrawerController class]]) {
        
        return;
    }
    
    TabbarViewController *tabbar = (TabbarViewController*)mainVC.centerViewController;
    NavigationController *tabNav = tabbar.viewControllers[tabbar.currentIndex];
    NavigationController *leftNav = (NavigationController*)mainVC.leftDrawerViewController;
    
    // 进入文章详情
    if (type == 1 || type == 2 || type == 4 || type == 5 || type == 8) {
        
        [mainVC closeDrawerAnimated:NO completion:nil];
        
        NSInteger articleId = [PASS_NULL_TO_NIL(txtModel.articleId) integerValue];
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.articleId = articleId;
        [tabNav pushViewController:detailVC animated:NO];
        
    }
    else if (type == 3 || type == 6 || type == 7) {
        
        [mainVC closeDrawerAnimated:NO completion:nil];
        
        NSInteger articleId = [PASS_NULL_TO_NIL(txtModel.articleId) integerValue];
        
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.articleId = articleId;
        [tabNav pushViewController:commentVC animated:NO];
        
    }
    // 审核未通过
    else if (type == 9) {
        
        [mainVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
        PersonArticleViewController *personArticleVC = [[PersonArticleViewController alloc] init];
        [leftNav pushViewController:personArticleVC animated:NO];
        
    }
    // 被关注
    else if (type == 10) {
        
        
    }
    // 群发公告
    else if (type == 11) {
        
        
        [mainVC closeDrawerAnimated:NO completion:nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@", kDomain,kWebUrlNoticeDetail,txtModel.noticeId];
        BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
        // webviewVC.titleStr = msgModel.noticeInfo.title;
        [webviewVC wkWebViewRequestWithURL:urlStr];
        
        [tabNav pushViewController:webviewVC animated:NO];
        
    }
    // 一句话通知
    else if (type == 12 ) {
        
        [mainVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
        PersonNoticeViewController *personNoticeVC = [[PersonNoticeViewController alloc] init];
        [leftNav pushViewController:personNoticeVC animated:NO];
    }

}

/* 2.8.1 获取用户消息列表
 * xiaocao.other.getMessageList
 * 列表类型：1系统通知，2文章动态，3推送好文。
 
 type
 1                           推送好文
 
 2               文章被点赞
 
 3               文章被评论
 
 4               文章被打赏
 
 5               文章被收藏
 
 6               评论被点赞
 
 7               评论被评论
 
 8   文章审核通过
 
 9   文章审核未通过
 
 10  被用户关注
 
 11  群发公告
 
 12  一句话通知
 
 */


- (void)handleAppActiveInForegroundNotification:(NSDictionary*)userInfo {
    
    ApnsModel *apnsModel = [ApnsModel mj_objectWithKeyValues:userInfo];
    ApsModel  *apsModel = apnsModel.aps;
    
    NSInteger type = [PASS_NULL_TO_NIL(apnsModel.type) integerValue];
    if (!(type == 1 || type ==8 || type ==9 || type ==11)) {
        return;
    }
    
    // 好文
    NSString *titleStr = @"温馨提示";
//    if (type == 1) {
//        
//         titleStr= @"系统推荐文章";
//    }
//    // 8,9 审核通过被拒
//    else if (type == 8) {
//        
//        titleStr= @"您的文章审核通过了";
//    }
//    // 群发公告
//    else if (type == 9) {
//        
//        titleStr= @"您的文章审核被拒了";
//    }
//    // 群发公告
//    else if (type == 11) {
//        
//        titleStr= @"";
//    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:apsModel.alert preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [self handleAppBackgroundIntoForegroundNotification:userInfo];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:yesAction];
    
    [alertController addAction:noAction];

    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = locations.lastObject;
    _myCoordinate = currentLocation.coordinate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationPlaceNotification object:currentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"定位失败: %@", error);
}



@end
