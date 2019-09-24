//
//  SettingViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SettingViewController.h"

#import "LogoutApi.h"

#import "SettingTableView.h"

#import "ChangePasswordViewController.h"
#import "ChangeMobileViewController.h"
#import "FeedbackViewController.h"
#import "AboutGrassViewController.h"

#import "CheckMobileViewController.h"

#import <SDImageCache.h>
#import <MBProgressHUD.h>

#import "EditUserInfoApi.h"
#import "UserInfoApi.h"


#import "UMShareView.h"


#import "CanlePublishTipView.h"


#import "MainDrawerController.h"


@interface SettingViewController ()


@property (nonatomic, strong) SettingTableView *tableView;

@property (nonatomic, strong) CanlePublishTipView *popupView;

@property (nonatomic, strong) UMShareView *shareView;



@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"设置"];
    
    [self initWithTableView];
    
    [self.popupView hide];
    
    [self initShareView];

    [self getUserInfo];
}

- (void)initWithTableView {

    GrassWeakSelf;
    
    _tableView = [[SettingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped settingBlock:^(SettingType settingType , id obj) {
        
        [weakSelf settingEvents:settingType obj:obj];
    }];
    
    [self.view addSubview:_tableView];
    
}

- (CanlePublishTipView *)popupView {
    if (_popupView == nil) {
        
        NSString *phone = [Singleton sharedManager].customer_service_telephone;
        STRING_NIL_NULL(phone);
        NSArray *titles = @[[NSString stringWithFormat:@"呼叫%@", phone], @"取消"];
        _popupView = [[CanlePublishTipView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) titles:titles];
        
        [_popupView setTitleColor:[UIColor colorWithHexString:@"#26B8F2"] index:0];
        
        UIView *containView = [[UIApplication sharedApplication].delegate window];
        [containView addSubview:_popupView];
        
        GrassWeakSelf;
        _popupView.eventBlock = ^(NSInteger index) {
            if (index == 0) {
                
                [weakSelf callPhone];
            }
            else if (index == 1) {
                
            }
        };
        
    }
    return _popupView;
}

- (void)initShareView {
    
    GrassWeakSelf;
    _shareView = [[UMShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) viewController:nil eventType:^(UMSocialPlatformType platType) {
        
        [weakSelf shareTextToPlatformType:platType];
    }];
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:_shareView];
}


#pragma mark - Private
- (void)getUserInfo {

    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:@"is_push" callback:^(id resultData, NSInteger code) {
        if (code == 0) {
           
            DICTIONARY_NIL_NULL(resultData);
            
            _tableView.isPush = ([PASS_NULL_TO_NIL(resultData[@"is_push"]) integerValue] == 1);
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Events
- (void)settingEvents:(SettingType)settingType obj:(id)obj {

    switch (settingType) {
            
        case SettingTypeChangePassword:
            
        {
            ChangePasswordViewController *changePasswordVC = [ChangePasswordViewController new];
            
            [self.navigationController pushViewController:changePasswordVC animated:YES];
        }
            break;
            
        case SettingTypeChangeMobile:
            
        {
            
            CheckMobileViewController *checkMobileVC = [[CheckMobileViewController alloc] init];
            [self.navigationController pushViewController:checkMobileVC animated:YES];
        }
            break;
            
        case SettingTypePush:
            
        {

            [self setPushStatus:[obj boolValue]];
            
        }
            break;
            
        case SettingTypeClearCache:
            
        {
            [self clearCache];
            
        }
            break;
            
        case SettingTypeShare:
            
        {
            [_shareView show];
            
        }
            break;
            
        case SettingTypeMobile:
            
        {
            
            [self.popupView show];
            
        }
            break;
            
        case SettingTypeFeedback:
            
        {
            FeedbackViewController *feedbackVC = [FeedbackViewController new];
            
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
            
        case SettingTypeAboutGrass:
            
        {
            AboutGrassViewController *aboutGrassVC = [AboutGrassViewController new];
            
            [self.navigationController pushViewController:aboutGrassVC animated:YES];
        }
            break;
           
        case SettingTypeNoPush:
            
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"要开启通知，您可以在“设置>通知>小草”中手动设置" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:submitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
       
        case SettingTypeSignOut:
            
        {
            
            [self userLogout];
            
        }
            break;
            
            
        default:
            break;
    }
}

- (void)callPhone {

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [Singleton sharedManager].customer_service_telephone]];
                  
    [[UIApplication sharedApplication] openURL:url];

}


- (void)userLogout {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"亲,真的要退出?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [self logout];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:submitAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)logout {

    LogoutApi *logoutApi = [[LogoutApi alloc] init];
    NSString *jPushId = [Singleton sharedManager].registrationID;
    jPushId = jPushId.length > 0 ? jPushId : @"123456";
    [logoutApi logoutWithJpushRegId:jPushId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            if ([PASS_NULL_TO_NIL(resultData) integerValue]) {
                
                [self showSuccessIndicator:@"已成功退出"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
                if ([mainVC isKindOfClass:[MainDrawerController class]]) {
                    
                    [mainVC closeDrawerAnimated:YES completion:nil];
                }
                
                
                // 1.设置未登录
                [UserDefaultsUtil removeUserLogin];
                
                
                
                // 2.清除用户记录
                [Singleton sharedManager].userId = @"";
                [Singleton sharedManager].mobile = @"";
                [Singleton sharedManager].userPassward = @"";
                
                [Singleton sharedManager].thirdLoginType = 0;
                
                [UserDefaultsUtil setUserDefaultName:@""];
                [UserDefaultsUtil setUserDefaultPassword:@""];
                
                
                // 3.清楚cookie
                [UserDefaultsUtil setUserDefaultCookie:@""];
                
                
            }
            
            
            
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}


- (void)clearCache {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.size = CGSizeMake(100, 100);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [[SDImageCache sharedImageCache] clearDisk];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"清除中...";
            
        });
        
        float progress = 0.0f;
        
        while (progress < 1.0f) {
            
            progress += 0.02f;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                hud.progress = progress;
            });
            usleep(50000);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageNamed:@"person_complete"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            imageView.frame = CGRectMake(0, 0, 35, 35);
            
            hud.customView = imageView;
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"清除完成";
            
            [_tableView reloadData];
            
            [hud hide:YES afterDelay:1];
        });
        
    });

}


- (void)setPushStatus:(BOOL)isPush {

    NSString *isPushStr = isPush ? @"1" : @"0";
    EditUserInfoApi *editUserInfoApi = [[EditUserInfoApi alloc] init];
    [editUserInfoApi editUserInfoWithField:@"is_push" value:isPushStr callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - UMShare
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType {
    
    
    UIImage *shareImg = [UIImage imageNamed:@"app_icon"];
    NSString *title = @"小草阅读";
    NSString *desc = @"加入草根小草,和我们一起阅读，交流...";
    
    NSString *link= [NSString stringWithFormat:@"%@%@", kDomain, kWebUrlShareApp];

    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:shareImg];
    shareObject.webpageUrl = link;
    
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.title = title;
    messageObject.text = desc;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        
        // UMSocialPlatformErrorType
        if (error) {
            
            if (error.code == 2009) {
                [self showErrorMsg:@"取消分享"];
            }
            else {
                [self showErrorMsg:@"分享失败"];
            }
        }
        else{
            
            [self showSuccessIndicator:@"分享成功"];
        }
    }];
}




@end
