//
//  ArticlePushCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/5.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "ArticlePushCell.h"
#import "UIImageView+SetImageWithURL.h"
#import "MessageModel.h"
#import "UIButton+SetImageWithURL.h"


@interface ArticlePushCell ()



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *shareLabel;


@property (weak, nonatomic) IBOutlet UILabel *commentLabl;


@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;



@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end


@implementation ArticlePushCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    
    _praiseBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_unselected_big"])
    .selectImage([[UIImage imageNamed:@"ic_praise_selected_big"] imageWithColor:kAppCustomMainColor]);
    

    [_shareBtn setEnlargeEdge:5];
    [_commentBtn setEnlargeEdge:5];

    _praiseBtn.rightEdge(20).topEdge(10).bottomEdge(10);
    
    _headerBtn.lk_attribute
    .corner(10);
    
    [_headerBtn setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setMessageModel:(MessageModel *)messageModel {

    _messageModel = messageModel;
    
    _timeLabel.text = messageModel.addtimeStr;
    
    
    GArticleModel *articleModel = messageModel.articleInfo;
    
    [_imgView setYSImageWithURL:articleModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    
    _titleLabel.text = PASS_NULL_TO_NIL(articleModel.title) ? articleModel.title : @"文章已经被删除";
    
    
    NSString *shareNum = PASS_NULL_TO_NIL(articleModel.shareNum) ? articleModel.shareNum : @"0";
    NSString *commmentNum = PASS_NULL_TO_NIL(articleModel.commentNum) ? articleModel.commentNum : @"0";
    NSString *praiseNum = PASS_NULL_TO_NIL(articleModel.zanNum) ? articleModel.zanNum : @"0";

    
    _shareLabel.text = [NSString stringWithFormat:@"%@", shareNum];
    
    _commentLabl.text = [NSString stringWithFormat:@"%@", commmentNum];
    
    _praiseLabel.text = [NSString stringWithFormat:@"%@", praiseNum];


    _praiseBtn.selected = ([PASS_NULL_TO_NIL(articleModel.isZan) integerValue] == 1);
 

    
    [_headerBtn setYSImageWithURL:messageModel.articleInfo.userInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nameLabel.text = messageModel.articleInfo.userInfo.nickname;
    
}











@end
