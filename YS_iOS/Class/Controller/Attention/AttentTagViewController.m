//
//  AttentTagViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentTagViewController.h"
#import "AttentTopViewController.h"
#import "RecTagViewController.h"

#import "SortBar.h"


#import "GetFollowListApi.h"
#import "TagModel.h"


static const CGFloat sortBarHeight = 45;


@interface AttentTagViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *sortNames;
@property (nonatomic, strong) SortBar *sortBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TagListModel *tagListModel;

@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) UIView *addBg;



@end

@implementation AttentTagViewController



#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"ic_attent_lable" title:@"您还没有关注任何标签哦" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
        [blankView.skipBtn setTitle:@"立即关注" forState:UIControlStateNormal];
        
        blankView.skipBtn.hidden = NO;
        [blankView.skipBtn addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self.blankView;
}


- (void)initSortBar {
    
    GrassWeakSelf;
    _sortBar = [[SortBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth -40, sortBarHeight) sortNames:_sortNames sortBlock:^(NSInteger index) {
        
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, weakSelf.scrollView.height) animated:YES];
       
        weakSelf.view.userInteractionEnabled = NO;

        [weakSelf changeSelectVCWithIndex:index];
    }];
    
    [self.view addSubview:_sortBar];
    
    
    UIView *addBg = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth -60, 0, 60, sortBarHeight)];
    addBg.lk_attribute
    .backgroundColor(kWhiteColor)
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
    .event(self, @selector(addTag:))
    .superView(addBg);
    
    [btn setEnlargeEdge:10];
}


- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - sortBarHeight)];
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
        
        TagModel *tagModel = _tagListModel.followList[i];
        AttentTopViewController *childVC = [[AttentTopViewController alloc] init];
       
        childVC.tagId = [PASS_NULL_TO_NIL(tagModel.tagId) integerValue];
        
        [self addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64 - 49);
        [_scrollView addSubview:childVC.view];
     
        if (i == 0) {
            
            AttentTopViewController *topVC = self.childViewControllers[0];
            [topVC startLoadData];
        }
        
    }
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    _sortNames = @[].mutableCopy;
    
    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initSortBar];
    
    [self getTagList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

#pragma mark - Private


- (void)getTagList {
    
    
    GetFollowListApi *getFollowListApi = [[GetFollowListApi alloc] init];
    [getFollowListApi getFollowListWithType:1 firstRow:_firstRow fetchNum:100 callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _tagListModel = [TagListModel mj_objectWithKeyValues:resultData];

            
            
            TagModel *allTagModel = [[TagModel alloc] init];
            allTagModel.tagName = @"综合";
            allTagModel.tagId = @"0";
            
            [_tagListModel.followList insertObject:allTagModel atIndex:0];
            
            [self tagChangeAction];
        }
        else if (code == 55555) {
        
            
        }
        else {
            [self showErrorMsg:resultData[@"msg"]];
        }
        
        
        
        // 显示tableView
        if ([self createBlankView].superview == nil) {
            [self.view addSubview:[self createBlankView]];
        }
        _scrollView.hidden = (_tagListModel.followList.count==0);
        _sortBar.hidden = (_tagListModel.followList.count==0);
        _addBg.hidden = (_tagListModel.followList.count==0);;
        [[self createBlankView] shouldShow:(_tagListModel.followList.count==0)];
        
    }];
}


- (void)tagChangeAction {

    NSMutableArray *tagNames = @[].mutableCopy;
    for (TagModel *tagModel in _tagListModel.followList) {
        
        [tagNames addObject:tagModel.tagName];
    }
    _sortNames = tagNames;
    [_sortBar resetSortBarWithNames:_sortNames selectIndex:0];

    _scrollView.contentSize = CGSizeMake(kScreenWidth * _sortNames.count, kScreenHeight - 64 - 49);

    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    
    [self addSubViewController];
    
}

- (void)changeSelectVCWithIndex:(NSInteger)index {

    
    AttentTopViewController *topVC = self.childViewControllers[index];
    [topVC startLoadData];
}

#pragma mark - Events
- (void)addTag:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }
    
    
    RecTagViewController *recTagVC = [[RecTagViewController alloc] init];
    [self.navigationController pushViewController:recTagVC animated:YES];
    
    recTagVC.returnBlock = ^(NSMutableArray *tagList) {
    
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
