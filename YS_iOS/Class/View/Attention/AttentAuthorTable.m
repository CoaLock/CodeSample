//
//  AttentAuthorTable.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/30.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentAuthorTable.h"
#import "AttentAuthorCell.h"

#import "UserModel.h"

static NSString *identifierCell = @"identifierCell";


@interface AttentAuthorTable ()



@end


@implementation AttentAuthorTable



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        
        [self registerNib:[UINib nibWithNibName:@"AttentAuthorCell" bundle:nil] forCellReuseIdentifier:identifierCell];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return self;
}


#pragma mark - Setter
- (void)setUserListModel:(UserListModel *)userListModel {

    _userListModel = userListModel;
    
    [self reloadData];
}


#pragma mark - Event
- (void)attentUser:(UIButton*)btn {

    if ([self.refreshDelegate respondsToSelector:@selector(refreshTableViewButtonClick:WithButton:SelectRowAtIndex:)]) {
        
        [self.refreshDelegate refreshTableViewButtonClick:self WithButton:btn SelectRowAtIndex:btn.tag -1000];
    }

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _userListModel.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    AttentAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    cell.userModel = _userListModel.userList[indexPath.row];
    
    [cell.attentBtn addTarget:self action:@selector(attentUser:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.attentBtn.tag = 1000 + indexPath.row;
    
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}










@end
