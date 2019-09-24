//
//  FocusViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/19.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FocusViewController.h"

#import "PersonViewController.h"
#import "SearchViewController.h"

#import "TopicRecController.h"
#import "TopicMeController.h"

#import "NavLeftHeader.h"

#import "FocusTopicsTableView.h"

#import "UserInfoApi.h"
#import "UserModel.h"

#import "MainDrawerController.h"

#import "GetUnReadMessageNumApi.h"


@interface FocusViewController () <RefreshTableViewDelegate, UIScrollViewDelegate>


@property (nonatomic , strong) FocusTopicsTableView *topicsTableView;

@property (nonatomic, strong) NavLeftHeader *leftView;

@property (nonatomic, strong) UserModel *userModel;


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UISegmentedControl *segmentedView;


@end

@implementation FocusViewController


#pragma mark - Init
- (void)setupNavigationBarItemView {
    
    NavLeftHeader *navHeader = [[NavLeftHeader alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navHeader];
    _leftView = navHeader;
    
    [_leftView addTarget:self action:@selector(leftBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    NSArray *arraySegment = [NSArray arrayWithObjects:@"推荐",@"我的",nil];
    UISegmentedControl *segmentedView = [[UISegmentedControl alloc]initWithItems:arraySegment];
    [segmentedView setWidth:80.0 forSegmentAtIndex:0];
    [segmentedView setWidth:80.0 forSegmentAtIndex:1];
    segmentedView.tintColor = kNavBarMainColor;
    segmentedView.selectedSegmentIndex = 0;
    [segmentedView addTarget:self action:@selector(segmentViewClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedView;
    
    _segmentedView = segmentedView;
    
    [UIBarButtonItem addRightItemWithImageName:@"ic_search" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(searcBtnOnClicked)];
}


- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth *2, kScreenHeight - 64);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self.view addSubview:_scrollView];
    
    _scrollView.scrollEnabled = NO;
}

- (void)addSubViewController {

    NSArray *vcNames = @[@"TopicRecController", @"TopicMeController"];
    for (NSInteger i = 0; i < 2; i++) {
        
        UIViewController *childVC = [self createViewControllerWithVcName:vcNames[i]];
        [self addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64);
        [_scrollView addSubview:childVC.view];
        
        if (i == 1) {
            TopicMeController *vc = (TopicMeController*)childVC;
            
            GrassWeakSelf;
            vc.followTopicBlock = ^() {
            
                [weakSelf.scrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, weakSelf.scrollView.height) animated:YES];
                
                weakSelf.segmentedView.selectedSegmentIndex = 0;

            };
        }
        
        
    }
}

- (UIViewController*)createViewControllerWithVcName:(NSString*)vcName {
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    return vc;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];


    [self setupNavigationBarItemView];
    
    [self initScrollView];
    
    [self addSubViewController];
    
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


#pragma mark - Private
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

#pragma mark - Events
- (void)reloadUserData:(NSNotification*)notification {
    
    [self getUserInfo];
    [self getUnReadMessageNum];
}


- (void)leftBarButtonItemClick:(UIBarButtonItem*)barButton {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }

    
    MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
        
        [mainVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)segmentViewClick:(UISegmentedControl*)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 0) {
        
        TopicRecController *recVC = self.childViewControllers[0];
        [recVC startLoadData];
    }
    else {
        
        if (![UserDefaultsUtil isContainUserDefault]) {
            sender.selectedSegmentIndex = 0;
            [self showReLoginVC];
            return;
        }
        
        TopicMeController *meVC = self.childViewControllers[1];
        [meVC startLoadData];
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(kScreenWidth *index, 0, kScreenWidth, _scrollView.height) animated:YES];
}

- (void)searcBtnOnClicked {    
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger index = targetContentOffset->x /kScreenWidth;

    _segmentedView.selectedSegmentIndex = index;
}




@end
