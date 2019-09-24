//
//  PersonCollectViewController.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/25.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonCollectViewController.h"
#import "BaseTableView.h"
#import "CollectArticleCell.h"

#import "GetCollectListApi.h"

#import "GArticleModel.h"

#import "DoCollectApi.h"

#import "DetailViewController.h"
#import "CommentViewController.h"
#import "DoZanApi.h"
#import "DoShareApi.h"

#import "UMShareView.h"
#import "PersonCenterViewController.h"

static NSString *identifier = @"identifier";


@interface PersonCollectViewController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong)  GArticleListModel *articleListModel;

@property (nonatomic, strong) UMShareView *shareView;


@end

@implementation PersonCollectViewController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -0) img:@"ic_collection_unselected" title:@"您还没有收藏文章哦" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    return self.blankView;
}


- (void)initTableView {
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"CollectArticleCell" bundle:nil] forCellReuseIdentifier:identifier];

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
    
    self.navigationItem.titleView = [UILabel labelWithTitle:@"我的收藏"];

    
    [self initTableView];
    
    [self getCollectList];

    [self initShareView];
}


#pragma mark - Private
- (void)getCollectList {

    GetCollectListApi *collectListApi = [[GetCollectListApi alloc] init];
    
    [collectListApi getCollectListWithFirstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _articleListModel = [[GArticleListModel alloc] init];
                _articleListModel.articleList =  @[].mutableCopy;;
            }
            
            GArticleListModel *articleListModel = [GArticleListModel mj_objectWithKeyValues:resultData];
            [_articleListModel.articleList addObjectsFromArray:articleListModel.articleList];
            
            
            [_tableView reloadData];
            
            
            // 有数据
            if (articleListModel.articleList.count >= 10) {
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
            _tableView.hidden = (_articleListModel.articleList.count==0);
            [[self createBlankView] shouldShow:(_articleListModel.articleList.count==0)];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

#pragma mark - Private
- (void)deleteArticleWithIndex:(NSInteger)index {
    
    GArticleModel *articleModel = _articleListModel.articleList[index];
    NSInteger articleId = [articleModel.articleId integerValue];
    
    DoCollectApi *doCollectApi = [[DoCollectApi alloc] init];
    [doCollectApi doCollectWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        
        if (code == 0) {
            
            if ([resultData integerValue] == 0) {
                
                [_articleListModel.articleList removeObjectAtIndex:index];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
           
                //_firstRow = 0;
                //[self getUserArticleList];
                
                
                // 显示tableView
                if ([self createBlankView].superview == nil) {
                    [self.view addSubview:[self createBlankView]];
                }
                _tableView.hidden = (_articleListModel.articleList.count==0);
                [[self createBlankView] shouldShow:(_articleListModel.articleList.count==0)];

                
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}



#pragma mark - Events
- (void)shareAction:(UIButton*)btn {
    
    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    self.shareObj = articleModel;
    [_shareView show];
}

- (void)commentAction:(UIButton*)btn {

//    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
//    CommentViewController *commentVC = [[CommentViewController alloc] init];
//    commentVC.articleModel = articleModel;
//    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)browseAuthor:(UIButton*)btn {
    
    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    personVC.keyword = articleModel.userInfo.nickname;
    personVC.userId = [articleModel.userInfo.userId integerValue];
    [self.navigationController pushViewController:personVC animated:YES];
}



- (void)praiseAction:(UIButton*)btn {

    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DoZanApi *zanApi = [[DoZanApi alloc] init];
    [zanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.isZan = resultData[@"is_zan"];
            
            NSString *zanNumStr = [NSString stringWithFormat:@"%@", resultData[@"zan_num_str"]];
            zanNumStr = [zanNumStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
            articleModel.zanNum = zanNumStr;
            
            [_tableView reloadData];

        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)detailActionWithIndex:(NSInteger)index {

    GArticleModel *articleModel = _articleListModel.articleList[index];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _articleListModel.articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.articleModel = _articleListModel.articleList[indexPath.row];
    
    
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = 1000 +indexPath.row;
    
    
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentBtn.tag = 1000 +indexPath.row;
    
    
    [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.tag = 1000 +indexPath.row;
    
    cell.headerBtn.tag = 1000+indexPath.row;
    [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 126;
}

#pragma mark 编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deleteArticleWithIndex:indexPath.row];
//    [_tableView setEditing:NO animated:YES];
    
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    
    deleteAction.backgroundColor = kTextSecondLevelColor;
    
    
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self detailActionWithIndex:indexPath.row];
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getCollectList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
    
    [self getCollectList];
}



@end
