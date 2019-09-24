//
//  NavigationController.m
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "NavigationController.h"
#import "TabbarViewController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[[UIImage imageNamed:@"ic_return_wihte"] imageWithColor:kNavBarMainColor] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleToFill;
        btn.frame = CGRectMake(0, 0, 11, 20);
        [btn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        self.navButton = btn;
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];        
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)clickButton {
    
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


@end
