//
//  MainDrawerController.m
//  B2CShop
//
//  Created by 崔露凯 on 16/7/8.
//  Copyright © 2016年 beyondin. All rights reserved.
//

#import "MainDrawerController.h"

#import <SDWebImage/UIButton+WebCache.h>

#import "PersonViewController.h"
#import "TabbarViewController.h"


#define kLeftViewWidth (kScreenWidth-0)

@interface MainDrawerController ()

@end

@implementation MainDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = kWhiteColor;
    
    
    TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
    self.centerViewController = tabbarCtrl;
    
    PersonViewController *personVC = [[PersonViewController alloc] init];
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:personVC];
    self.leftDrawerViewController = navi;
    
    
    //设置左右控制器显示宽度
    [self setMaximumLeftDrawerWidth:kLeftViewWidth];
    
    //设置左右滑动，响应的范围
    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self setShowsShadow:NO];
    self.animationVelocity = 1200;

    
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
     
        
        
    }];
    
    [self setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {
       
        if (drawerController.openSide == MMDrawerSideNone) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kDrawVCCloseNotificaiton object:nil];
        }
        
    }];

    
    //设置左右控制器，切换时动画效果
   // [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
}


@end
