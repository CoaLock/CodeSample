//
//  BaseViewController.h
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlankDisplayView.h"


@interface BaseViewController : UIViewController <UIAlertViewDelegate>


// 无数据暂时页面
@property (nonatomic, strong) BlankDisplayView *blankView;


// 提示显示
- (void)showIndicatorOnWindow;

- (void)showIndicatorOnWindowWithMessage:(NSString *)message;

- (void)showTextOnly:(NSString *)text;

- (void)showErrorMsg:(NSString*)text;

- (void)hideIndicatorOnWindow;

- (void)showSuccessIndicator:(NSString*)text;



// 显示登录界面
- (void)showReLoginAlert;

- (void)showReLoginVC;


// 
- (BOOL)isRootViewController;

- (BOOL)isLogin;

- (void)dismissReLoginVC;




@end
