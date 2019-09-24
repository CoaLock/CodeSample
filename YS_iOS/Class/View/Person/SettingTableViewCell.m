//
//  SettingTableViewCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/24.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "SettingTableViewCell.h"
#import <SDImageCache.h>

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initWithSubviews];
    }
    return self;
}

- (void)initWithSubviews {

    _rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_return_right_gray"]];
    
    [self.contentView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        
    }];
    
    _pushSwitch = [[UISwitch alloc] init];
    
    BOOL isOn = [[UIApplication sharedApplication] currentUserNotificationSettings].types == UIRemoteNotificationTypeNone ? NO: YES;
    
    [_pushSwitch setOn:isOn animated:YES];
    
    [self.contentView addSubview:_pushSwitch];
    [_pushSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(35);
        make.centerY.mas_equalTo(0);
        
    }];
    
    //获取缓存大小
    NSInteger cacheSize = [SDImageCache sharedImageCache].getSize;
    
    _cacheLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%.1lfM",cacheSize/1024.0/1024.0] textColor:kBlackColor textFont:12.0];
    
    _cacheLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_cacheLabel];
    [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.width.mas_lessThanOrEqualTo(150);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        
    }];
    
    
    _titleLabel = [UILabel labelWithText:@"" textColor:kTextFirstLevelColor textFont:16.0];
    
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.width.mas_lessThanOrEqualTo(200);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenWidth, 1)];
    
    lineView.backgroundColor = kSeperateLineColor;
    
    [self.contentView addSubview:lineView];
}

@end
