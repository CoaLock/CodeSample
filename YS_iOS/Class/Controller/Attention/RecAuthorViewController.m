//
//  RecAuthorViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/30.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RecAuthorViewController.h"
#import "AttentAuthorTable.h"


#import "GetAuthorListApi.h"

#import "UserModel.h"


#import "DoFollowApi.h"


@interface RecAuthorViewController () <RefreshTableViewDelegate>

@property (nonatomic, strong) AttentAuthorTable *tableView;


@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UserListModel *userListModel;


@end

@implementation RecAuthorViewController



#pragma mark - Init
- (void)initTableView {

    _tableView = [[AttentAuthorTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [_tableView setRefreshDelegate:self refreshHeadEnable:NO refreshFootEnable:NO autoRefresh:NO];
    [self.view addSubview:_tableView];
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = [UILabel labelWithTitle:@"推荐作者"];
    
    [UIBarButtonItem addLeftItemWithImageName:@"ic_return_wihte" frame:CGRectMake(0, 0, 40, 20) vc:self action:@selector(returnAction)];

    
    
    [self initTableView];
    
    [self getAuthorList];
}


#pragma mark - Private
- (void)getAuthorList {

    GetAuthorListApi *authorListApi = [[GetAuthorListApi alloc] init];
    [authorListApi getAuthorListWithFirstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        DICTIONARY_NIL_NULL(resultData);
        if (_firstRow == 0) {
            
            _userListModel = [[UserListModel alloc] init];
            _userListModel.userList =  @[].mutableCopy;;
        }
        
        UserListModel *userListModel = [UserListModel mj_objectWithKeyValues:resultData];
        [_userListModel.userList addObjectsFromArray:userListModel.userList];
        
        
        _tableView.userListModel = _userListModel;        
        
        // 有数据
        if (userListModel.userList.count >= 10) {
            _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
        }
        // 数据加载完成
        else {
            
            [_tableView noDataTips];
        }
    }];
}


- (void)returnAction {
    if (_returnBlock) {
        _returnBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - RefreshCollectionViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {

    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getAuthorList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {

    [self getAuthorList];
}

- (void)refreshTableView:(BaseTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}

- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {

    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }

    
    UserModel *userModel = _userListModel.userList[index];
    NSInteger userId = [PASS_NULL_TO_NIL(userModel.userId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:2 relationId:userId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            
            //sender.selected = [PASS_NULL_TO_NIL(resultData[@"is_follow"]) integerValue] ==1;
            userModel.isFollow = resultData[@"is_follow"];
         
            
            NSString *fanNumStr = PASS_NULL_TO_NIL(resultData[@"fans_num_str"]);
            
            userModel.fansNum = fanNumStr;
            
            _tableView.userListModel = _userListModel;
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}








@end
