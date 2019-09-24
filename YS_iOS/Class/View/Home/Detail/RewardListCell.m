//
//  RewardListCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RewardListCell.h"

#import "UserModel.h"
#import "UIButton+SetImageWithURL.h"


@interface RewardListCell ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *imgView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;





@end


@implementation RewardListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _imgView.lk_attribute
    .corner(15);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUserModel:(UserModel *)userModel {

    _userModel = userModel;
    
    [_imgView setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    
    _timeLabel.text = userModel.addtimeStr;

    NSString *nickName = userModel.nickname;
    NSString *moneyStr = userModel.money;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@打赏了%@金币", nickName, moneyStr];
}


@end
