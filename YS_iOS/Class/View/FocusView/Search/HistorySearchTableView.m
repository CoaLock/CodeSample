//
//  HistorySearchTableView.m
//  BS
//
//  Created by 张阳 on 16/4/14.
//  Copyright © 2016年 崔露凯. All rights reserved.
//

#import "HistorySearchTableView.h"

#import "TagModel.h"

// 头视图
#import "TextDetailView.h"

#import "GBTagListView.h"

#import "DynamicLabel.h"


static NSString * historyCellId = @"historyCellId";
static NSString * keyCellId = @"keyCellId";



@interface HistorySearchTableView ()



@property (nonatomic, assign) CGFloat cellHeightRecord;
@property (nonatomic, assign) CGFloat cellHeightHot;

@property (nonatomic, strong) DynamicLabel *recordListView;

@property (nonatomic, strong) DynamicLabel *hotListView;


@end


@implementation HistorySearchTableView




#pragma mark - Init
- (UIView *)setupTableFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 54)];
    footerView.backgroundColor = kBackgroundColor;
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.lk_attribute
    .font(14)
    .backgroundColor([UIColor whiteColor])
    .normalTitle(@"清除历史记录")
    .event(self, @selector(clickHistory))
    .normalTitleColor(kAuxiliaryTipColor)
    .superView(footerView);
    
    UIView *lineH = [[UIView alloc] init];
    lineH.lk_attribute
    .backgroundColor(kSeperateLineColor)
    .superView(footerView);
    
    [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    return footerView;
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style clearSearchBlock:(ClearSearchBlock)clearSearchBlock {
    if (self = [super initWithFrame:frame style:style]) {
        

        self.backgroundColor = [UIColor whiteColor];

        
        self.clearSearchBlock   = clearSearchBlock;
        
        
        // 初始化历史记录 热门词汇列表
        self.recordList    = @[].mutableCopy;
        self.hotList       = @[].mutableCopy;
        
        
        
        self.delegate   = self;
        self.dataSource = self;
        
        
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:historyCellId];
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:keyCellId];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}


#pragma mark - Public
- (void)reloadRecordList:(NSMutableArray*)recordList hotList:(NSMutableArray*)hotlist {

    _recordList = recordList;
    _hotList = hotlist;
    
    
    // 历史
    
    
    GrassWeakSelf;
    if (_recordListView.superview) {
        [_recordListView removeFromSuperview];
    }
    if (_hotListView.superview) {
        [_hotListView removeFromSuperview];
    }
    
    DynamicLabel *recordListView = [[DynamicLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20) titleNames:_recordList needSelected:YES heightChangeBlock:^(CGFloat height) {
       
        weakSelf.cellHeightRecord = height;
    }];
    
    recordListView.tagChangeBlock = ^(UIButton *button, NSInteger index) {
    
        TagModel *tagModel = weakSelf.recordList[index];
        weakSelf.tagClickBlock(tagModel.tagName);
    };

    _recordListView = recordListView;

    
    // 热门
    DynamicLabel *hotListView = [[DynamicLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20) titleNames:_hotList needSelected:YES heightChangeBlock:^(CGFloat height) {
        
        
        weakSelf.cellHeightHot = height;
    }];
    
    
    hotListView.tagChangeBlock = ^(UIButton *button, NSInteger index) {
        
        TagModel *tagModel = weakSelf.hotList[index];
        weakSelf.tagClickBlock(tagModel.tagName);
    };
    
    _hotListView = hotListView;


    [self reloadData];
}


#pragma mark - Events
- (void)clickHistory {
    
    if (self.clearSearchBlock) {
        
        self.clearSearchBlock();
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:historyCellId];
        
        if (_recordListView.superview == nil) {
            
            [cell.contentView addSubview:_recordListView];
        }
        

    }
    
    
    if (indexPath.section == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:keyCellId];

        if (_hotListView.superview == nil) {
            [cell.contentView addSubview:_hotListView];
        }
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (_recordList.count == 0) {
            return 0.0001;
        }

        return _cellHeightRecord < 100 ? 100: _cellHeightRecord ;
        
    }else {
        
        return _cellHeightHot + 100;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_recordList.count == 0 && section == 0) {
        return 0.0001;
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if (_recordList.count == 0) {
            return 0.0001;
        }
        
        return 54;
    }
    return 0.0001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TextDetailView *historyTitleL = [[TextDetailView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45) text:@"历史记录"];
    if (section == 0) {
        
        historyTitleL.textLabel.text = @"历史记录";
    }
    else if (section == 1) {
        
        historyTitleL.textLabel.text = @"热门搜索";
    }
    
    return historyTitleL;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
         return [self setupTableFooterView];
    }
    return nil;
}




@end
