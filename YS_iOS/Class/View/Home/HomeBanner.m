//
//  HomeBanner.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "HomeBanner.h"

#import "CustomPageControl.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>



@interface HomeBanner ()


@property (nonatomic, strong) UIVisualEffectView *bgView;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;


@property (nonatomic, strong) UIButton *closeBtn;



@end


@implementation HomeBanner



#pragma mark - Initialization
- (void)_createSubviews {
    
    
    // 移除原来的 _pageControl, _scrollView重新创建
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    
    if (_scrollView) {
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _scrollView.layer.cornerRadius = 8;
    _scrollView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgOnClicked:)];
    [_scrollView addGestureRecognizer:tap];

    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = _imageNames.count;
    _pageControl.currentPageIndicatorTintColor = kAppCustomMainColor;
    _pageControl.pageIndicatorTintColor = kWhiteColor;
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_pageControl];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat scrollWidth = kScreenWidth -50*2;
    CGFloat scrollHeight = scrollWidth *(4/3.0);
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(-40);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(scrollHeight);
    }];
    
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(_scrollView.mas_bottom).mas_offset(0);
    }];
    
    
    UIImage *placeHoldler = [UIImage imageNamed:@"bg_no_content"];
    UIImageView *lastImgView = nil;
    
    for (NSInteger i = 0; i < _imageNames.count + 2; i++) {
        
        UIImageView *imageView =[[UIImageView alloc] init];
        if (i == 0) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageNames lastObject]] placeholderImage:placeHoldler];
        }
        else if (i < _imageNames.count + 1) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageNames[i-1]] placeholderImage:placeHoldler];
        }
        else {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:[_imageNames firstObject]] placeholderImage:placeHoldler];
        }
        
        [_scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastImgView == nil) {
                make.left.mas_equalTo(0);
            }
            else {
                make.left.equalTo(lastImgView.mas_right);
            }
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(scrollHeight);
            make.width.mas_equalTo(scrollWidth);
        }];
        
        
        lastImgView = imageView;
    }
    
    _scrollView.contentSize = CGSizeMake(scrollWidth * (_imageNames.count+2), 0);
    CGPoint point = CGPointMake(scrollWidth, 0);
    _scrollView.contentOffset = point;
    [_scrollView scrollRectToVisible:CGRectMake(scrollWidth,0,scrollWidth,scrollHeight) animated:NO];
    _scrollView.delegate = self;
    
    
    _pageControl.hidden = _imageNames.count< 2;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
        _bgView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _bgView.alpha = 0.4;
        [self addSubview:_bgView];
        
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.lk_attribute
        .normalImage([UIImage imageNamed:@"ic_close_white"])
        .event(self, @selector(closeAction:))
        .superView(self);
        
        CGFloat scrollWidth = kScreenWidth -50*2;
        CGFloat scrollHeight = scrollWidth *(4/3.0);

        
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.height.mas_equalTo(30);
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo((kScreenHeight +scrollHeight)/2 + 40 -40);
        }];
        
    }
    
    return self;
}


#pragma mark - Setter
- (void)setImageNames:(NSArray *)imageNames {
    
    _imageNames = imageNames;
    [self _createSubviews];
}


#pragma mark - Events
- (void)imgOnClicked:(UITapGestureRecognizer*)tap {
    
    if (_imgClickBlock) {
        _imgClickBlock(_pageControl.currentPage);
        
        [self hide];
    }
}


- (void)closeAction:(UIButton*)btn {

    [self hide];
}

- (void)hide {
    
    self.hidden = YES;
    [self removeFromSuperview];
}



// UIPagecontrol翻页
- (void)turnPage {
    
    _pageCounter = _pageControl.currentPage;
    
    CGFloat scrollWidth = kScreenWidth -50*2;

    
    [UIView animateWithDuration:0.2 animations:^{
        
        [_scrollView setContentOffset:CGPointMake(scrollWidth * (_pageCounter + 1), 0) animated:YES];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollWidth = kScreenWidth -50*2;

    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(scrollWidth * _imageNames.count, 0);
    }
    
    // 滚动到最后一张假图的时候 回到第一张真图
    if (scrollView.contentOffset.x >= (_imageNames.count + 1) *scrollWidth) {
        scrollView.contentOffset = CGPointMake(scrollWidth, 0);
    }
    // 重新计算page
    NSInteger page = self.scrollView.contentOffset.x / scrollWidth - 1;
    _pageControl.currentPage = page;
    _pageCounter = page;
}







@end
