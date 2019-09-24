//
//  DetailTable.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DetailTable.h"

#import "RecommondCell.h"
#import "CommentCell.h"

#import "AppDelegate.h"

#import "GArticleModel.h"

static NSString *identifierComment = @"identifierComment";
static NSString *identifierRecommend = @"identifierRecommend";


@interface DetailTable ()


@property (nonatomic, strong) UIView   *sectionHeader;
@property (nonatomic, strong) UIButton *commentBtn;



@property (nonatomic, strong) UIView *tableFooter;


@end


@implementation DetailTable

- (void)initFooter {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = kWhiteColor;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.lk_attribute
    .font(14)
    .normalTitleColor(kTextFirstLevelColor)
    .normalTitle(@"查看更多评论>>")
    .superView(view);
    
    _searchMoreComment = btn;
    
    self.tableFooterView = view;
    
    _tableFooter = view;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}


- (UIView *)sectionHeader {
    if (_sectionHeader == nil) {
        
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _sectionHeader.lk_attribute
        .backgroundColor([UIColor whiteColor]);
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(0, 0, kScreenWidth/2.0, 45);
        commentBtn.lk_attribute
        .normalTitle(@"评论（40）")
        .normalTitleColor(kTextFirstLevelColor)
        .selectTitleColor(kTextSecondLevelColor)
        .font(14)
        .tag(1000 +1)
        .event(self, @selector(changListBtnOnClicked:))
        .superView(_sectionHeader);
        
        _commentBtn = commentBtn;
        
        UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recommendBtn.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 45);
        recommendBtn.lk_attribute
        .normalTitle (@"相关文章")
        .normalTitleColor(kTextSecondLevelColor)
        .selectTitleColor(kTextFirstLevelColor)
        .font(14)
        .tag(1000 +2)
        .textAlignment(NSTextAlignmentCenter)
        .event(self, @selector(changListBtnOnClicked:))
        .superView(_sectionHeader);
        
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2.0, 0, 1, 45)];
        lineV.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(_sectionHeader);
        
        UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 1)];
        lineH.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(_sectionHeader);
        
    }
    return _sectionHeader;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        

        
        [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:identifierComment];
        
        [self registerNib:[UINib nibWithNibName:@"RecommondCell" bundle:nil] forCellReuseIdentifier:identifierRecommend];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self initFooter];
    }
    return self;
}


#pragma mark - Setter
- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
    
    NSString *total = PASS_NULL_TO_NIL(articleModel.articleCommentList.total) ? articleModel.articleCommentList.total : @"0";
    NSString *title = [NSString stringWithFormat:@"评论（%@）", total];
    [_commentBtn setTitle:title forState:UIControlStateNormal];

    [self reloadData];
}


#pragma mark - Events
- (void)praiseBtnOnClicked:(UIButton*)button {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:button SelectRowAtIndex:0];
    }
}


- (void)recBtnOnClicked:(UIButton*)button {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:button SelectRowAtIndex:0];
    }
}






- (void)changListBtnOnClicked:(UIButton*)button {

    NSInteger tag = button.tag;
    
    
    if (tag == 1001) {
    
        if (_isRecommend == NO) { return;}
        
        _isRecommend = NO;
        
        
        [self addSubview:_tableFooter];
        self.tableFooterView = _tableFooter;
        
    }
    else {
        
        if (_isRecommend == YES) { return;}
        
        _isRecommend = YES;
        
        self.tableFooterView = [[UIView alloc] init];
        [_tableFooter removeFromSuperview];
        
    }
    
    UIButton *commentBtn = [_sectionHeader viewWithTag:1000 +1];
    UIButton *recommendBtn = [_sectionHeader viewWithTag:1000 +2];
    
    commentBtn.selected = !commentBtn.selected;
    recommendBtn.selected = !recommendBtn.selected;
    
    

    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    if (_isRecommend) {
        return (_articleModel.otherArticleList.count+1)/2;
    }
    
    return _articleModel.articleCommentList.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isRecommend) {
        
        
        RecommondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRecommend forIndexPath:indexPath];
       
        GArticleModel *leftModel = _articleModel.otherArticleList[indexPath.row*2];
        
        
        [cell.leftBtn addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareBtn1 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentBtn1 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.praiseBtn1 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.headerBtn1 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];

        
        
        cell.leftBtn.stringTag = [NSString stringWithFormat:@"RecPraiseDetail,0,%li", indexPath.row*2];
        cell.shareBtn1.stringTag = [NSString stringWithFormat:@"RecShare,0,%li", indexPath.row*2];
        cell.commentBtn1.stringTag = [NSString stringWithFormat:@"RecComment,0,%li", indexPath.row*2];
        cell.praiseBtn1.stringTag = [NSString stringWithFormat:@"RecPraise,0,%li", indexPath.row*2];

        cell.headerBtn1.stringTag = [NSString stringWithFormat:@"RecAuthor,0,%li", indexPath.row*2];

        
        GArticleModel *rightModel = nil;
        NSInteger count = _articleModel.otherArticleList.count;
        if (indexPath.row*2+1 < count) {
            rightModel = _articleModel.otherArticleList[indexPath.row*2+1];
            
            
            
            [cell.rightBtn addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn2 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentBtn2 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.praiseBtn2 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.headerBtn2 addTarget:self action:@selector(recBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];

            
            cell.rightBtn.stringTag = [NSString stringWithFormat:@"RecPraiseDetail,0,%li", indexPath.row*2 +1];
            cell.shareBtn2.stringTag = [NSString stringWithFormat:@"RecShare,0,%li", indexPath.row*2 +1];
            cell.commentBtn2.stringTag = [NSString stringWithFormat:@"RecComment,0,%li", indexPath.row*2 +1];
            cell.praiseBtn2.stringTag = [NSString stringWithFormat:@"RecPraise,0,%li", indexPath.row*2 +1];
            cell.headerBtn2.stringTag = [NSString stringWithFormat:@"RecAuthor,0,%li", indexPath.row*2 +1];

        }

        
        
        cell.leftModel = leftModel;
        cell.rightModel = rightModel;
        
        
        return cell;
    }
    else {

        CommentCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierComment forIndexPath:indexPath];
        
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.praiseBtn.stringTag = [NSString stringWithFormat:@"PraiseComment,%li,%li", indexPath.section, indexPath.row];
        
        cell.commentModel = _articleModel.articleCommentList.commentList[indexPath.row];
        
        return cell;
    }

}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isRecommend) {
        
        
        return (kScreenWidth-5)/2 + 95+5 + 30;// 285;
    }
    else {
        
        
        CommentModel *commentModel = _articleModel.articleCommentList.commentList[indexPath.row];
        
        NSString *content = commentModel.contents;
        
        NSString *parentStr = @"";
        CommentModel *parentInfo = PASS_NULL_TO_NIL(commentModel.parentInfo);
        if (parentInfo) {
            
            parentStr = [NSString stringWithFormat:@"%@: %@", parentInfo.nickname,parentInfo.contents];
        }
        
        
        return [CommentCell getCellHeightWithContent:content parentContent:parentStr];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 45;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.sectionHeader;
}


@end
