//
//  TopicViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentionViewController.h"

#import "MainDrawerController.h"

#import "PersonViewController.h"

#import "NavigationController.h"
#import "SearchViewController.h"

#import "NavLeftHeader.h"

#import "SortBar.h"

#import "AttentAuthorViewController.h"
#import "AttentTagViewController.h"

#import "UserInfoApi.h"

#import "UserModel.h"

#import "GetUnReadMessageNumApi.h"


@interface AttentionViewController ()  <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageVC;
@property (nonatomic, assign) BOOL isAuthor;

@property (nonatomic, strong) NSArray *vcList;


@property (nonatomic, strong) NavLeftHeader *leftView;

@property (nonatomic, strong) UserModel *userModel;

@end

@implementation AttentionViewController


#pragma mark - Init
- (void)initNavBar {
    
    // 1.left
    NavLeftHeader *leftView = [[NavLeftHeader alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    [leftView addTarget:self action:@selector(gotoPersonCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    _leftView = leftView;
    
    // 2.center
    NSArray *itemTitles = @[@"标签", @"作者"];
    UISegmentedControl *segmentedCtrl= [[UISegmentedControl alloc] initWithItems:itemTitles];
    segmentedCtrl.tintColor = kNavBarMainColor;
    segmentedCtrl.selectedSegmentIndex = 0;
    [segmentedCtrl setWidth:80 forSegmentAtIndex:0];
    [segmentedCtrl setWidth:80 forSegmentAtIndex:1
     ];
    [segmentedCtrl addTarget:self action:@selector(segmentViewClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedCtrl;
    
    _segmentedCtrl = segmentedCtrl;
    
    // 3.right
    [UIBarButtonItem addRightItemWithImageName:@"ic_search" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(searchBtnOnClicked:)];
}

- (void)initPageVC {
 
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    
    [_pageVC setViewControllers:@[self.vcList.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];

    _pageVC.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
    
    for (UIView *v in _pageVC.view.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)v).delegate = self;
            
            ((UIScrollView *)v).bounces = NO;

        }
    }
}


#pragma mark - Private
- (NSArray *)vcList {
    if (_vcList == nil) {
        
        AttentAuthorViewController *authorVC = [[AttentAuthorViewController alloc] init];
        AttentTagViewController *tagVC = [[AttentTagViewController alloc] init];
        
        _vcList = @[tagVC, authorVC];
    }
    return _vcList;
}

- (void)getUserInfo {
    
    UserInfoApi *userInfoApi = [[UserInfoApi alloc] init];
    [userInfoApi getUserInfoWithFields:@"" callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            _userModel = [UserModel mj_objectWithKeyValues:resultData];
            [_leftView loadUserInfo:_userModel];
        }
        else {
            [_leftView loadUserInfo:nil];
        }
    }];
}

- (void)getUnReadMessageNum {
    
    GetUnReadMessageNumApi *msgNumApi = [[GetUnReadMessageNumApi alloc] init];
    [msgNumApi getUnReadMessageNumWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            _leftView.msgDot.hidden = ([PASS_NULL_TO_NIL(resultData) integerValue] == 0);
        }
        else {
            
            _leftView.msgDot.hidden = YES;
        }
    }];
}


#pragma mark - mark
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"关注"];


    self.view.backgroundColor = RGB(244, 244, 244);
    
    [self initNavBar];
    
    [self initPageVC];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData:) name:kDrawVCCloseNotificaiton object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getUserInfo];
    
    [self getUnReadMessageNum];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Events
- (void)reloadUserData:(NSNotification*)notification {
    
    [self getUserInfo];
    [self getUnReadMessageNum];
}


- (void)gotoPersonCenter:(UIButton*)button {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }
    
    
    MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
        
        [mainVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)searchBtnOnClicked:(UIButton*)button {

    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)segmentViewClick:(UISegmentedControl*)sender {
    
    GrassWeakSelf;
    if (sender.selectedSegmentIndex == 0) {
        
        sender.userInteractionEnabled = NO;
        [_pageVC setViewControllers:@[_vcList[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            sender.userInteractionEnabled = YES;
            if (finished) {
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [weakSelf.pageVC setViewControllers:@[weakSelf.vcList[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];
//                });
            }
         
        }];

    }
    else {
        
        if (![UserDefaultsUtil isContainUserDefault]) {
            
            sender.selectedSegmentIndex = 0;
            [self showReLoginVC];
            return;
        }
        
        sender.userInteractionEnabled = NO;
        [_pageVC setViewControllers:@[_vcList[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            sender.userInteractionEnabled = YES;

            if (finished) {
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    
//                    [weakSelf.pageVC setViewControllers:@[weakSelf.vcList[1]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
//                });
            }
          
        }];
        
    }
}


- (void)selectAuthorVC {

    _segmentedCtrl.selectedSegmentIndex = 1;
    
    [_pageVC setViewControllers:@[_vcList[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
}


#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if (viewController == self.vcList[0]) {
        return nil;
    }
    return self.vcList[0];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    if (viewController == self.vcList[1]) {
        return nil;
    }
    return self.vcList[1];
}






@end
