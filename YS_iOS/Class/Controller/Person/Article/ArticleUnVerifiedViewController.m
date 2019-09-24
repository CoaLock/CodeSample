//
//  ArticleUnVerifiedViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticleUnVerifiedViewController.h"
#import "DetailViewController.h"
#import "PublishViewController.h"


#import "BaseTableView.h"
#import "MyArticleCell.h"
#import "GetUserArticleListApi.h"
#import "DeleteArticleApi.h"

#import "GArticleModel.h"

#import "UserArticleDetailController.h"


static NSString *identifier = @"identifier";


@interface ArticleUnVerifiedViewController () <UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;


@property (nonatomic, strong) NSMutableArray   *articleList;
@property (nonatomic, assign) NSInteger  firstRow;


@end

@implementation ArticleUnVerifiedViewController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        self.blankView = [[BlankDisplayView alloc] initWithFrame:_tableView.frame img:@"ic_wait_audit" title:@"您没有待审核文章哦" bgColor:kBackgroundColor];
        self.blankView.bindedView = _tableView;
        [self.view addSubview:self.blankView];
    }
    
    return self.blankView;
}


- (void)initTableView {
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight -64 -kSegmentBgHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"MyArticleCell" bundle:nil] forCellReuseIdentifier:identifier];
}


#pragma mark - Life Cyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
}

#pragma mark - Private
- (void)startLoadData {
    
    if (_articleList.count == 0) {
        [self getUserArticleList];
    }
}

- (void)getUserArticleList {
    
    GetUserArticleListApi *articleListApi = [[GetUserArticleListApi alloc] init];
    [articleListApi getArticleListWithIsAudit:0 firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _tableView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            NSArray *resultList = PASS_NULL_TO_NIL(resultData[@"article_list"]);
            ARRAY_NIL_NULL(resultList);
            if (_firstRow == 0) {
                _articleList = @[].mutableCopy;
            }
            
            NSMutableArray *articleList = [GArticleModel mj_objectArrayWithKeyValuesArray:resultList];
            [_articleList addObjectsFromArray:articleList];
            
            [_tableView reloadData];
            
            // 有数据
            if (articleList.count >= kPageFetchNum) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
               
                [_tableView noDataTips];
            }
            
            // 显示tableView
            [[self createBlankView] shouldShow:(_articleList.count==0)];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)deleteArticleWithIndex:(NSInteger)index {
    
    GArticleModel *articleModel = _articleList[index];
    NSInteger articleId = [articleModel.articleId integerValue];
    
    DeleteArticleApi  *deleteArticleApi = [[DeleteArticleApi alloc] init];
    [deleteArticleApi deleteArticleWithArticleId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            //_firstRow = 0;
            
            [_articleList removeObjectAtIndex:index];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //[self getUserArticleList];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

#pragma mark - Events



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _articleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyArticleCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    GArticleModel *model = _articleList[indexPath.row];
    
    cell.articleModel = model;
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GArticleModel *articleModel = _articleList[indexPath.row];
    NSInteger articleId = [articleModel.articleId integerValue];
    
    UserArticleDetailController *detailVC = [[UserArticleDetailController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:detailVC];
}

#pragma mark 编辑模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"文章删除后将无法在《我的文章》中找回, 你确定要删除?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteArticleWithIndex:indexPath.row];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:submitAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    // 编辑
    else {
        
        [_tableView setEditing:NO animated:YES];
        
        
        GArticleModel *articleModel = _articleList[indexPath.row];
        NSInteger articleId = [articleModel.articleId integerValue];
        PublishViewController *publishVC = [[PublishViewController alloc] init];
        publishVC.pushlishType = PushlishTypeEdit;
        publishVC.articleId = articleId;
        [self.navigationController pushViewController:publishVC animated:YES];
        
    }
}

- (NSArray<UITableViewRowAction*> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GArticleModel *articleModel = _articleList[indexPath.row];
    NSInteger status = [PASS_NULL_TO_NIL(articleModel.status) integerValue];
    
    NSMutableArray *actionArr = @[].mutableCopy;
    
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];
    
    deleteAction.backgroundColor = kTextSecondLevelColor;
    
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleNone forRowAtIndexPath:indexPath];
    }];
    
    editAction.backgroundColor = kAppCustomMainColor;

    
    [actionArr addObject:deleteAction];

    // 0 草稿
    if (status == 0) {
    
        [actionArr addObject:editAction];

    }
    // 1发布 审核中
    else {
        
    }
    
    
    
    
    return actionArr;
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getUserArticleList];
}


- (void)refreshTableViewPullUp:(id)refreshTableView {

    [self getUserArticleList];
}







@end
