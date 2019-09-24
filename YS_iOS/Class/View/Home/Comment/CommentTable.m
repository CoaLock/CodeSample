//
//  CommentTable.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//


#import "CommentTable.h"
#import "CommentCell.h"

#import "CommentModel.h"


static NSString *identifierComment = @"identifierComment";

@interface CommentTable ()


@property (nonatomic, strong) UIView *sectionHeader;

@property (nonatomic, strong) UIButton *commentBtn;




@end


@implementation CommentTable


- (UIView *)sectionHeader {
    if (_sectionHeader == nil) {
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _sectionHeader.lk_attribute
        .backgroundColor(kWhiteColor);
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(0, 7, kScreenWidth, 30);
        commentBtn.lk_attribute
        .normalTitle(@"评论 (40)")
        .normalTitleColor(kTextFirstLevelColor)
        .font(14)
        .event(self, @selector(commentBtnOnClicked:))
        .superView(_sectionHeader);
        
        _commentBtn = commentBtn;
        
        UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
        lineH.lk_attribute
        .backgroundColor(kSeperateLineColor)
        .superView(_sectionHeader);
        
    }
    return _sectionHeader;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self =[super initWithFrame:frame style:style ]) {
        
        [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:identifierComment];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}


#pragma mark - Private
- (void)setCommentListModel:(CommentListModel *)commentListModel {
    _commentListModel = commentListModel;
    
    
    //
    NSString *total = PASS_NULL_TO_NIL(_commentListModel.total) ?  _commentListModel.total : @"0";
    [_commentBtn setTitle:[NSString stringWithFormat:@"评论 (%@)",total] forState:UIControlStateNormal];
    
    [self reloadData];
}


#pragma mark - Events
- (void)commentBtnOnClicked:(UIButton*)button {
    
    //[self reloadData];
}

- (void)praiseBtnOnClicked:(UIButton*)button {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:button SelectRowAtIndex:0];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _commentListModel.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierComment forIndexPath:indexPath];
    
    CommentModel *commentModel = _commentListModel.commentList[indexPath.row];
    
    cell.commentModel = commentModel;
    
    
    [cell.praiseBtn addTarget:self action:@selector(praiseBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseBtn.stringTag = [NSString stringWithFormat:@"PraiseComment,%li,%li", indexPath.section, indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *commentModel = _commentListModel.commentList[indexPath.row];

    NSString *content = commentModel.contents;
    
    NSString *parentStr = @"";
    CommentModel *parentInfo = PASS_NULL_TO_NIL(commentModel.parentInfo);
    if (parentInfo) {
        
        parentStr = [NSString stringWithFormat:@"%@: %@", parentInfo.nickname,parentInfo.contents];
    }
    
    return [CommentCell getCellHeightWithContent:content parentContent:parentStr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.sectionHeader;
}


@end
