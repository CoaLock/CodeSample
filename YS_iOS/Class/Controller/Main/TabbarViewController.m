//
//  TabbarViewController.m
//  BS
//
//  Created by 崔露凯 on 16/3/31.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "TabbarViewController.h"

#import "NavigationController.h"

#import "HomeViewController.h"
#import "FocusViewController.h"
#import "AttentionViewController.h"
#import "ToolViewController.h"

#import <SDWebImageDownloader.h>
#import <SDWebImageManager.h>


#import "UIImage+Custom.h"

#import "PublishViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate>


@property (nonatomic, strong) UIButton *addButton;


@property (nonatomic, strong) UILabel *msgLabel;


@end

static inline void setStatusBarColor(void) {
    
    NSInteger style = [[Singleton sharedManager].app_style integerValue];
    if (style == 2) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        return;
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return;
}


@implementation TabbarViewController



- (NavigationController*)createNavWithTitle:(NSString*)title imgNormal:(NSString*)imgNormal imgSelected:(NSString*)imgSelected vcName:(NSString*)vcName {
    
    if (![vcName hasSuffix:@"ViewController"]) {
        vcName = [NSString stringWithFormat:@"%@ViewController", vcName];
    }
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:[UIImage imageNamed:imgSelected]];
    
//     tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    vc.tabBarItem = tabBarItem;
    
    return nav;
}


- (void)createSubControllers {
    
    // 首页
    NavigationController *homeNav = [self createNavWithTitle:@"首页" imgNormal:@"home_un_selected" imgSelected:@"home_selected" vcName:@"Home"];
    
    // 关注
    NavigationController *attentionNav = [self createNavWithTitle:@"关注" imgNormal:@"focus_un_selected" imgSelected:@"focus_selected" vcName:@"Attention"];
    //
    // 发布
    NavigationController *addNav = [self createNavWithTitle:@"" imgNormal:@"" imgSelected:@"" vcName:@"Base"];
    
    // 话题
    NavigationController *focusNav = [self createNavWithTitle:@"话题" imgNormal:@"attention_un_selected" imgSelected:@"attention_selected" vcName:@"Focus"];
    
    // 工具
    NavigationController *toolNav = [self createNavWithTitle:@"工具" imgNormal:@"tool_un_selected" imgSelected:@"tool_selected" vcName:@"Tool"];
    
    self.viewControllers = @[homeNav, attentionNav, addNav, focusNav,toolNav];
}


// 消息提示红点
- (UILabel *)msgLabel {
    if (_msgLabel == nil) {
        
        CGFloat widthButton = kScreenWidth/self.viewControllers.count;
        
        CGFloat msgX = widthButton*2.5 + 6;
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(msgX, 10, 6, 6)];
        _msgLabel.layer.cornerRadius = 3;
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.backgroundColor = [UIColor redColor];
        _msgLabel.hidden = YES;
        
        [self.tabBar addSubview:_msgLabel];
    }
   
    return _msgLabel;
}


- (void)createAddButton {
    
    CGFloat widthButton = kScreenWidth/self.viewControllers.count;
    if (_addButton == nil) {
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(2 *widthButton, 0, widthButton, 49);
        [_addButton addTarget:self action:@selector(addArticleOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:_addButton];
        
        UIImageView *addImgIcon = [[UIImageView alloc] initWithFrame:CGRectMake((widthButton -38)/2, (49-38)/2, 38, 38)];
        
        UIImage *image = [UIImage imageNamed:@"ic_add"];
        
        image = [image imageWithColor:kWhiteColor];
        
        addImgIcon.image = image;
        addImgIcon.layer.cornerRadius = 19;
        addImgIcon.layer.masksToBounds = YES;
        addImgIcon.contentMode = UIViewContentModeCenter;
        
        addImgIcon.backgroundColor = kTabbarMainColor;
        
        [_addButton addSubview:addImgIcon];
    }
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // kAppCustomMainColor
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kTabbarMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor] , NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [UITabBar appearance].tintColor = kTabbarMainColor;
   
    // [[UITabBar appearance] setBarTintColor:kBottomItemGrayColor];
    
   
    setStatusBarColor();
    
    
    // 创建子控制器
    [self createSubControllers];
 
    [self createAddButton];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

}


#pragma mark - Private
- (void)removeOriginTabbarButton {

    // 移除原来的按钮
    for (UIView *view in self.tabBar.subviews) {
        
        Class c = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:c]) {
            [view removeFromSuperview];
        }
    }
}


#pragma mark - Events
- (void)addArticleOnClick:(UIButton*)button {
    
    NavigationController *nav = self.viewControllers[self.selectedIndex];
    
    if (![UserDefaultsUtil isContainUserDefault]) {

        BaseViewController *topVc = (BaseViewController*)nav.topViewController;
        [topVc showReLoginVC];
        return;
    }

    
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    [nav pushViewController:publishVC animated:YES];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    NSLog(@"%li", self.currentIndex);
}


#pragma mark - Setter
- (void)setIsHaveMsg:(BOOL)isHaveMsg {

    _msgLabel.hidden = !isHaveMsg;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {

    _currentIndex = currentIndex;

    self.selectedIndex = _currentIndex;    
}



@end
