//
//  PersonFocusViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFocusViewController.h"

#import "PersonFocusTopicController.h"
#import "PersonFocusTagController.h"
#import "PersonFoucsAuthorController.h"

#define kHeadBarHeight 53

@interface PersonFocusViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedCtrl;
@property (nonatomic, strong) UIView             *headView;

@property (nonatomic, strong) UIScrollView *scrollView;


@end

@implementation PersonFocusViewController


#pragma mark -
- (void)initTopView {

    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadBarHeight)];
    _headView.backgroundColor = kWhiteColor;
    [self.view addSubview:_headView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.height -1, kScreenWidth, 1)];
    bottomLine.backgroundColor = kTextThirdLevelColor;
    [_headView addSubview:bottomLine];
    
    NSArray *itemTitles = @[@"标签", @"作者", @"话题"];
    _segmentedCtrl = [[UISegmentedControl alloc] initWithItems:itemTitles];

    _segmentedCtrl.tintColor = kTextThirdLevelColor;
    _segmentedCtrl.selectedSegmentIndex = 0;

    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:0];
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:1];
    [_segmentedCtrl setWidth:kWidth(80) forSegmentAtIndex:2];
    //_segmentedCtrl.frame = CGRectMake((kScreenWidth-241)/2.0, 12, 241, 30);

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

    NSArray *vcNames = @[@"PersonFocusTagController", @"PersonFoucsAuthorController", @"PersonFocusTopicController"];
    
    for (NSInteger i = 0; i < 3; i++) {
        
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

    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的关注"];
    
    
    [self initScrollView];
    
    [self addSubViewController];
    
    [self initTopView];
}


#pragma mark - Events
- (void)segmentViewClick:(UISegmentedControl*)sender {


    NSInteger index = sender.selectedSegmentIndex;
   
    [self startLoadDataWithIndex:index];
    
    [_scrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, _scrollView.height) animated:YES];

}


- (void)startLoadDataWithIndex:(NSInteger)index {

    if (index == 0) {
        
        PersonFocusTagController *tagVC = self.childViewControllers[0];
        [tagVC startLoadData];
    }
    else if (index == 1) {
        
        PersonFoucsAuthorController *authorVC = self.childViewControllers[1];
        [authorVC startLoadData];
    }
    else {
        
        PersonFocusTopicController *topicVC = self.childViewControllers[2];
        [topicVC startLoadData];
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSInteger index = targetContentOffset->x /kScreenWidth;
    
    _segmentedCtrl.selectedSegmentIndex = index;
    
    [self startLoadDataWithIndex:index];
}






@end
