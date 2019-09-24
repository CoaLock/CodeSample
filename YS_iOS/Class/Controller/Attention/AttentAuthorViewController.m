//
//  AttentAuthorViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentAuthorViewController.h"


#import "AttentTopAuthorViewController.h"
#import "RecAuthorViewController.h"

#import "SortBar.h"

#import "GetFollowListApi.h"

#import "UserModel.h"


static const CGFloat sortBarHeight = 45;


@interface AttentAuthorViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *sortNames;
@property (nonatomic, strong) SortBar *sortBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UserListModel *userListModel;

@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) UIView *addBg;


@end

@implementation AttentAuthorViewController

#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"ic_attent_author" title:@"您还没有关注任何作者哦" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
        [blankView.skipBtn setTitle:@"立即关注" forState:UIControlStateNormal];
        
        blankView.skipBtn.hidden = NO;
        [blankView.skipBtn addTarget:self action:@selector(attentAuthor:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self.blankView;
}


- (void)initSortBar {
    
    GrassWeakSelf;
    _sortBar = [[SortBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, sortBarHeight) sortNames:_sortNames sortBlock:^(NSInteger index) {
        
        [weakSelf changeSelectVCWithIndex:index];
        
        self.view.userInteractionEnabled = NO;
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, weakSelf.scrollView.height) animated:YES];
    }];
    
    [self.view addSubview:_sortBar];
    
    
    UIView *addBg = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth -60, 0, 60, sortBarHeight)];
    addBg.lk_attribute
    .superView(self.view);
    
    _addBg = addBg;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5].CGColor, (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor, (__bridge id)[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    gradientLayer.locations = @[@0, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = addBg.bounds;
    [addBg.layer addSublayer:gradientLayer];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(addBg.width -30, (sortBarHeight -20)/2, 20, 20);
    btn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_add"])
    .font(15)
    .backgroundColor([UIColor clearColor])
    .event(self, @selector(attentAuthor:))
    .superView(addBg);
    
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
    
    for (UIViewController *subVC in self.childViewControllers) {
        
        [subVC.view removeFromSuperview];
        [subVC removeFromParentViewController];
    }
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        
        UserModel *userModel = _userListModel.followList[i];

        AttentTopAuthorViewController *childVC = [[AttentTopAuthorViewController alloc] init];
        [self addChildViewController:childVC];
        
        childVC.userId = [PASS_NULL_TO_NIL(userModel.userId) integerValue];

        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64 - 49);
        [_scrollView addSubview:childVC.view];
        
        if (i == 0) {
            
            AttentTopAuthorViewController *topVC = self.childViewControllers[0];
            [topVC startLoadData];
        }

        
    }
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _sortNames = @[];
    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initSortBar];
    
    [self getTagList];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
}



- (void)getTagList {
    
    
    GetFollowListApi *getFollowListApi = [[GetFollowListApi alloc] init];
    [getFollowListApi getFollowListWithType:2 firstRow:_firstRow fetchNum:20 callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _userListModel = [UserListModel mj_objectWithKeyValues:resultData];
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            _scrollView.hidden = (_userListModel.followList.count==0);
            _sortBar.hidden = (_userListModel.followList.count==0);
            _addBg.hidden = (_userListModel.followList.count==0);;
            [[self createBlankView] shouldShow:(_userListModel.followList.count==0)];
            
            
            UserModel *allUserModel = [[UserModel alloc] init];
            allUserModel.nickname = @"全部";
            allUserModel.userId = @"0";
            
            [_userListModel.followList insertObject:allUserModel atIndex:0];
            
            [self tagChangeAction];
        }
        else {
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)tagChangeAction {
    
    NSMutableArray *userNames = @[].mutableCopy;
    for (UserModel *userModel in _userListModel.followList) {
        
        [userNames addObject:userModel.nickname];
    }
    _sortNames = userNames;
    [_sortBar resetSortBarWithNames:_sortNames selectIndex:0];
    
    _scrollView.contentSize = CGSizeMake(kScreenWidth * _sortNames.count, kScreenHeight - 64 - 49);
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    
    [self addSubViewController];
    
}

- (void)changeSelectVCWithIndex:(NSInteger)index {
    
    AttentTopAuthorViewController *topVC = self.childViewControllers[index];
    [topVC startLoadData];
}


#pragma mark - Events
- (void)attentAuthor:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }

    
    RecAuthorViewController *recAuthorVC = [[RecAuthorViewController alloc] init];
    [self.navigationController pushViewController:recAuthorVC animated:YES];
    
    recAuthorVC.returnBlock = ^() {
    
        [self getTagList];
    };
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger index = targetContentOffset->x /kScreenWidth;
    [_sortBar selectSortBarWithIndex:index];
    
    [self changeSelectVCWithIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.view.userInteractionEnabled = YES;
}




@end
