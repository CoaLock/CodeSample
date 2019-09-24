//
//  GuideViewController.m
//  QinMaShangDao
//
//  Created by 崔露凯 on 15/11/6.
//  Copyright © 2015年 李华光. All rights reserved.
//

#import "GuideViewController.h"
#import "AppDelegate.h"
#import "TabbarViewController.h"

#import <WebKit/WebKit.h>
#define launchImgNum 2

#import "NavigationController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

#import "MainDrawerController.h"


@interface GuideViewController ()


@property (nonatomic, strong) UIScrollView *helpScrollView;

@property (nonatomic, strong) UIPageControl *page;

@end


@implementation GuideViewController


- (void)initSubViews {
    
    // 创建存放引导图片的数组
    _helpScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _helpScrollView.backgroundColor = [UIColor clearColor];
    _helpScrollView.pagingEnabled = YES;
    [_helpScrollView setShowsHorizontalScrollIndicator:NO];
    [_helpScrollView setShowsVerticalScrollIndicator:NO];
    _helpScrollView.bounces = NO;
    _helpScrollView.clipsToBounds = YES;
    _helpScrollView.contentSize = CGSizeMake(kScreenWidth * launchImgNum, kScreenHeight);
    _helpScrollView.delegate = self;
    
    for (int i = 0; i < 2; i++)
    {
        UIImageView *helpImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, _helpScrollView.frame.size.width, _helpScrollView.frame.size.height)];
        
        if (CGSizeEqualToSize(CGSizeMake(640, 1136), [UIScreen mainScreen].currentMode.size))
        {
            helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%d_1136",i+1]];
        }
        else if(CGSizeEqualToSize(CGSizeMake(750, 1334), [UIScreen mainScreen].currentMode.size))
        {
            helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%d_1334",i+1]];
        }
        else if(CGSizeEqualToSize(CGSizeMake(1242, 2208), [UIScreen mainScreen].currentMode.size))
        {
            helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%d_2208",i+1]];
        }
        else
        {
            helpImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%d_960",i+1]];
        }
        [_helpScrollView addSubview:helpImage];
        
        //创建进入按钮
        if (i == (1))
        {
            UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat width = (kScreenHeight*220/1334)*2*0.8;
            CGFloat heigth = (kScreenHeight*220/1334)*2*73/220*0.8 + 40;
            
            [enterBtn setFrame:CGRectMake((kScreenWidth-width)/2+kScreenWidth*i, _helpScrollView.height-130, width, heigth)];
            
            /* 调试按钮大小
            enterBtn.layer.borderColor = [UIColor orangeColor].CGColor;
            enterBtn.layer.borderWidth = 2;
            */
            
            [enterBtn addTarget:self action:@selector(introDidFinish:) forControlEvents:UIControlEventTouchUpInside];
            [_helpScrollView addSubview:enterBtn];
        }
    }
    [self.view addSubview:_helpScrollView];
    
    /*
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _helpScrollView.frame.size.height -50, _helpScrollView.frame.size.width, 30)];
    _page.numberOfPages = launchImgNum;
    [_page setHidden:YES];
    [self.view addSubview:_page];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)introDidFinish:(UIButton*)button {
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    MainDrawerController *mainVC = [[MainDrawerController alloc] init];
    appDelegate.window.rootViewController = mainVC;
    
//    TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
//    appDelegate.window.rootViewController = tabbarCtrl;

//    HomeViewController *homeVC = [[HomeViewController alloc] init];
//    NavigationController *navCtrl = [[NavigationController alloc] initWithRootViewController:homeVC];
//    appDelegate.window.rootViewController = navCtrl;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //    更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_page setCurrentPage:offset.x / bounds.size.width];
}



@end
