//
//  AttentTopAuthorViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentTopAuthorViewController.h"

#import "PersonCenterViewController.h"

#import "BaseCollectionView.h"

#import "HomeVerticalCell.h"

#import "GetAuthorArticleListApi.h"

#import "GetTagArticleListApi.h"

#import "GArticleModel.h"

#import "DetailViewController.h"

#import "CommentViewController.h"

#import "DoZanApi.h"

#import "DoFollowApi.h"

#import "DoShareApi.h"
#import "UMShareView.h"



static NSString *identifier = @"identifier";

@interface AttentTopAuthorViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, RefreshCollectionViewDelegate>

@property (nonatomic, strong) BaseCollectionView *collectView;


@property (nonatomic, strong) GArticleListModel *articleListModel;


@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UMShareView *shareView;


@end

@implementation AttentTopAuthorViewController


#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight - 64 -45) img:@"ic_attent_author" title:@"该作者还没有发布任何文章哦" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    return self.blankView;
}


- (void)initCollectView {
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemWidth = (kScreenWidth-5)/2.0;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth + 85 + 40);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    _collectView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth, kScreenHeight - 64 - 49 - 46) collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [self.view addSubview:_collectView];
    
    [_collectView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    
    [_collectView registerNib:[UINib nibWithNibName:@"HomeVerticalCell" bundle:nil] forCellWithReuseIdentifier:identifier];
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
            [_collectView reloadData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [self initCollectView];
    
    [self initShareView];

}

#pragma mark - Private
- (void)startLoadData {
    
    if (_articleListModel.articleList.count == 0) {
        
        [self getTagArticleList];
    }
}


- (void)getTagArticleList {
    
    GetAuthorArticleListApi *authorArticleApi = [[GetAuthorArticleListApi alloc] init];
    
    [authorArticleApi getAuthorArticleListWithAuthorId:_userId firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _collectView.isClosedPullUpCallback = NO;
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _articleListModel = [[GArticleListModel alloc] init];
                _articleListModel.articleList =  @[].mutableCopy;;
            }
            
            GArticleListModel *articleListModel = [GArticleListModel mj_objectWithKeyValues:resultData];
            [_articleListModel.articleList addObjectsFromArray:articleListModel.articleList];
            
            
            [_collectView reloadData];
            
            
            // 有数据
            if (articleListModel.articleList.count >= 10) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_collectView noDataTips];
            }
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            _collectView.hidden = (_articleListModel.articleList.count==0);
            [[self createBlankView] shouldShow:(_articleListModel.articleList.count==0)];
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];

}


#pragma mark - Events
- (void)commentAction:(UIButton*)btn {
    
//    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
//    CommentViewController *commentVC = [[CommentViewController alloc] init];
//    commentVC.articleModel = articleModel;
//    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)shareAction:(UIButton*)btn {
    
    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    self.shareObj = articleModel;
    [_shareView show];
}

- (void)praiseAction:(UIButton*)btn {
    
    if (![UserDefaultsUtil isContainUserDefault]) {
        [self showReLoginVC];
        return;
    }

    
    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DoZanApi *zanApi = [[DoZanApi alloc] init];
    [zanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            btn.selected = [PASS_NULL_TO_NIL(resultData[@"is_zan"]) integerValue]==1;
            articleModel.isZan = resultData[@"is_zan"];
            
            
            HomeVerticalCell *cell = (HomeVerticalCell*)[_collectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-1000 inSection:0]];
            NSString *zanNum = PASS_NULL_TO_NIL(resultData[@"zan_num_str"]);
            cell.praiseLabel.text = zanNum;
            
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)browseAuthor:(UIButton*)btn {
    
    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    personVC.keyword = articleModel.userInfo.nickname;
    personVC.userId = [articleModel.userInfo.userId integerValue];
    [self.navigationController pushViewController:personVC animated:YES];
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _articleListModel.articleList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeVerticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    GArticleModel *gArticleModel = _articleListModel.articleList[indexPath.row];
    cell.articleModel = gArticleModel;
    
    cell.commentBtn.tag = 1000+indexPath.row;
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.shareBtn.tag = 1000+indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.praiseBtn.tag = 1000+indexPath.row;
    [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.headerBtn.tag = 1000+indexPath.row;
    [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GArticleModel *articleModel = _articleListModel.articleList[indexPath.row];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - RefreshCollectionViewDelegate
- (void)refreshCollectionViewPullDown:(BaseCollectionView *)refreshCollectionView {
    
    _firstRow = 0;
    [refreshCollectionView resetDataTips];
    
    [self getTagArticleList];
}

- (void)refreshCollectionViewPullUp:(id)refreshCollectionView {
    
    [self getTagArticleList];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return NO;
}


@end
