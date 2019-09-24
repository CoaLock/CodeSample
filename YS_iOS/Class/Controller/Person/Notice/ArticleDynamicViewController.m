//
//  ArticleDynamicViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticleDynamicViewController.h"
#import "BaseTableView.h"
#import "ArticleDynamicCell.h"

#import "DetailViewController.h"


#import "MessageModel.h"

#import "GetMessageListApi.h"

#import "DoShareApi.h"
#import "DoZanApi.h"
#import "CommentViewController.h"
#import "DetailViewController.h"



static NSString *identifier = @"identifier";


@interface ArticleDynamicViewController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;


@property (nonatomic, strong) MessageListModel *msgListModel;


@property (nonatomic, assign) NSInteger firstRow;



@end

@implementation ArticleDynamicViewController



#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight - 64 - kSegmentBgHeight) img:@"bg_no_content" title:@"您没有文章动态哦" bgColor:kBackgroundColor];
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
    
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
}

#pragma mark - Private
- (void)startLoadData {
    
    if (_msgListModel.pushLogList.count == 0) {
        
        [self getMessageList];
    }
}

- (void)getMessageList {
    
    GetMessageListApi *msgListApi = [[GetMessageListApi alloc] init];
    [msgListApi getMessageListWithType:2 firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _msgListModel = [[MessageListModel alloc] init];
                _msgListModel.pushLogList =  @[].mutableCopy;;
            }
            
            MessageListModel *msgListModel = [MessageListModel mj_objectWithKeyValues:resultData];
            
            [MessageModel hanleModelListData:msgListModel.pushLogList];
            
            [_msgListModel.pushLogList addObjectsFromArray:msgListModel.pushLogList];
            
            
            [_tableView reloadData];
            
            
            // 有数据
            if (msgListModel.pushLogList.count >= 10) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_tableView noDataTips];
            }
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            _tableView.hidden = (_msgListModel.pushLogList.count==0);
            [[self createBlankView] shouldShow:(_msgListModel.pushLogList.count==0)];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Events


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _msgListModel.pushLogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticleDynamicCell *cell = nil;
    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
    /*
     // 2.文章被点赞  1111  简单格式
     
     // 3.文章被评论  2222
     
     // 4.文章被打赏  1111
     
     // 5.文章被收藏  1111
     
     // 6.评论被点赞  1111
     
     // 7.评论被评论  3333
     */
    
    
    if (type == 2 || type == 4 || type ==5 || type == 6) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstArticleDynamicIdentifier"];
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicCell" owner:nil options:nil][0];
        }
        
    }
    else if (type == 7) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"secondArticleDynamicIdentifier"];
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicCell" owner:nil options:nil];
            cell = nibs[1];
        }
        
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"thirdArticleDynamicIdentifier"];
        if (cell == nil) {
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ArticleDynamicCell" owner:nil options:nil];
            cell = nibs[2];
        }
    }
    
    cell.messageModel = msgModel;

    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
    
    if (type == 2 || type == 4 || type ==5 || type == 6) {
        
        return 75;
    }
    
    return msgModel.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2. 文章被点赞
    
    // 3.文章被评论
    
    // 4.文章被打赏
    
    // 5.文章被收藏
    
    // 6.评论被点赞
    
    // 7评论被评论

    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    
    NSInteger articleId = [PASS_NULL_TO_NIL(msgModel.articleInfo.articleId) integerValue];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
    
    if (type == 2 || type == 4 || type == 5) {
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.articleId = articleId;
        [self.navigationController pushViewController:detailVC animated:YES];
    
    }
    else if (type == 3) {
    
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.articleId = articleId;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
    // 6 7
    else {
        
        articleId = [PASS_NULL_TO_NIL(msgModel.commentInfo.articleId) integerValue];

        CommentViewController *commentVC = [[CommentViewController alloc] init];
        commentVC.articleId = articleId;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
    
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getMessageList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
    
    [self getMessageList];
}




@end
