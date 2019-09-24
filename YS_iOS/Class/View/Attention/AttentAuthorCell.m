//
//  AttentAuthorCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/30.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "AttentAuthorCell.h"

#import "UIImageView+SetImageWithURL.h"


@interface AttentAuthorCell ()



@property (weak, nonatomic) IBOutlet UILabel *nickNameL;
@property (weak, nonatomic) IBOutlet UILabel *descL;

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


@end



@implementation AttentAuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _attentBtn.lk_attribute
    .normalTitle(@"+关注")
    .selectTitle(@"已关注")
    .selectBackgroundImage([UIColor createImageWithColor:kTextSecondLevelColor])
    .normalBackgroundImage([UIColor createImageWithColor:kAppCustomMainColor]);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)attentaAction:(UIButton *)sender {
    
   // sender.selected = !sender.selected;
}



- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;

    [_headImgView setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nickNameL.text = userModel.nickname;
    
    _attentBtn.selected = [PASS_NULL_TO_NIL(userModel.isFollow) integerValue] == 1;
    
    NSString *articleNum = userModel.articleNumStr;
    
    _descL.text = [NSString stringWithFormat:@"%@人关注·%@篇文章", userModel.fansNum, articleNum];
    
    
}





@end
