//
//  FocusDetailCollectionView.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FocusDetailCollectionView.h"

//#import "FocusDetailCollectionViewCell.h"


#import "TopicModel.h"

#import "HomeVerticalCell.h"



static NSString * focusDetailCellId = @"focusDetailCellid";


@interface FocusDetailCollectionView () <UIScrollViewDelegate, RefreshCollectionViewDelegate>

@property (nonatomic , strong) DetailTableHeaderView *detailTableHeaderView;

/** 是否有头部视图*/
@property (nonatomic , assign) BOOL isHaveTopView;


@end

@implementation FocusDetailCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout detailCellClick:(FocusDetailCellClick)detailCellClick scrollBlock:(FocusDetailScrollBlock)scrollBlock {
    if (self = [super initWithFrame: frame collectionViewLayout:layout]) {
        
        self.backgroundColor = kBackgroundColor;
        
        self.focusDetailCellClick = detailCellClick;
        self.scrollBlock = scrollBlock;
        self.isHaveTopView = YES;
        
        [self setupCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout detailCellClick:(FocusDetailCellClick)detailCellClick {
    if (self = [super initWithFrame: frame collectionViewLayout:layout]) {
        
        self.focusDetailCellClick = detailCellClick;
        self.isHaveTopView = NO;
        [self setupCollectionView];
    }
    return self;
}


- (void)setupCollectionView {
    
    [self registerNib:[UINib nibWithNibName:@"HomeVerticalCell" bundle:nil] forCellWithReuseIdentifier:focusDetailCellId];
    
     [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
}


#pragma mark - Events
- (void)buttonOnClicked:(UIButton*)button {

    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshCollectionViewButtonClick:WithButton:SelectRowAtIndexPath:)]) {
        
        [self.refreshDelegate refreshCollectionViewButtonClick:self WithButton:button SelectRowAtIndexPath:[NSIndexPath indexPathWithIndex:0]];
    }
}

#pragma mark - Setter 
- (void)setTopicModel:(TopicModel *)topicModel {
    _topicModel = topicModel;
    
    [self reloadData];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _topicModel.articleListModel.articleList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeVerticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:focusDetailCellId forIndexPath:indexPath];
    
    GArticleModel *articleModel = _topicModel.articleListModel.articleList[indexPath.row];
    cell.articleModel = articleModel;
    
    
    [cell.shareBtn addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentBtn addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.praiseBtn addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headerBtn addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    // section row
    cell.shareBtn.stringTag = [NSString stringWithFormat:@"Share,%li,%li", indexPath.section, indexPath.row];
    
    cell.commentBtn.stringTag = [NSString stringWithFormat:@"Comment,%li,%li", indexPath.section, indexPath.row];
    
    cell.praiseBtn.stringTag = [NSString stringWithFormat:@"Praise,%li,%li", indexPath.section, indexPath.row];
    
    cell.headerBtn.stringTag = [NSString stringWithFormat:@"Author,%li,%li", indexPath.section, indexPath.row];

    
    return cell;
}




#pragma mark - collectionCell的宽和高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (kScreenWidth - 5)/2.0;
    return CGSizeMake(width, width + 85 + 40);
}

#pragma mark - 定义collection的左右边距

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (self.isHaveTopView == NO) {
        return CGSizeMake(0, 0);
    }
    
    if (section == 0) {
        CGSize size = {kScreenWidth,kHeight(175)};
        return size;
    }
    
    return CGSizeMake(0, 0);
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isHaveTopView == NO) {
        return nil;
    }
    GrassWeakSelf;
    if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
            
            if (_detailTableHeaderView == nil) {
                
                DetailTableHeaderView * detailTableHeaderView = [[DetailTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeight(175)) focusButtonBlock:weakSelf.focusDetailButtoBlock];
                
                [headerView addSubview:detailTableHeaderView];
                _detailTableHeaderView = detailTableHeaderView;
            }
            
            _detailTableHeaderView.topicModel = _topicModel;
        
            return headerView;
        }
    }
        
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_scrollBlock) {
        _scrollBlock(scrollView.contentOffset.y, nil);
    }
}


@end
