
//
//  RewadListViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RewadListViewController.h"

#import "BaseTableView.h"

#import "RewardListCell.h"
#import "GetRewardListApi.h"

#import "UserModel.h"

static NSString *identifier = @"identifier";


@interface RewadListViewController () <RefreshTableViewDelegate, UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UIVisualEffectView *bgView;


@property (nonatomic, strong) UIView *containView;

@property (nonatomic, strong) BaseTableView *tableView;


@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) UserListModel *userListModel;



@end

@implementation RewadListViewController


#pragma mark - Init
- (void)initSubview {


    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    _bgView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _bgView.alpha = 0.4;
    [self.view addSubview:_bgView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_bgView addGestureRecognizer:tapGesture];

    
    _bgView.alpha = 0.001;

    _containView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 290)];
    _containView.backgroundColor = kWhiteColor;
    [self.view addSubview:_containView];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.lk_attribute
    .normalTitle(@"关闭")
    .font(16)
    .event(self, @selector(closeAction))
    .normalTitleColor(kAuxiliaryTipColor)
    .superView(_containView);
    
    closeBtn.frame = CGRectMake(12, 11, 40, 22);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, kScreenWidth, 22)];
    titleLabel.lk_attribute
    .text(@"读者打赏")
    .font(16)
    .textAlignment(NSTextAlignmentCenter)
    .textColor(kTextFirstLevelColor)
    .superView(_containView);
    
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 290 -45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:NO refreshFootEnable:YES autoRefresh:NO];
    [_containView addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"RewardListCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}


#pragma mark - Life  Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    
    
    [self initSubview];
    
    [self hide];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

#pragma mark - Private
- (void)getRewardList {

    GetRewardListApi *rewardListApi = [[GetRewardListApi alloc] init];
    [rewardListApi getRewaedListWithArticleId:_articleId firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _userListModel = [[UserListModel alloc] init];
                _userListModel.rewardList =  @[].mutableCopy;;
            }
            
            UserListModel *userListModel = [UserListModel mj_objectWithKeyValues:resultData];
            [_userListModel.rewardList addObjectsFromArray:userListModel.rewardList];
            
            
            [_tableView reloadData];
            
            
            // 有数据
            if (userListModel.rewardList.count >= kPageFetchNum) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
            
                [_tableView noDataTips];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Public
- (void)show {
    
    [self getRewardList];
    
    self.view.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        
        _bgView.alpha = 0.4;
        
        _containView.frame = CGRectMake(0, kScreenHeight - 290, kScreenWidth, 290);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _bgView.alpha = 0.001;
        
        _containView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 290);
    } completion:^(BOOL finished) {
        
        self.view.hidden = YES;
    }];
}


#pragma mark - Events
- (void)tapAction {

    [self hide];
}

- (void)closeAction {

    [self hide];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _userListModel.rewardList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.userModel = _userListModel.rewardList[indexPath.row];
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 65;
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullUp:(id)refreshTableView {

    [self getRewardList];
}





@end
