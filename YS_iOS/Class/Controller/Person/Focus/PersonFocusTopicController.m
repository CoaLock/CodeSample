//
//  PersonFocusTopicController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFocusTopicController.h"
#import "BaseTableView.h"
#import "PersonFocusTopicCell.h"

#import "GetFollowListApi.h"

#import "DoFollowApi.h"
#import "TopicModel.h"

#import "FocusDetailViewController.h"


static NSString *identifier = @"identifier";

@interface PersonFocusTopicController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>


@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) TopicListModel *topicListModel;


@end

@implementation PersonFocusTopicController



#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"ic_imblack" title:@"您还没有关注任何话题哦" bgColor:kBackgroundColor];
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"PersonFocusTopicCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];


    [self initTableView];
}

#pragma mark - Private
- (void)startLoadData {

    if (_topicListModel.followList.count == 0) {
        
        [self getFollowList];
    }
}

- (void)getFollowList {
    
    GetFollowListApi *getFollowListApi = [[GetFollowListApi alloc] init];
    [getFollowListApi getFollowListWithType:3 firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _topicListModel = [[TopicListModel alloc] init];
                _topicListModel.followList =  @[].mutableCopy;;
            }
            
            TopicListModel *topicListModel = [TopicListModel mj_objectWithKeyValues:resultData];
            for (TopicModel *topicModel in topicListModel.followList) {
                
                topicModel.isFollow = @"1";
            }
            
            [_topicListModel.followList addObjectsFromArray:topicListModel.followList];
            
            
            [_tableView reloadData];
            
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            [[self createBlankView] shouldShow:(_topicListModel.followList.count==0)];
            _tableView.hidden = (_topicListModel.followList.count==0);
        
            
            // 有数据
            if (topicListModel.followList.count >= 10) {
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

- (void)doFollowTopicWithIndex:(NSInteger)index button:(UIButton*)button {
    
    TopicModel *topicModel = _topicListModel.followList[index];
    NSInteger topicId = [PASS_NULL_TO_NIL(topicModel.topicId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:3 relationId:topicId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *isFollow = resultData[@"is_follow"];

            topicModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            topicModel.fansNum = [NSString stringWithFormat:@"%@", resultData[@"fans_num_str"]];
            
            [_tableView reloadData];
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
    
    return _topicListModel.followList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonFocusTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    TopicModel *topicModel = _topicListModel.followList[indexPath.row];
    cell.topicModel = topicModel;
    
    cell.attentBtn.tag = 1000 + indexPath.row;
    [cell.attentBtn addTarget:self action:@selector(attentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    TopicModel *topicModel = _topicListModel.followList[indexPath.row];
    NSInteger topicId = [PASS_NULL_TO_NIL(topicModel.topicId) integerValue];
    
    FocusDetailViewController *topicDetailVC = [[FocusDetailViewController alloc] init];
    topicDetailVC.topicId = topicId;
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
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
