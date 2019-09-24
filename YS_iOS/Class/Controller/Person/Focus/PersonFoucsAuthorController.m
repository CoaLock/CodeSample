//
//  PersonFoucsAuthorController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFoucsAuthorController.h"
#import "BaseTableView.h"
#import "PersonFocusAuthorCell.h"

#import "GetFollowListApi.h"
#import "DoFollowApi.h"

#import "UserModel.h"

#import "MainDrawerController.h"
#import "NavigationController.h"
#import "TabbarViewController.h"

#import "AttentionViewController.h"
#import "PersonCenterViewController.h"

#import "AppDelegate.h"

static NSString *identifier = @"identifier";


@interface PersonFoucsAuthorController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UserListModel *userListModel;



@end

@implementation PersonFoucsAuthorController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"ic_attent_author" title:@"您还没有关注任何作者哦" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    return self.blankView;
}


- (void)initTableView {
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight -64 -kSegmentBgHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"PersonFocusAuthorCell" bundle:nil] forCellReuseIdentifier:identifier];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    [self getFollowList];
}

#pragma mark - Private
- (void)doFollowTopicWithIndex:(NSInteger)index button:(UIButton*)button {
    
    UserModel *userModel = _userListModel.followList[index];
    NSInteger userId = [PASS_NULL_TO_NIL(userModel.userId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:2 relationId:userId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *isFollow = resultData[@"is_follow"];
            
            userModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            
            button.selected = ([isFollow integerValue] == 1);
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)startLoadData {
 
    if (_userListModel.followList.count == 0) {
        
        [self getFollowList];
    }
}


- (void)getFollowList {
    
    GetFollowListApi *getFollowListApi = [[GetFollowListApi alloc] init];
    [getFollowListApi getFollowListWithType:2 firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _userListModel = [[UserListModel alloc] init];
                _userListModel.followList =  @[].mutableCopy;;
            }
            
            UserListModel *userListModel = [UserListModel mj_objectWithKeyValues:resultData];
            for (UserModel *userModel in userListModel.followList) {
                
                userModel.isFollow = @"1";
            }
            
            [_userListModel.followList addObjectsFromArray:userListModel.followList];
            
            
            [_tableView reloadData];
            
            
            // 有数据
            if (userListModel.followList.count >= 10) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_tableView noDataTips];
            }
            
            // 显示tableView
            self.blankView.bindedView = _tableView;
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            [[self createBlankView] shouldShow:(_userListModel.followList.count==0)];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}

#pragma mark - Events
- (void)attentAction:(UIButton*)button {

    [self doFollowTopicWithIndex:button.tag -1000 button:button];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userListModel.followList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonFocusAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.attentBtn.tag = 1000 + indexPath.row;
    [cell.attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.userModel = _userListModel.followList[indexPath.row];
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UserModel *userModel = _userListModel.followList[indexPath.row];
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    personVC.keyword = userModel.nickname;
    personVC.userId = [PASS_NULL_TO_NIL(userModel.userId) integerValue];
    [self.navigationController pushViewController:personVC animated:YES];
    
    /*
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    MainDrawerController *mainVC = (MainDrawerController*)appDelegate.window.rootViewController;
    
    if ([mainVC isKindOfClass:[MainDrawerController class]]) {
        
        [mainVC closeDrawerAnimated:NO completion:nil];
        
        TabbarViewController *tabbar = (TabbarViewController*)mainVC.centerViewController;
        tabbar.currentIndex = 1;
        [self.navigationController popViewControllerAnimated:NO];
        
        NavigationController *nav = tabbar.viewControllers[1];
        AttentionViewController *attenVC = nav.viewControllers[0];
        
        if ([attenVC respondsToSelector:@selector(selectAuthorVC)]) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                if (attenVC.segmentedCtrl) {
                    [attenVC performSelector:@selector(selectAuthorVC) withObject:attenVC.segmentedCtrl];
                }
            });
        }
    }
    */
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getFollowList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
    
    [self getFollowList];
}




@end
