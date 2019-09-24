//
//  FocusDetailViewController.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FocusDetailViewController.h"
#import "FocusDetailCollectionView.h"

#import "DetailViewController.h"
#import "CommentViewController.h"
#import "PersonCenterViewController.h"

#import "NavigationView.h"

#import "TopicDetailApi.h"
#import "TopicModel.h"
#import "TopicArticleListApi.h"

#import "DoFollowApi.h"
#import "DoZanApi.h"

#import "DoShareApi.h"
#import "UMShareView.h"

@interface FocusDetailViewController () <RefreshCollectionViewDelegate>


@property (nonatomic , strong) NavigationView *navigationView;


@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) FocusDetailCollectionView *focusDetailCollection;


@property (nonatomic, strong) TopicModel *topicModel;

@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UMShareView *shareView;



@end

@implementation FocusDetailViewController



#pragma mark - Init
- (void)setupNavigationView {
    
    _navigationView = [[NavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [self.view addSubview:_navigationView];
    
    [_navigationView.backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupDetailCollectionView {
    
    GrassWeakSelf;
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.minimumLineSpacing = 5;
    _flowLayout.minimumInteritemSpacing = 5;
    
    _focusDetailCollection = [[FocusDetailCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:_flowLayout detailCellClick:^(NSIndexPath *indexpath) {
        
        
    } scrollBlock:^(CGFloat offsetY, BOOL isHidden) {
        
        if (offsetY < 20) {
            weakSelf.navigationView.backgroundColor = [UIColor clearColor];
            weakSelf.navigationView.alpha = 1;
            
        }
        else if (offsetY < 60) {
            
            weakSelf.navigationView.backgroundColor = kNavBarMainColor;
            CGFloat alpha = (offsetY- 20)/40.0 * 1;
            weakSelf.navigationView.alpha = alpha;
        }
        else {
            
            weakSelf.navigationView.backgroundColor = kAppCustomMainColor;
            weakSelf.navigationView.alpha = 1;
        }
    }];
    
    [self.view addSubview:_focusDetailCollection];
    
    
    _focusDetailCollection.focusDetailButtoBlock = ^(UIButton* button) {
        
        [weakSelf doFollowTopicWithButton:button];
    };
    
    [_focusDetailCollection setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
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
            [_focusDetailCollection reloadData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}



#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupDetailCollectionView];
    
    [self setupNavigationView];
    
    [self getTopicDetail];
    
    [self initShareView];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Private
- (void)getTopicDetail {

    TopicDetailApi *topicDetailApi = [[TopicDetailApi alloc] init];
    [self showIndicatorOnWindowWithMessage:@"加载中..."];
    [topicDetailApi getTopicDetailWith:_topicId callback:^(id resultData, NSInteger code) {
        [self hideIndicatorOnWindow];
        if (code == 0) {
         
            DICTIONARY_NIL_NULL(resultData);
            _topicModel = [TopicModel mj_objectWithKeyValues:resultData];
            
            _focusDetailCollection.topicModel = _topicModel;
            
            
            // 有数据
            if (_topicModel.articleListModel.articleList.count >= kPageFetchNum) {
                
                _firstRow = [PASS_NULL_TO_NIL(_topicModel.articleListModel.nextFirstRow) integerValue];
            }
            // 数据加载完成
            else {
                
                [_focusDetailCollection noDataTips];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


// TopicArticleListApi.h
- (void)getTopicArticleList {

    TopicArticleListApi *topicArticleListApi = [[TopicArticleListApi alloc] init];
    [topicArticleListApi getTopicArticleListWithTopicId:_topicId firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        
        _focusDetailCollection.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _topicModel.articleListModel.articleList =  @[].mutableCopy;;
            }
            
            GArticleListModel *articleListModel = [GArticleListModel mj_objectWithKeyValues:resultData];
            [_topicModel.articleListModel.articleList addObjectsFromArray:articleListModel.articleList];
            
            
            _focusDetailCollection.topicModel = _topicModel;
            
            // 有数据
            if (articleListModel.articleList.count >= kPageFetchNum) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_focusDetailCollection noDataTips];
            }
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)doFollowTopicWithButton:(UIButton*)button {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    
    NSInteger topicId = [PASS_NULL_TO_NIL(_topicModel.topicId) integerValue];
    
    DoFollowApi *doFollowApi = [[DoFollowApi alloc] init];
    [doFollowApi doFollowWithType:3 relationId:topicId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            NSString *isFollow = resultData[@"is_follow"];
            
            _topicModel.isFollow = [NSString stringWithFormat:@"%@", isFollow];
            _topicModel.fansNum = [NSString stringWithFormat:@"%@", resultData[@"fans_num_str"]];
            
            [_focusDetailCollection reloadData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - Events

- (void)backButton:(UIButton*)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RefreshCollectionViewDelegate
- (void)refreshCollectionViewPullDown:(BaseCollectionView*)refreshCollectionView {

    _firstRow = 0;
    [refreshCollectionView resetDataTips];
    
    [self getTopicArticleList];
}

- (void)refreshCollectionViewPullUp:(id)refreshCollectionView {
    
    [self getTopicArticleList];
}

- (void)refreshCollectionView:(BaseCollectionView*)refreshCollectionview didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    GArticleModel *articleModel = _topicModel.articleListModel.articleList[indexPath.row];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshCollectionViewButtonClick:(BaseCollectionView *)refreshCollectionView WithButton:(UIButton *)sender SelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSArray *tagArr = [sender.stringTag componentsSeparatedByString:@","];
    NSString *type = tagArr[0];
   // NSInteger section = [PASS_NULL_TO_NIL(tagArr[1]) integerValue];
    NSInteger row  = [PASS_NULL_TO_NIL(tagArr[2]) integerValue];
    
    
    GArticleModel *articleModel = _topicModel.articleListModel.articleList[row];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    if([type isEqualToString:@"Share"]){
        
        self.shareObj = articleModel;
        [_shareView show];        
    }
    else if([type isEqualToString:@"Comment"]){
        
//        CommentViewController *commentVC = [[CommentViewController alloc] init];
//        commentVC.articleModel = articleModel;
//        [self.navigationController pushViewController:commentVC animated:YES];

    }
    else if([type isEqualToString:@"Praise"]){
        
        if (![UserDefaultsUtil isContainUserDefault]) {
            
            [self showReLoginVC];
            return;
        }
        
        
        DoZanApi *zanApi = [[DoZanApi alloc] init];
        [zanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
            if (code == 0) {
                
                articleModel.isZan = resultData[@"is_zan"];
                NSString *zanNumStr = [NSString stringWithFormat:@"%@", resultData[@"zan_num_str"]];
                articleModel.zanNum = zanNumStr;
                
                [_focusDetailCollection reloadData];
            }
            else {
                
                [self showErrorMsg:resultData[@"msg"]];
            }
        }];
    
    }
    else if([type isEqualToString:@"Author"]){
    
        PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
        personVC.keyword = articleModel.userInfo.nickname;
        personVC.userId = [articleModel.userInfo.userId integerValue];
        [self.navigationController pushViewController:personVC animated:YES];
        
    }

    
    
}



@end
