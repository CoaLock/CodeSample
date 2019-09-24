//
//  TopicMeController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/20.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "TopicMeController.h"

#import "FocusTopicsTableView.h"
#import "FocusDetailViewController.h"


#import "DetailViewController.h"
#import "CommentViewController.h"


#import "TopicListApi.h"


#import "TopicModel.h"

#import "DoFollowApi.h"

#import "GetFollowListApi.h"

#import "DoShareApi.h"
#import "UMShareView.h"


@interface TopicMeController ()  <RefreshTableViewDelegate>



@property (nonatomic , strong) FocusTopicsTableView *topicsTableView;


@property (nonatomic, strong) TopicListModel *topicListModel;


@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UMShareView *shareView;



@end

@implementation TopicMeController



#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"ic_imblack" title:@"您还没有关注任何话题哦" bgColor:kBackgroundColor];
        self.blankView.bindedView = _topicsTableView;
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
        [blankView.skipBtn setTitle:@"立即关注" forState:UIControlStateNormal];

        blankView.skipBtn.hidden = NO;
        [blankView.skipBtn addTarget:self action:@selector(skipAttentTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self.blankView;
}

- (void)setupTableView {
    
    _topicsTableView = [[FocusTopicsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64 -49) style:UITableViewStyleGrouped];
    [self.view addSubview:_topicsTableView];
    
    [_topicsTableView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
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
            [_topicsTableView reloadData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTableView];
    
    [self initShareView];

}

#pragma mark - Private
- (void)startLoadData {
    
    if (_topicListModel.followList.count == 0) {
        
        [self getTopicList];
    }
}


- (void)getTopicList {
    
    GetFollowListApi *topicListApi = [[GetFollowListApi alloc] init];
    [topicListApi getFollowListWithType:3 firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _topicsTableView.isClosedPullUpCallback = NO;
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _topicListModel = [[TopicListModel alloc] init];
                _topicListModel.followList =  @[].mutableCopy;;
            }
            
            TopicListModel *topicListModel = [TopicListModel mj_objectWithKeyValues:resultData];
            [_topicListModel.followList addObjectsFromArray:topicListModel.followList];
            
            
            _topicsTableView.topicListModel = _topicListModel;
            
            
            // 有数据
            if (topicListModel.followList.count >= 10) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_topicsTableView noDataTips];
            }
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            _topicsTableView.hidden = (_topicListModel.followList.count==0);
            [[self createBlankView] shouldShow:(_topicListModel.followList.count==0)];

            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}


- (void)doFollowTopicWithIndex:(NSInteger)index button:(UIButton*)button {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    
    TopicModel *topicModel = _topicListModel.followList[index];
    NSInteger topicId = [PASS_NULL_TO_NIL(topicModel.topicId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:3 relationId:topicId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *isFollow = resultData[@"is_follow"];
            topicModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            topicModel.fansNum = [NSString stringWithFormat:@"%@", resultData[@"fans_num_str"]];
            
            [_topicsTableView reloadData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

#pragma mark - Events
- (void)skipAttentTopic:(UIButton*)button {

    if (_followTopicBlock) {
        
        _followTopicBlock();
    }
}


#pragma mark - RefreshTableViewDelegate
- (void)refreshTableViewPullDown:(BaseTableView *)refreshTableView {
    
    _firstRow = 0;
    [refreshTableView resetDataTips];
    
    [self getTopicList];
}

- (void)refreshTableViewPullUp:(id)refreshTableView {
    
    [self getTopicList];
}


- (void)refreshTableView:(BaseTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    TopicModel *topicModel = _topicListModel.followList[indexPath.section];
    NSInteger topicId = [PASS_NULL_TO_NIL(topicModel.topicId) integerValue];
    
    FocusDetailViewController *focusDetailView = [[FocusDetailViewController alloc]init];
    focusDetailView.topicId = topicId;
    [self.navigationController pushViewController:focusDetailView animated:YES];
}


- (void)refreshTableViewButtonClick:(BaseTableView *)refreshTableview WithButton:(UIButton *)sender SelectRowAtIndex:(NSInteger)index {
    
    NSArray *tagArr = [sender.stringTag componentsSeparatedByString:@","];
    NSString *type = tagArr[0];
    NSInteger section = [PASS_NULL_TO_NIL(tagArr[1]) integerValue];
    NSInteger row  = [PASS_NULL_TO_NIL(tagArr[2]) integerValue];
    
    if ([type isEqualToString:@"Focus"]) {
        
        [self doFollowTopicWithIndex:row button:sender];
        
        return;
    }
    
    
    TopicModel *topicMoel = _topicListModel.followList[section];
    GArticleModel *articleModel = topicMoel.articleList[row];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    if([type isEqualToString:@"ArticleDetai"]){
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.articleId = articleId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    else if([type isEqualToString:@"Share"]){
        
        self.shareObj = articleModel;
        [_shareView show];
    }
    else if([type isEqualToString:@"Comment"]){
        
//        CommentViewController *commentVC = [[CommentViewController alloc] init];
//        commentVC.articleModel = articleModel;
//        [self.navigationController pushViewController:commentVC animated:YES];
    }
    
}




@end
