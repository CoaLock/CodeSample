//
//  HomeChildViewController.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "HomeChildViewController.h"
#import "DetailViewController.h"
#import "PersonCenterViewController.h"

#import "BaseCollectionView.h"
#import "CommentViewController.h"


#import "HomeRecCell.h"
#import "HomeHorizonCell.h"
#import "HomeVerticalCell.h"

#import "GArticleModel.h"

#import "ArticleListApi.h"
#import "HotArticleListApi.h"
#import "DoZanApi.h"

#import "DoShareApi.h"
#import "UMShareView.h"


static NSString *identiferRecCell = @"identiferRecCell";
static NSString *identiferVerticalCell = @"identiferVerticalCell";
static NSString *identiferHorizonCell = @"identiferHorizonCell";


@interface HomeChildViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RefreshCollectionViewDelegate>


@property (nonatomic, strong) BaseCollectionView *collectView;

@property (nonatomic, strong) GArticleListModel *topListModel;

@property (nonatomic, strong) GArticleListModel *articleListModel;


@property (nonatomic, assign) NSInteger firstRow;


@property (nonatomic, strong) UMShareView *shareView;



@end

@implementation HomeChildViewController


#pragma mark - Init
- (void)initCollectView {


    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
 
    _collectView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight -64 -49 - kSegmentBgHeight) collectionViewLayout:layout];
    _collectView.backgroundColor = kBackgroundColor;
    _collectView.delegate = self;
    _collectView.dataSource = self;
    [_collectView setRefreshDelegate:self refreshHeadEnable:YES refreshFootEnable:YES autoRefresh:NO];
    [self.view addSubview:_collectView];
    
    [_collectView registerNib:[UINib nibWithNibName:@"HomeRecCell" bundle:nil] forCellWithReuseIdentifier:identiferRecCell];
    [_collectView registerNib:[UINib nibWithNibName:@"HomeHorizonCell" bundle:nil] forCellWithReuseIdentifier:identiferHorizonCell];
    [_collectView registerNib:[UINib nibWithNibName:@"HomeVerticalCell" bundle:nil] forCellWithReuseIdentifier:identiferVerticalCell];

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

    
    [self initCollectView];
    
    [self initShareView];
}


#pragma mark - Private
- (void)reloadData {
    
    NSInteger multiple = _isSelect ? 1: -1;
    _collectView.layer.anchorPoint = CGPointMake(_isSelect, 0.5);
    _collectView.frame = CGRectMake(0, kSegmentBgHeight, kScreenWidth, kScreenHeight -64 -49);
    _collectView.layer.transform = CATransform3DMakeRotation(M_PI_2 *multiple, 0, 1, 0);
   // _collectView.layer.opacity = 0.001;
    [UIView animateWithDuration:0.8 animations:^{
        
        _collectView.layer.transform = CATransform3DIdentity;
        //_collectView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];

    
   [_collectView reloadData];
}

- (void)startLoadingDataWithTopModel:(GArticleListModel*)topModel {

   // _topListModel = topModel;
    if (_topListModel.articleList.count == 0) {
        
        [self getTopArticleList];
    }
    else if (_articleListModel.articleList.count == 0) {
    
        [self getArticleListWithIndex:self.tag-100];
    }
}



- (void)getHotArticleList {

    HotArticleListApi *hotArticleListApi = [[HotArticleListApi alloc] init];
    [hotArticleListApi getHotArticleListWithFirstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _collectView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            [self handleResultDataWith:resultData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}

- (void)getArticleListWithIndex:(NSInteger)index {
    
    // 文章属性：0最新，1置顶，2推荐，3精选。默认0。
    
    /*   推荐  最新  最热  精选
     *   2    0    hot    3
     */
    
    if (index == 2) {
        
        [self getHotArticleList];
        return;
    }
    
    
    NSInteger type = 0;
    if (index == 0) {
        
        type = 2;
    }
    else if (index == 1) {
        type = 0;
    }
    else if (index == 3) {
    
        type = 3;
    }
    
    
    ArticleListApi *articleListApi = [[ArticleListApi alloc] init];
    [articleListApi getHotArticleListWithType:type firstRow:_firstRow fetchNum:kPageFetchNum callback:^(id resultData, NSInteger code) {
        _collectView.isClosedPullUpCallback = NO;

        if (code == 0) {
            
            [self handleResultDataWith:resultData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


- (void)getTopArticleList {

    // 文章属性：0最新，1置顶，2推荐，3精选。默认0。
    ArticleListApi *articleListApi = [[ArticleListApi alloc] init];
    [articleListApi getHotArticleListWithType:1 firstRow:0 fetchNum:5 callback:^(id resultData, NSInteger code) {
        
        if (code == 0) {
            
            DICTIONARY_NIL_NULL(resultData);
            _topListModel = [GArticleListModel mj_objectWithKeyValues:resultData];
            
            [self getArticleListWithIndex:self.tag-100];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
    
}

- (void)handleResultDataWith:(id)resultData {

    DICTIONARY_NIL_NULL(resultData);
    if (_firstRow == 0) {
        
        _articleListModel = [[GArticleListModel alloc] init];
        _articleListModel.articleList = @[].mutableCopy;
    }
    GArticleListModel *listModel = [GArticleListModel mj_objectWithKeyValues:resultData];
    
    [_articleListModel.articleList addObjectsFromArray:listModel.articleList];

    [_collectView reloadData];
    
    
    // 有数据
    if (listModel.articleList.count > 0) {
        _firstRow = [PASS_NULL_TO_NIL(resultData[@"next_first_row"]) integerValue];
    }
    // 数据加载完成
    else {
        
        [_collectView noDataTips];
    }
    
}


#pragma mark - Events
- (void)shareAction:(UIButton*)btn {

    NSInteger section = [[btn.stringTag componentsSeparatedByString:@","].firstObject integerValue];
    NSInteger row = [[btn.stringTag componentsSeparatedByString:@","].lastObject integerValue];

    GArticleModel *articleModel = nil;
    if (section == 0) {
        articleModel = _topListModel.articleList[row];
    }
    else {
        articleModel = _articleListModel.articleList[row];
    }
    
    self.shareObj = articleModel;
    [_shareView show];
    
}

- (void)browseAuthor:(UIButton*)btn {

    NSInteger section = [[btn.stringTag componentsSeparatedByString:@","].firstObject integerValue];
    NSInteger row = [[btn.stringTag componentsSeparatedByString:@","].lastObject integerValue];
    GArticleModel *articleModel = nil;
    
    if (section == 0) {
        articleModel = _topListModel.articleList[row];
    }
    else {
        articleModel = _articleListModel.articleList[row];
    }
 
    
    PersonCenterViewController *personVC = [[PersonCenterViewController alloc] init];
    personVC.keyword = articleModel.userInfo.nickname;
    personVC.userId = [articleModel.userInfo.userId integerValue];
    [self.navigationController pushViewController:personVC animated:YES];
    
}


- (void)commentAction:(UIButton*)btn {

    NSInteger section = [[btn.stringTag componentsSeparatedByString:@","].firstObject integerValue];
    NSInteger row = [[btn.stringTag componentsSeparatedByString:@","].lastObject integerValue];
    GArticleModel *articleModel = nil;
    
    if (section == 0) {
        articleModel = _topListModel.articleList[row];
    }
    else {
        articleModel = _articleListModel.articleList[row];
    }
    
//    CommentViewController *commentVC = [[CommentViewController alloc] init];
//    commentVC.articleModel = articleModel;
//    [self.navigationController pushViewController:commentVC animated:YES];
    
}

- (void)praiseAction:(UIButton*)btn {

    if (![UserDefaultsUtil isContainUserDefault]) {
        
        [self showReLoginVC];
        return;
    }
    
    
    NSInteger section = [[btn.stringTag componentsSeparatedByString:@","].firstObject integerValue];
    NSInteger row = [[btn.stringTag componentsSeparatedByString:@","].lastObject integerValue];
    GArticleModel *articleModel = nil;
    
    if (section == 0) {
        articleModel = _topListModel.articleList[row];
    }
    else {
        articleModel = _articleListModel.articleList[row];
    }
    
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    
    DoZanApi *zanApi = [[DoZanApi alloc] init];
    [zanApi doZanWithType:1 relationId:articleId callback:^(id resultData, NSInteger code) {
        if (code == 0) {
            
            articleModel.isZan = resultData[@"is_zan"];
            NSString *zanNumStr = [NSString stringWithFormat:@"%@", resultData[@"zan_num_str"]];
            zanNumStr = [zanNumStr stringByReplacingOccurrencesOfString:@"+" withString:@""];
            articleModel.zanNum = zanNumStr;
            
            [_collectView reloadData];
        }
        else {
            
            [self showErrorMsg:resultData[@"msg"]];
        }
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 0) {
     
        return _topListModel.articleList.count;
    }
    else {
        return _articleListModel.articleList.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 置顶
    if (indexPath.section == 0) {
    
       HomeRecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identiferRecCell forIndexPath:indexPath];
        
        GArticleModel *articleModel = _topListModel.articleList[indexPath.row];
        cell.articleModel = articleModel;
    
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];

        
        // section row
        cell.shareBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.commentBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.praiseBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];

        cell.headerBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];

        
       // browseAuthor
        
        return cell;
    }
   
    
    GArticleModel *articleModel = _articleListModel.articleList[indexPath.row];
    
    // 切换选择状态
    if (_isSelect) {
        
        HomeHorizonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identiferHorizonCell forIndexPath:indexPath];
        cell.articleModel = articleModel;
        
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];

        
        // section row
        cell.shareBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.commentBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.praiseBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.headerBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];

        
        return cell;
    }
    else {
        
        HomeVerticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identiferVerticalCell forIndexPath:indexPath];
        cell.articleModel = articleModel;
        
        [cell.shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.headerBtn addTarget:self action:@selector(browseAuthor:) forControlEvents:UIControlEventTouchUpInside];

        
        // section row
        cell.shareBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.commentBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        
        cell.praiseBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];
        cell.headerBtn.stringTag = [NSString stringWithFormat:@"%li,%li", indexPath.section, indexPath.row];

        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
    // 顶部
    if (indexPath.section == 0) {
        
        return CGSizeMake(kScreenWidth, kScreenWidth/kRectImgScale + 90 + 50);
    }
    
    // 底部
    CGSize itemSize = CGSizeZero;
    if (_isSelect) {
        
        itemSize =CGSizeMake(kScreenWidth, 126);
    }
    else {
        
        CGFloat itemWidth = (kScreenWidth-5)/2.0;
        itemSize = CGSizeMake(itemWidth, itemWidth + 85 + 40);
    }
    
    return itemSize;
}

//定义每个UICollectionViewcell 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

// 分组footer高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 10);
}

// 水平最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    
    if (_isSelect) {
        return 1;
    }
    else {
        return 5;
    }
    
}

// 垂直水平
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 4;
}

#pragma mark - RefreshCollectionViewDelegate
- (void)refreshCollectionViewPullDown:(BaseCollectionView *)refreshCollectionView {

    _firstRow = 0;
    [refreshCollectionView resetDataTips];
   
    [self getTopArticleList];
    //[self getArticleListWithIndex:self.tag -100];
}

- (void)refreshCollectionViewPullUp:(id)refreshCollectionView {

  //  [self getTopArticleList];

    [self getArticleListWithIndex:self.tag -100];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    GArticleModel *articleModel = nil;
    if (indexPath.section == 0) {
    
        articleModel = _topListModel.articleList[indexPath.row];
    }
    else {
        
        articleModel = _articleListModel.articleList[indexPath.row];
    }
    
    NSInteger articleId = [PASS_NULL_TO_NIL(articleModel.articleId) integerValue];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.articleId = articleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
