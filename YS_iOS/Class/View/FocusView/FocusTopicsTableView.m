//
//  FocusTopicsTableView.m
//  YS_iOS
//
//  Created by 张阳 on 16/11/22.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "FocusTopicsTableView.h"
#import "FocusTopicsTableViewCell.h"


static NSString * topicsId = @"topicsId";

@implementation FocusTopicsTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        
        [self registerClass:[FocusTopicsTableViewCell class] forCellReuseIdentifier:topicsId];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - Setter
- (void)setTopicListModel:(TopicListModel *)topicListModel {
    
    _topicListModel = topicListModel;
    
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_topicListModel.followList.count > 0) {
        return _topicListModel.followList.count;
    }
    
    return _topicListModel.topicList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FocusTopicsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topicsId forIndexPath:indexPath];
    cell.focusButton.stringTag = [NSString stringWithFormat:@"Focus,0,%li", indexPath.section];
    
    [cell.focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    TopicModel *topicModel = _topicListModel.topicList[indexPath.section];
    if (_topicListModel.followList.count > 0) {
         topicModel = _topicListModel.followList[indexPath.section];
    }
    
    cell.topicModel = topicModel;
    
    
    for (NSInteger i = 0; i < cell.scrollImageArray.count; i ++ ) {
        
        // 文章背景
        UIControl *scrollImage = cell.scrollImageArray[i];
        [scrollImage addTarget:self action:@selector(getDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        scrollImage.stringTag = [NSString stringWithFormat:@"ArticleDetai,%li,%li", indexPath.section, i];
        
        scrollImage.tag = 2000*indexPath.section + i;
        
        // 分享
        ((UIButton*)cell.shareButtonArray[i]).stringTag = [NSString stringWithFormat:@"Share,%li,%li", indexPath.section, i];
        [cell.shareButtonArray[i] addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        // 评论
        ((UIButton*)cell.imAnswerButtonArray[i]).stringTag = [NSString stringWithFormat:@"Comment,%li,%li", indexPath.section, i];;
        [cell.imAnswerButtonArray[i] addTarget:self action:@selector(imAnswerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 335;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - Events
- (void)focusButtonClick:(UIButton*)focusButton {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:focusButton SelectRowAtIndex:0];
    }
}

- (void)getDetailAction:(UIControl*)sender {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:sender SelectRowAtIndex:0];
    }
}

- (void)shareButtonClick:(UIButton*)shareButton {
    
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
          [self.refreshDelegate refreshTableViewButtonClick:self WithButton:shareButton SelectRowAtIndex:0];
    }
}


- (void)imAnswerButtonClick:(UIButton*)imAnswerButton {
    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:imAnswerButton SelectRowAtIndex:0];
    }
}


@end
