//
//  SearchDetailViewController.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/29.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "BaseViewController.h"

#import "BaseCollectionView.h"

#import "DoSearchApi.h"

#import "GArticleModel.h"

#import "HomeVerticalCell.h"
#import "CommentViewController.h"
#import "DoZanApi.h"
#import "DetailViewController.h"

#import "DoShareApi.h"
#import "UMShareView.h"

#import "PersonCenterViewController.h"


static NSString *identifier = @"identifier";

@interface SearchDetailViewController () <RefreshCollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>


@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic , strong) BaseCollectionView *collectionView;


@property (nonatomic, strong) GArticleListModel *articleListModel;


@property (nonatomic, assign) NSInteger firstRow;

@property (nonatomic, strong) UMShareView *shareView;



@end

@implementation SearchDetailViewController




#pragma mark - Init
- (BlankDisplayView*)createBlankView {
    if (self.blankView == nil) {
        
        BlankDisplayView *blankView = [[BlankDisplayView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) img:@"bg_no_content" title:@"没有找到结果\n换个关键字试试看吧" bgColor:kBackgroundColor];
        [self.view addSubview:self.blankView];
        
        self.blankView = blankView;
    }
    return self.blankView;
}



- (void)setupEmptyView {
    
    UIImageView * emptyImage = [[UIImageView alloc]init];
    emptyImage.image = [UIImage imageNamed:@"xiaocao_image"];
    [self.view addSubview:emptyImage];
    UILabel * emptyLabel = [[UILabel alloc]init];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont systemFontOfSize:14];
    emptyLabel.text = @"没有找到\n换个关键词试试看吧";
    emptyLabel.numberOfLines = 2;
    [self.view addSubview:emptyLabel];
    [emptyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(80);
    }];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(emptyImage.mas_bottom).offset(15);
    }];
}

- (void)setupDetailCollectionView {
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = (kScreenWidth - 5)/2.0;
    _flowLayout.itemSize = CGSizeMake(width, width + 85 +40);
    _flowLayout.minimumLineSpacing = 5;
    _flowLayout.minimumInteritemSpacing = 5;
    
    _collectionView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HomeVerticalCell" bundle:nil] forCellWithReuseIdentifier:identifier];
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
            [_collectionView reloadData];
        }
    }];
    
    [self sharePromoCodePlatType:platType];
}


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (/* DISABLES CODE */ (0)) {
        [self setupEmptyView];
    }else {
        [self setupDetailCollectionView];
    }
    
    [self searchArticle];
    
    [self initShareView];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _searchBar.hidden = NO;

    
    GrassWeakSelf;
    _searchBar.searchBlock = ^(NSString *text) {
        
        _keyword = text;
        weakSelf.firstRow = 0;
        [weakSelf searchArticle];
    };
}

 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_searchBar endEditing:YES];

    _searchBar.hidden = YES;
    
}


#pragma mark - Private
- (void)searchArticle {

    DoSearchApi *doSearchApi = [[DoSearchApi alloc] init];

    _keyword = _keyword.length ==0 ? @" " : _keyword;
    [doSearchApi doSearchWithKeyword:_keyword firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _collectionView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            
            DICTIONARY_NIL_NULL(resultData);
            if (_firstRow == 0) {
                
                _articleListModel = [[GArticleListModel alloc] init];
                _articleListModel.articleList =  @[].mutableCopy;;
            }
            
            GArticleListModel *articleListModel = [GArticleListModel mj_objectWithKeyValues:resultData];
            [_articleListModel.articleList addObjectsFromArray:articleListModel.articleList];
            
            
            [_collectionView reloadData];
            
            
            // 有数据
            if (articleListModel.articleList.count >= 10) {
                _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
            }
            // 数据加载完成
            else {
                
                [_collectionView noDataTips];
            }
            
            // 显示tableView
            if ([self createBlankView].superview == nil) {
                [self.view addSubview:[self createBlankView]];
            }
            _collectionView.hidden = (_articleListModel.articleList.count==0);
            [[self createBlankView] shouldShow:(_articleListModel.articleList.count==0)];
            
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
//    
//    GArticleModel *articleModel = _articleListModel.articleList[btn.tag -1000];
//    CommentViewController *commentVC = [[CommentViewController alloc] init];
//    commentVC.articleModel = articleModel;
//    [self.navigationController pushViewController:commentVC animated:YES];
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
            
            articleModel.isZan = resultData[@"is_zan"];
            NSString *zanNumStr = [NSString stringWithFormat:@"%@", resultData[@"zan_num_str"]];
            zanNumStr = [zanNumStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
            articleModel.zanNum = zanNumStr;
            
            [_collectionView reloadData];

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


- (void)detailActionWithIndex:(NSInteger)index {
    
    GArticleModel *articleModel = _articleListModel.articleList[index];
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _articleListModel.articleList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    HomeVerticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.articleModel = _articleListModel.articleList[indexPath.row];
    
    
    [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = 1000+indexPath.row;
    
    [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentBtn.tag = 1000+indexPath.row;
    
    [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.tag = 1000+indexPath.row;
   
    [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];
    cell.headerBtn.tag = 1000+indexPath.row;
    
    
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 0, 0, 0);
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self detailActionWithIndex:indexPath.row];
}


#pragma mark - RefreshCollectionViewDelegate
- (void)refreshCollectionViewPullDown:(BaseCollectionView*)refreshCollectionView {
    
    self.firstRow = 0;
    [_collectionView resetDataTips];
    [self searchArticle];
}

- (void)refreshCollectionViewPullUp:(id)refreshCollectionView {
    
    [self searchArticle];
}




@end