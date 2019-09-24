//
//  PersonArticleViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonArticleViewController.h"
#import "ArticleVerifiedViewController.h"
#import "ArticleUnVerifiedViewController.h"

#define kHeadBarHeight 53


@interface PersonArticleViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedCtrl;
@property (nonatomic, strong) UIView             *headView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PersonArticleViewController


#pragma mark -
- (void)initTopView {
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self.view addSubview:_headView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.height -1, kScreenWidth, 1)];
    bottomLine.backgroundColor = kSeperateLineColor;
    [_headView addSubview:bottomLine];
    
    NSArray *itemTitles = @[@"已审核", @"待审核"];
    _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:itemTitles];
    
    _segmentedCtrl.tintColor = kTextThirdLevelColor;
    _segmentedCtrl.selectedSegmentIndex = 0;
    
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:0];
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:1];
   // _segmentedCtrl.frame = CGRectMake((kScreenWidth -160)/2.0, 12, 160, 30);

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
    _scrollView.contentSize = CGSizeMake(kScreenWidth *2, kScreenHeight - 64);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view insertSubview:_scrollView belowSubview:_headView];
    
    _scrollView.contentOffset = CGPointMake(kScreenWidth*0, 0);
    [self.view addSubview:_scrollView];
    
    
    _scrollView.scrollEnabled = NO;
}

- (void)addSubViewController {
    
    NSArray *vcNames = @[@"ArticleVerifiedViewController", @"ArticleUnVerifiedViewController"];
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIViewController *childVC = [self createViewControllerWithVcName:vcNames[i]];
        [self addChildViewController:childVC];
        
        childVC.view.frame = CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight - 64);
        [_scrollView addSubview:childVC.view];
        
    }
}

- (UIViewController*)createViewControllerWithVcName:(NSString*)vcName {
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    return vc;
}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的文章"];

    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initTopView];
    
    
    ArticleVerifiedViewController *auditedVC = self.childViewControllers[0];
    [auditedVC startLoadData];
}

#pragma mark - Events
- (void)segmentViewClick:(UISegmentedControl*)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 0) {
     
        ArticleVerifiedViewController *auditedVC = self.childViewControllers[0];
        [auditedVC startLoadData];
    }
    else {
    
        ArticleUnVerifiedViewController *unAuditedVC = self.childViewControllers[1];
        [unAuditedVC startLoadData];
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(kScreenWidth *index, 0, kScreenWidth, _scrollView.height) animated:YES];
}



@end
