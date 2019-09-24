//
//  PersonViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonViewController.h"

#import "BaseWKWebViewController.h"

#import "PersonView.h"

#import "GetUnReadMessageNumApi.h"


#import "UserInfoViewController.h"
#import "PersonNoticeViewController.h"
#import "PersonMoneyViewController.h"
#import "PersonArticleViewController.h"
#import "PersonCollectViewController.h"
#import "PersonFocusViewController.h"
#import "PersonHelpCenterViewController.h"
#import "SettingViewController.h"

#import "MainDrawerController.h"


#import "UserInfoApi.h"
#import "UserModel.h"


@interface PersonViewController ()

@property (nonatomic, strong) PersonView *personView;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self initWithPersonView];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self getUserInfo];
    
    [self getUnReadMsgNum];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Init 

- (void)initWithPersonView {

    GrassWeakSelf;
    
    _personView = [[PersonView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) personBlock:^(PersonType personType) {
        
        [weakSelf clickButtonWithPersonType:personType];
    }];
    
    [self.view addSubview:_personView];
}


#pragma mark - Private
- (void)getUserInfo {

    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:nil callback:^(id resultData, NSInteger code) {
        
        if (code == 0) {
         
            UserModel *userModel = [UserModel mj_objectWithKeyValues:PASS_NULL_TO_NIL(resultData)];
            
            [_personView loadUserInfo:userModel];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getUnReadMsgNum {
    
    GetUnReadMessageNumApi *unReadMsgNumApi = [[GetUnReadMessageNumApi alloc] init];
    [unReadMsgNumApi getUnReadMessageNumWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            _personView.msgDot.hidden = ([PASS_NULL_TO_NIL(resultData) integerValue] == 0);
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Events
- (void)clickButtonWithPersonType:(PersonType)personType {

    switch (personType) {
        case PersonTypeCancel:
            
        {
            
            MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            if ([mainVC isKindOfClass:[MainDrawerController class]]) {
                
                [mainVC closeDrawerAnimated:YES completion:^(BOOL finished) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDrawVCCloseNotificaiton object:nil];
                }];
            }
            
        }
            break;
            
        case PersonTypeInfo:
            
        {
            UserInfoViewController *userInfoVC = [UserInfoViewController new];
            
            [self.navigationController pushViewController:userInfoVC animated:YES];
        
        }
            break;
            
        case PersonTypeMessage:
            
        {
            PersonNoticeViewController *noticeVC = [PersonNoticeViewController new];
            
            [self.navigationController pushViewController:noticeVC animated:YES];
            
        }
            break;
            
        case PersonTypeMoney:
            
        {
            PersonMoneyViewController *moneyVC = [PersonMoneyViewController new];
            
            [self.navigationController pushViewController:moneyVC animated:YES];
            
        }
            break;
            
        case PersonTypeArticle:
            
        {
            PersonArticleViewController *articleVC = [PersonArticleViewController new];
            
            [self.navigationController pushViewController:articleVC animated:YES];
            
        }
            break;
            
        case PersonTypeCollect:
            
        {
            PersonCollectViewController *collectVC = [PersonCollectViewController new];
            
            [self.navigationController pushViewController:collectVC animated:YES];
            
        }
            break;
            
        case PersonTypeFollow:
            
        {
            PersonFocusViewController *focusVC = [PersonFocusViewController new];
            
            [self.navigationController pushViewController:focusVC animated:YES];
            
        }
            break;
            
        case PersonTypeHelpCenter:
            
        {
            
            PersonHelpCenterViewController *helpCenterVC = [[PersonHelpCenterViewController alloc] init];
            [self.navigationController pushViewController:helpCenterVC animated:YES];
            
        }
            break;
            
        case PersonTypeSetting:
            
        {
            SettingViewController *settingVC = [SettingViewController new];
            
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
