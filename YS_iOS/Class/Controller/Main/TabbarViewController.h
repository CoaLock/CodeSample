//
//  TabbarViewController.h
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarViewController : UITabBarController


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL isHaveMsg;


// 移除tabbar上原生的按钮, 一旦tabbar上按钮布局方式改变，按钮就会创建
- (void)removeOriginTabbarButton;


@end
