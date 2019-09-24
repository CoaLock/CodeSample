//
//  SortOrderBar.m
//  BS
//
//  Created by 崔露凯 on 16/4/21.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "SortBar.h"

#define widthItem (kScreenWidth/5.0)

static const float kAnimationdDuration = 0.3;

@interface SortBar ()

@property (nonatomic, copy) SortSelectBlock sortBlock;

@property (nonatomic, strong) NSArray *sortNames;

@property (nonatomic, strong) UIView *selectLine;

@property (nonatomic, assign) NSInteger selectIndex;


@end

@implementation SortBar


- (void)initSubViews {
    
    _selectLine = [[UIView alloc] init];
    _selectLine.backgroundColor = [UIColor blackColor];
    [self addSubview:_selectLine];
    
    [_selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo((widthItem-40)/2.0);
        make.bottom.mas_equalTo(self.frame.size.height -1);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(1);
    }];
    
    [self createItems];
    
    [self changeItemTitleColorWithIndex:0];
}

- (void)createItems {

    self.contentSize = CGSizeMake(widthItem *_sortNames.count, self.frame.size.height);
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.titleLabel.font = Font(MIN(kWidth(15.0), 15));
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:kTextSecondLevelColor forState:UIControlStateNormal];
        [button setTitle:_sortNames[i] forState:UIControlStateNormal];
        [self addSubview:button];
        button.tag = 100 +i;
        
        [button addTarget:self action:@selector(sortBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(widthItem);
            make.left.mas_equalTo(widthItem*i);
        }];
    }
 
    // 强制刷新界面
    [self layoutIfNeeded];
}


- (instancetype)initWithFrame:(CGRect)frame sortNames:(NSArray*)sortNames sortBlock:(SortSelectBlock)sortBlock {
    if (self = [super initWithFrame:frame]) {
    
        self.backgroundColor = [UIColor whiteColor];
        _sortBlock = [sortBlock copy];
        
        _sortNames = [NSArray arrayWithArray:sortNames];
        self.showsHorizontalScrollIndicator = NO;
        
        [self initSubViews];
    }
    return self;
}


#pragma mark - Private
- (void)changeItemTitleColorWithIndex:(NSInteger)index {

    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIButton *btn = [self viewWithTag:100 + i];
        if (i == index) {
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = Font(MIN(kWidth(16.0), 16));
        }
        else {
        
            [btn setTitleColor:kTextSecondLevelColor forState:UIControlStateNormal];
            btn.titleLabel.font = Font(MIN(kWidth(15.0), 15));
        }
    }
}


#pragma mark - Public
- (void)selectSortBarWithIndex:(NSInteger)index {

    _selectIndex = index;
    
    UIButton *button = [self viewWithTag:100+index];
    
    CGFloat length = button.centerX - kScreenWidth/2;
    [self scrollRectToVisible:CGRectMake(length, 0, self.width, self.height) animated:YES];
    
    [UIView animateWithDuration:kAnimationdDuration animations:^{
        
        [_selectLine mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(button.left +(widthItem-40)/2.0);
        }];
        
        
        [self changeItemTitleColorWithIndex:button.tag - 100];
        
        [self layoutIfNeeded];
    }];
    
}

- (void)changeSortBarWithNames:(NSArray *)sortNames {

    _sortNames = [NSArray arrayWithArray:sortNames];
    
    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIButton *button = [self viewWithTag:100+i];
        [button setTitle:_sortNames[i] forState:UIControlStateNormal];
    }
}

- (void)resetSortBarWithNames:(NSArray*)sortNames selectIndex:(NSInteger)index {

    if (index < 0 && index > sortNames.count) {
        index = 0;
    }
    
    // 1.清空原来的选项
    [self clearLastItems];
    
    // 2.创建新的选项
    _sortNames = [NSArray arrayWithArray:sortNames];
    [self createItems];
    
    // 3.更改下划线位置
    [self selectSortBarWithIndex:index];
    
    //4.改变字体
    [self changeItemTitleColorWithIndex:index];
}

- (void)clearLastItems {

    for (NSInteger i = 0; i < _sortNames.count; i++) {
        
        UIView *subview = [self viewWithTag:100+i];
        [subview removeFromSuperview];
        subview = nil;
    }
}

#pragma mark - Events
- (void)sortBtnOnClicked:(UIButton*)button {
   // 相同按钮则不触发事件
    if (_selectIndex == button.tag - 100) {
        return;
    }
    
    _sortBlock(button.tag - 100);
    
    [self selectSortBarWithIndex:button.tag - 100];
}



@end
