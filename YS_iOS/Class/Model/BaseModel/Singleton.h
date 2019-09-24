//
//  Singleton.h
//  AFNetworkingTool
//
//  Created by 崔露凯 on 15/11/15.
//  Copyright © 2015年 崔露凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface Singleton : NSObject

@property (nonatomic, strong) NSString *httpServiceDomain;  // 服务器地址

@property (nonatomic, strong) NSString *httpImageServiceDomain;  // 图片服务器地址
@property (nonatomic, strong) NSString *httpImageServiceSubmitDomain;

@property (nonatomic, strong) NSString *webServiceDomain;  // web服务器地址

@property (nonatomic, strong) NSString *phpSesionId;  //服务器返回的会话ID



@property (nonatomic, strong) NSString *userId;  //用户id

@property (nonatomic, strong) NSString *mobile;  //用户手机号

@property (nonatomic, strong) NSString *userPassward;  //用户密码

// 手机登录0， 1微信，2企鹅，3微博
@property (nonatomic, assign) NSInteger thirdLoginType; //第三方登录类型



@property (nonatomic, copy) NSString *registrationID; //极光推送的jpush_reg_id

@property (nonatomic, assign) NSInteger badge; //角标



// app配置项
@property (nonatomic, strong) NSString *customer_service_telephone;
@property (nonatomic, strong) NSString *app_style;
@property (nonatomic, strong) NSString *personal_background;
@property (nonatomic, strong) NSString *ios_verify;



//最新版本号
@property (nonatomic, copy) NSString *version;



+ (Singleton *)sharedManager;


- (void)checkUpdateWithVC:(BaseViewController *)vc;



@end
