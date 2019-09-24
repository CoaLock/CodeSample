//
//  PersonFocusAuthorCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFocusAuthorCell.h"
#import "UserModel.h"
#import "UIImageView+SetImageWithURL.h"



@interface PersonFocusAuthorCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *desc;



@end


@implementation PersonFocusAuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _attentBtn.lk_attribute
    .corner(4)
    .normalBackgroundImage([UIColor createImageWithColor:kAppCustomMainColor])
    .selectBackgroundImage([UIColor createImageWithColor:kTextSecondLevelColor])
    .normalTitle(@"+关注")
    .selectTitle(@"已关注");
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserModel:(UserModel *)userModel {

    _userModel = userModel;
    
    [_imgView setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nickName.text = userModel.nickname;
    
    _desc.text = userModel.signature;
    
    _attentBtn.selected = ([PASS_NULL_TO_NIL(userModel.isFollow) integerValue] ==1);
}



@end
