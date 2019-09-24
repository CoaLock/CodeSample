//
//  SettingTableView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingTableViewCell.h"

@implementation SettingTableView

static NSString *identifierCell = @"identifierCel";

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style settingBlock:(SettingBlock)settingBlock {

    if (self = [super initWithFrame:frame style:style]) {
        
        _settingBlock = settingBlock;
        
        self.backgroundColor = kBackgroundColor;

        [self registerClass:[SettingTableViewCell class] forCellReuseIdentifier:identifierCell];
        
        [self initWithFooterView];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    
    return self;
}

#pragma mark - Init

- (void)initWithFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *signOutBtn = [UIButton buttonWithTitle:@"退出登录" titleColor:kAuxiliaryTipColor backgroundColor:kWhiteColor titleFont:16.0];
    
    [signOutBtn addTarget:self action:@selector(clickSettingSignOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:signOutBtn];
    [signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(10);
    }];
    
    self.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        
        return 2;
    }
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell forIndexPath:indexPath];
    
    NSArray *titleArray = @[@[@"修改密码", @"修改手机号"], @[@"消息推送设置", @"清理缓存"], @[@"分享草根小草app", @"客服电话", @"意见反馈", @"关于我们"]];
    
    cell.titleLabel.text = titleArray[indexPath.section][indexPath.row];
    
    cell.pushSwitch.hidden = indexPath.section == 1 && indexPath.row == 0 ? NO: YES;
    cell.rightIcon.hidden = indexPath.section != 1 ? NO: YES;
    cell.cacheLabel.hidden = indexPath.section == 1 && indexPath.row == 1 ? NO: YES;
    
    //获取缓存大小
    NSInteger cacheSize = [SDImageCache sharedImageCache].getSize;
    
    cell.cacheLabel.text = [NSString stringWithFormat:@"%.1lfM",cacheSize/1024.0/1024.0];
    
    BOOL canPush = [[UIApplication sharedApplication] currentUserNotificationSettings].types  != UIRemoteNotificationTypeNone;
    BOOL isPush = (_isPush && canPush);
    cell.pushSwitch.on = isPush;
    
    
    [cell.pushSwitch addTarget:self action:@selector(clickSettingSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_settingBlock) {
        
        switch (indexPath.section) {
            case 0:
                
                _settingType = indexPath.row == 0 ? SettingTypeChangePassword: SettingTypeChangeMobile;
                break;
            
            case 1:
                
                _settingType = indexPath.row == 0 ? 10: SettingTypeClearCache;
                break;
                
            case 2:
                
                _settingType = indexPath.row + 4;
                break;
                
            default:
                break;
        }
        _settingBlock(_settingType, nil);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
}

#pragma mark - Events

- (void)clickSettingSignOut:(UIButton *)sender {

    if (_settingBlock) {
        
        _settingBlock(SettingTypeSignOut, nil);
    }
}

- (void)clickSettingSwitch:(UISwitch *)sender {
    
    if (sender.on) {
        
        if (_settingBlock) {
            
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
                
                sender.on = NO;
                
                _settingBlock(SettingTypeNoPush, nil);
                
            }
            else {
                
                _settingBlock(SettingTypePush, @(sender.on));
                
            }
        }
    }
    else {
    
        if (_settingBlock) {
            
            _settingBlock(SettingTypePush, @(sender.on));
        }
    }
}


#pragma mark - Setter
- (void)setIsPush:(BOOL)isPush {
    _isPush = isPush;

    [self reloadData];
}




@end
