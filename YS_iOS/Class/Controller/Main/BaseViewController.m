//
//  BaseViewController.m
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseApi.h"

#import "MBProgressHUD.h"

#import "NavigationController.h"
#import "TabbarViewController.h"
#import "LoginViewController.h"
#import "MainDrawerController.h"


#import <UMMobClick/MobClick.h>



@interface BaseViewController () <MBProgressHUDDelegate, UIGestureRecognizerDelegate>


@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) NSTimer       *overTimer;
@property (nonatomic, assign) NSInteger      downCount;


@end

@implementation BaseViewController



#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"小草"];
    
    [self setViewEdgeInset];
    
    
    // 设置导航栏背景色 
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:kNavBarBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // UIViewController的子控制器，不设置为pop手势代理
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
        
        if ([self isRootViewController]) {
            
            [mainVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        }
        else {
            [mainVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
        }
    }
}


#pragma mark - Private
// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}


#pragma mark - Public
- (BOOL)isRootViewController {
    return (self == self.navigationController.viewControllers.firstObject);
}

- (void)returnButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)overTimer:(NSTimer *)timer {
    
    _downCount--;
    if (_downCount == 0) {
        [BaseApi cancelAllRequest];
        [self hideIndicatorOnWindow];
    }
}

- (void)showReLoginAlert {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录已失效，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showReLoginVC];
    }];
    
    [alertCtrl addAction:submitAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)showReLoginVC {

    LoginViewController *loginVC = [[LoginViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)dismissReLoginVC {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isLogin {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
}


#pragma mark 网络加载提示
- (void)showIndicatorOnWindow {
    
    if (_progressHUD.superview) {
        return;
    }
    
    UIView *containView = [[UIApplication sharedApplication].delegate window];
    _progressHUD = [[MBProgressHUD alloc] initWithView:containView];
    [containView addSubview:_progressHUD];
    
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.labelText = @"加载中...";
    [_progressHUD show:YES];
    _progressHUD.cornerRadius = 4;
    
    
    _downCount = 10;
    _overTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(overTimer:) userInfo:nil repeats:YES];
}

- (void)showIndicatorOnWindowWithMessage:(NSString *)message {
    
    if (_progressHUD.superview) {
        return;
    }
    
    
    UIView *containView = [[UIApplication sharedApplication].delegate window];
    _progressHUD = [[MBProgressHUD alloc] initWithView:containView];
    [containView addSubview:_progressHUD];
    
    _progressHUD.cornerRadius = 4;

    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color = kBlackColor;
    
    _progressHUD.labelText = message;
    [_progressHUD show:YES];

}

- (void)showTextOnly:(NSString *)text {
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self showTextHUD:text];
    });
}

- (void)showTextHUD:(NSString *)text {

    if (_progressHUD.superview) {
        return;
    }
    
    UIView *containView = [[UIApplication sharedApplication].delegate window];
    _progressHUD = [MBProgressHUD showHUDAddedTo:containView animated:YES];
    
    _progressHUD.mode = MBProgressHUDModeText;
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    _progressHUD.labelText     = text;
    _progressHUD.margin        = 10.f;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color         = kBlackColor;
    _progressHUD.cornerRadius = 4;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_progressHUD hide:YES];
    });
}


- (void)showSuccessIndicator:(NSString*)text {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self showSuccessHUD:text];
    });
}


- (void)showSuccessHUD:(NSString*)text {
    
    if (_progressHUD.superview) {
        return;
    }
    
    UIView *containView = [[UIApplication sharedApplication].delegate window];
    _progressHUD = [MBProgressHUD showHUDAddedTo:containView animated:YES];
    
    _progressHUD.mode = MBProgressHUDModeCustomView;
    //_progressHUD.userInteractionEnabled = NO;
    _progressHUD.cornerRadius = 4;
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    _progressHUD.labelText     = text;
    _progressHUD.removeFromSuperViewOnHide = YES;
    _progressHUD.color         = kBlackColor;
    _progressHUD.labelFont = Font(14);
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_success"]];
    _progressHUD.customView = imgView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_progressHUD hide:YES];
    });
}


- (void)showErrorMsg:(NSString *)text {
    
    NSString *error_msg = PASS_NULL_TO_NIL(text);
    if (!error_msg) {
        error_msg = @"网络不太好";
    }
    
    [self performSelector:@selector(showTextOnly:) withObject:error_msg afterDelay:0.3];
}


- (void)hideIndicatorOnWindow {
    
    [_overTimer invalidate];
    _overTimer = nil;
    [_progressHUD hide:YES];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}




@end
