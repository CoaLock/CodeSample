//
//  HomeViewController.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "HomeViewController.h"

#import "MainDrawerController.h"

#import "AppDelegate.h"
#import "NavigationController.h"
#import "PersonViewController.h"

#import "SortBar.h"
#import "HomeChildViewController.h"
#import "SearchViewController.h"

#import "DetailViewController.h"

#import "NavLeftHeader.h"

#import "UploadImageApi.h"


#import "LoginViewController.h"

#import "ThirdPartLoginApi.h"

#import "BindMobileViewController.h"


#import "GArticleModel.h"

#import "ArticleListApi.h"

#import "UserInfoApi.h"

#import "HomeBanner.h"

#import "GetFlashListApi.h"

#import "FlashModel.h"

#import "GetUnReadMessageNumApi.h"

#import <MMDrawerVisualState.h>


static const CGFloat sortBarHeight = 45;

@interface HomeViewController () <UIScrollViewDelegate>


@property (nonatomic, strong) NavLeftHeader *leftView;

@property (nonatomic, strong) SortBar *sortBar;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *sortNames;


@property (nonatomic, assign) BOOL isSelected;


@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) GArticleListModel *topArticleListModel;

@property (nonatomic, strong) HomeBanner *banner;


@property (nonatomic, strong) NSArray *flashList;


@end

@implementation HomeViewController


#pragma mark - Init
- (void)initSortBar {

    NSArray *sortNames = @[@"推荐", @"最新", @"最热", @"精选"];
    
    GrassWeakSelf;
    _sortBar = [[SortBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5.0 *4, sortBarHeight) sortNames:sortNames sortBlock:^(NSInteger index) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, weakSelf.scrollView.height) animated:YES];
        
        HomeChildViewController *childVC = weakSelf.childViewControllers[index];
        [childVC startLoadingDataWithTopModel:weakSelf.topArticleListModel];
    }];
    [self.view addSubview:_sortBar];
    
    
    UIView *switchBg = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/5.0 *4, 0, kScreenWidth/5.0, sortBarHeight)];
    switchBg.lk_attribute
    .backgroundColor([UIColor whiteColor])
    .superView(self.view);
    
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 1, 30)];
    lineH.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(switchBg);

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((kScreenWidth/5 -17)/2, (sortBarHeight - 17)/2, 17, 17);
    btn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_grid"])
    .selectImage([UIImage imageNamed:@"ic_list"])
    .event(self, @selector(changeLayout:))
    .superView(switchBg);
    
    [btn setEnlargeEdge:10];
}

- (void)initScrollView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -sortBarHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _sortNames.count, kScreenHeight - 64 - 49);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view insertSubview:_scrollView belowSubview:_sortBar];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self.view addSubview:_scrollView];
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        HomeChildViewController *childVC = [[HomeChildViewController alloc] init];
        [self addChildViewController:childVC];
        
        childVC.tag = i +100;
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64 - 49);
        [_scrollView addSubview:childVC.view];
        
        if (i == 0) {
            [childVC startLoadingDataWithTopModel:_topArticleListModel];
        }
        
    }
}

- (void)initNavBar {
    
    NavLeftHeader *leftView = [[NavLeftHeader alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    _leftView = leftView;
    
    [leftView addTarget:self action:@selector(clickToPersonCenter) forControlEvents:UIControlEventTouchUpInside];
    
    
    [UIBarButtonItem addRightItemWithImageName:@"ic_search" frame:CGRectMake(0, 0, 20, 20) vc:self action:@selector(searcBtnOnClicked)];
}

- (void)initBanner {

    NSMutableArray *imgNames = @[].mutableCopy;
    for (FlashModel *flashModel in _flashList) {
        [imgNames addObject:flashModel.pic];
    }
    
    HomeBanner *homeBanner = [[HomeBanner alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    homeBanner.imageNames = imgNames;
    [[UIApplication sharedApplication].windows.lastObject addSubview:homeBanner];
    
    GrassWeakSelf;
    homeBanner.imgClickBlock = ^(NSInteger index) {
    
        FlashModel *model = weakSelf.flashList[index];
        NSInteger articleId = [PASS_NULL_TO_NIL(model.articleId) integerValue];
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.articleId = articleId;
        [weakSelf.navigationController pushViewController:detailVC animated:YES];
        
    };
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

   _sortNames = @[@"全部", @"军事", @"生活", @"动画"];
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"小草"];
    
    _topArticleListModel = [[GArticleListModel alloc] init];
    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initSortBar];

    
    [self initNavBar];
    
  //  [self initBanner];

    [self getBannerList];
   
    
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

- (void)getTopArticleList {
    
    // 文章属性：0最新，1置顶，2推荐，3精选。默认0。
    ArticleListApi *articleListApi = [[ArticleListApi alloc] init];
    [articleListApi getHotArticleListWithType:1 firstRow:0 fetchNum:5 callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)getBannerList {

    GetFlashListApi *flashListApi = [[GetFlashListApi alloc] init];
    [flashListApi getFlashListWithCallback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            ARRAY_NIL_NULL(resultData);
            _flashList = [FlashModel mj_objectArrayWithKeyValuesArray:resultData];
            
            if (_flashList.count > 0) {
                [self initBanner];
            }
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - Events
- (void)hanleAppInActiveNotification:(NSNotification*)notification {



}

- (void)hanleAppActiveNotification:(NSNotification*)notification {

    
}

- (void)reloadUserData:(NSNotification*)notification {

    [self getUserInfo];
    [self getUnReadMessageNum];
}


- (void)changeLayout:(UIButton*)btn {

    btn.selected = !btn.selected;
    _isSelected = !_isSelected;

    
    UIViewAnimationOptions opt = btn.selected ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    
    [UIView transitionWithView:btn duration:0.8 options:opt animations:nil completion:nil];
    
    NSArray *children = self.childViewControllers;
    for (HomeChildViewController *childVC in children) {
        
        childVC.isSelect = _isSelected;
        [childVC reloadData];
    }
    
}

- (void)clickToPersonCenter {
    
    NSLog(@"点击进入个人中心");
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }
    NSLog(@"已登录，点击进入个人中心");

    
    MainDrawerController *mainVC = (MainDrawerController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
        
        [mainVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (void)searcBtnOnClicked {

    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger index = targetContentOffset->x /kScreenWidth;
    [_sortBar selectSortBarWithIndex:index];
    
    HomeChildViewController *childVC = self.childViewControllers[index];
    [childVC startLoadingDataWithTopModel:_topArticleListModel];
}



@end
