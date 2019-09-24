//
//  SystemNoticeViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SystemNoticeViewController.h"
#import "BaseTableView.h"
#import "SystemNoticeCell.h"


#import "MessageModel.h"

#import "GetMessageListApi.h"

#import "DoShareApi.h"
#import "DoZanApi.h"
#import "CommentViewController.h"
#import "DetailViewController.h"

#import "BaseWKWebViewController.h"

#import "ReadMessageApi.h"

#import "SystemNoticeDetailViewController.h"


static NSString *identifier = @"identifier";


@interface SystemNoticeViewController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;


@property (nonatomic, strong) MessageListModel *msgListModel;


@property (nonatomic, assign) NSInteger firstRow;



@end

@implementation SystemNoticeViewController

#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight - 64 - kSegmentBgHeight) img:@"ic_system_msg_big" title:@"您没有系统通知哦" bgColor:kBackgroundColor];
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
    [msgListApi getMessageListWithType:1  firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _msgListModel = [[MessageListModel alloc] init];
                _msgListModel.pushLogList =  @[].mutableCopy;;
            }
            
            MessageListModel *msgListModel = [MessageListModel mj_objectWithKeyValues:resultData];
            
            // 处理消息
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
    
    SystemNoticeCell *cell = nil;
    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
    
    
    if (type != 10) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstSystemIdentifier"];
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"SystemNoticeCell" owner:nil options:nil][0];
        }
        
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"secondSystemIdentifier"];
        if (cell == nil) {
            
            
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SystemNoticeCell class]) owner:nil options:nil];
            cell = [nibs objectAtIndex:1];
        }
    }
    
    cell.messageModel = msgModel;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
    
    if (type != 10) {
        
        return msgModel.cellHeight;
    }
    else {
    
        return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageModel *msgModel = _msgListModel.pushLogList[indexPath.row];
    NSInteger type = [PASS_NULL_TO_NIL(msgModel.type) integerValue];
        
    
    NSInteger relationId = (type == 11) ? [PASS_NULL_TO_NIL(msgModel.noticeInfo.noticeId) integerValue] : [PASS_NULL_TO_NIL(msgModel.pushLogId) integerValue];
    NSInteger readType = (type == 11) ? 3 : 1;
    
    ReadMessageApi *readMsgApi = [[ReadMessageApi alloc] init];
    [readMsgApi readMessageWithType:readType relationId:relationId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            msgModel.isRead = @"1";
            SystemNoticeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.messageModel = msgModel;
            
        }
    }];

    //  公告：详情为webView
    if (type == 11) {
    
        NSString *noticeId = msgModel.noticeInfo.noticeId;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@%@", kDomain,kWebUrlNoticeDetail,noticeId];
        
        BaseWKWebViewController *webviewVC = [[BaseWKWebViewController alloc] init];
        webviewVC.titleStr = msgModel.noticeInfo.title;
        
        [webviewVC wkWebViewRequestWithURL:urlStr];
        
        [self.navigationController pushViewController:webviewVC animated:YES];
        
    }
    // 行数超过2行, 有详情
    else if (msgModel.isShowMoreBtn) {
    
        SystemNoticeDetailViewController *detailVC = [[SystemNoticeDetailViewController alloc] init];
        detailVC.messageModel = msgModel;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    // 点击直接阅读
    else {
    
        
        
    
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
