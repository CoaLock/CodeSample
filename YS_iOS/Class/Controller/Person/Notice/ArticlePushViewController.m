//
//  ArticlePushViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticlePushViewController.h"
#import "PersonCenterViewController.h"

#import "BaseTableView.h"

#import "ArticlePushCell.h"

#import "MessageModel.h"

#import "GetMessageListApi.h"

#import "DoShareApi.h"
#import "DoZanApi.h"
#import "CommentViewController.h"
#import "DetailViewController.h"

#import "UMShareView.h"


static NSString *identifier = @"identifier";


@interface ArticlePushViewController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>


@property (nonatomic, strong) BaseTableView *tableView;


@property (nonatomic, strong) MessageListModel *msgListModel;


@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) UMShareView *shareView;


@end

@implementation ArticlePushViewController



#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight - 64 - kSegmentBgHeight) img:@"bg_no_content" title:@"暂未收到好文推送哦" bgColor:kBackgroundColor];
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
    
    [_tableView registerNib:[UINib nibWithNibName:@"ArticlePushCell" bundle:nil] forCellReuseIdentifier:identifier];


    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initShareView {
    
    GrassWeakSelf;
    _shareView = [[UMShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) viewController:nil eventType:^(UMSocialPlatformType platType) {
        
        [weakSelf doShareActionWithPlatType:platType];
    }];
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:_shareView];
}

- (void)doShareActionWithPlatType:(UMSocialPlatformType)platType {
    
    DoShareApi *doShareApi = [[DoShareApi alloc] init];
    GArticleModel *articleModel = self.shareObj;
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    [doShareApi doShareWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.shareNum = [NSString stringWithFormat:@"%@", resultData];
            [_tableView reloadData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}



#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    [self initShareView];

}

#pragma mark - Private
- (void)startLoadData {
    
    if (_msgListModel.pushLogList.count == 0) {
        
        [self getMessageList];
    }
}

- (void)getMessageList {

    GetMessageListApi *msgListApi = [[GetMessageListApi alloc] init];
    [msgListApi getMessageListWithType:3  firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _msgListModel = [[MessageListModel alloc] init];
                _msgListModel.pushLogList =  @[].mutableCopy;;
            }
            
            MessageListModel *msgListModel = [MessageListModel mj_objectWithKeyValues:resultData];
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
- (void)shareAction:(UIButton*)btn {
    
    MessageModel *msgModel = _msgListModel.pushLogList[btn.tag -1000];
    GArticleModel *articleModel = msgModel.articleInfo;
    
    self.shareObj = articleModel;
    [_shareView show];
}

- (void)commentAction:(UIButton*)btn {
    
//    MessageModel *msgModel = _msgListModel.pushLogList[btn.tag -1000];
//    GArticleModel *articleModel = msgModel.articleInfo;
//    
//    CommentViewController *commentVC = [[CommentViewController alloc] init];
//    commentVC.articleModel = articleModel;
//    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)praiseAction:(UIButton*)btn {
    
    MessageModel *msgModel = _msgListModel.pushLogList[btn.tag -1000];
    GArticleModel *articleModel = msgModel.articleInfo;
    
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DoZanApi *zanApi = [[DoZanApi alloc] init];
    [zanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.isZan = resultData[@"is_zan"];
            
            NSString *zanNumStr = [NSString stringWithFormat:@"%@", resultData[@"zan_num_str"]];
            articleModel.zanNum = zanNumStr;
            
            [_tableView reloadData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)browseAuthor:(UIButton*)btn {
    
    MessageModel *msgModel = _msgListModel.pushLogList[btn.tag -1000];
    GArticleModel *articleModel = msgModel.articleInfo;
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    personVC.keyword = articleModel.userInfo.nickname;
    personVC.userId = [articleModel.userInfo.userId integerValue];
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)detailActionWithIndex:(NSInteger)index {
    
    MessageModel *msgModel = _msgListModel.pushLogList[index];
    GArticleModel *articleModel = msgModel.articleInfo;
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _msgListModel.pushLogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ArticlePushCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.messageModel = _msgListModel.pushLogList[indexPath.row];
    
    
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = 1000 + indexPath.row;
    
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentBtn.tag = 1000 + indexPath.row;
    
    
    [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.tag = 1000 + indexPath.row;
    
    
    cell.headerBtn.tag = 1000+indexPath.row;
    [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 156;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self detailActionWithIndex:indexPath.row];
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
