//
//  UserInfoTableViewCell.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2016/11/23.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "UserInfoTableViewCell.h"


@interface UserInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation UserInfoTableViewCell


- (void)setContent:(NSString *)content {

    if (content.length > 0) {
        
        _contentLabel.text = content;
        _contentLabel.textColor = kTextFirstLevelColor;
    }
    else {
        
        _contentLabel.textColor = kTextThirdLevelColor;
        _contentLabel.text = @"未设置";
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];

    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}






@end
