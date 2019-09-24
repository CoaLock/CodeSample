//
//  PersonFocusTopicCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PersonFocusTopicCell.h"

#import "UIImageView+SetImageWithURL.h"
#import "TopicModel.h"

@interface PersonFocusTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (weak, nonatomic) IBOutlet UILabel *attentLabel;



@end


@implementation PersonFocusTopicCell


- (void)setTopicModel:(TopicModel *)topicModel {

    _topicModel = topicModel;
    
    
    [_imgView setYSImageWithURL:topicModel.basePic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    
    _titleLabel.text = topicModel.title;
    
    
    _desc.text = topicModel.desc;
    

    NSString *attentStr = [NSString stringWithFormat:@"%@ 关注", topicModel.fansNum];
    _attentLabel.text = attentStr;
    
    
    _attentBtn.selected = [PASS_NULL_TO_NIL(topicModel.isFollow) integerValue] ==1;

}



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





@end
