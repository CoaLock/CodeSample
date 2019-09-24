//
//  PersonNoticeViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonNoticeViewController.h"

#import "SystemNoticeViewController.h"
#import "ArticleDynamicViewController.h"
#import "ArticlePushViewController.h"

#import "ReadAllMsgApi.h"

#import "JPUSHService.h"


#define kHeadBarHeight 53


@interface PersonNoticeViewController () <UIScrollViewDelegate>


@property (nonatomic, strong) UISegmentedControl *segmentedCtrl;
@property (nonatomic, strong) UIView             *headView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PersonNoticeViewController



#pragma mark -
- (void)initTopView {
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self.view addSubview:_headView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.height -1, kScreenWidth, 1)];
    bottomLine.backgroundColor = kTextThirdLevelColor;
    [_headView addSubview:bottomLine];
    
    NSArray *itemTitles = @[@"系统通知", @"文章动态", @"推送好文"];
    _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:itemTitles];
    
    _segmentedCtrl.tintColor = kTextThirdLevelColor;
    _segmentedCtrl.selectedSegmentIndex = 0;
    
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:0];
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:1];
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:2];
    
 
   // _segmentedCtrl.frame = CGRectMake((kScreenWidth-241)/2.0, 12, 241, 30);

    
    [_segmentedCtrl addTarget:self action:@selector(segmentViewClick:) forControlEvents:UIControlEventValueChanged];
    
    [_headView addSubview:_segmentedCtrl];
    
    [_segmentedCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}



- (void)initScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight - 64);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self.view addSubview:_scrollView];
}

- (void)addSubViewController {
    
    NSArray *vcNames = @[@"SystemNoticeViewController", @"ArticleDynamicViewController", @"ArticlePushViewController"];

    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIViewController *childVC = [self createViewControllerWithVcName:vcNames[i]];
        [self addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64);
        [_scrollView addSubview:childVC.view];
     
        
        if (i == 0) {
            
            SystemNoticeViewController *vc = (SystemNoticeViewController*)childVC;
            [vc startLoadData];
        }
        
    }
}

- (void)startLoadDataWithIndex:(NSInteger)index {

    UIViewController *vc = self.childViewControllers[index];
    if (index == 0) {
        
        SystemNoticeViewController *systemVC = (SystemNoticeViewController*)vc;
        [systemVC startLoadData];
        
    }
    else if (index == 1) {
    
        ArticleDynamicViewController *dynamicVC = (ArticleDynamicViewController*)vc;
        [dynamicVC startLoadData];
    
    }
    else if (index == 2) {
    
        ArticlePushViewController *pushVC = (ArticlePushViewController*)vc;
        [pushVC startLoadData];
    }
    
}


- (UIViewController*)createViewControllerWithVcName:(NSString*)vcName {
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    return vc;
}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的消息"];
    
    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 11, 20) vc:self action:@selector(dismissController:)];

    
    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initTopView];
    
}


#pragma mark - Events
- (void)segmentViewClick:(UISegmentedControl*)sender {
    
    
    NSInteger index = sender.selectedSegmentIndex;
    
    [self startLoadDataWithIndex:index];
    
    [_scrollView scrollRectToVisible:CGRectMake(kScreenWidth *index, 0, kScreenWidth, _scrollView.height) animated:YES];
    
}

- (void)dismissController:(UIButton*)button {
    
    ReadAllMsgApi *readAllMsgApi = [[ReadAllMsgApi alloc] init];
    [readAllMsgApi readAllMessageWith:^(id resultData, NSInteger code) {
       
        [self.navigationController popViewControllerAnimated:YES];
        
        [JPUSHService setBadge:0];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger index = targetContentOffset->x /kScreenWidth;

    _segmentedCtrl.selectedSegmentIndex = index;
    
    [self startLoadDataWithIndex:index];
}




@end
