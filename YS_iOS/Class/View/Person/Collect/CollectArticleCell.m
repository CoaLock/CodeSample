//
//  CollectArticleCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/2.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CollectArticleCell.h"
#import "UIImageView+SetImageWithURL.h"
#import "GArticleModel.h"

#import "UIButton+SetImageWithURL.h"

#import "DoShareApi.h"

@interface CollectArticleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;




@property (weak, nonatomic) IBOutlet UILabel *shareLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@end


@implementation CollectArticleCell

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


- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
    
    
    
    [_imgView setYSImageWithURL:articleModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    
    _titleLabel.text = articleModel.title;
    
    _shareLabel.text = [NSString stringWithFormat:@"%@", articleModel.shareNum];
    
    _commentLabel.text = [NSString stringWithFormat:@"%@", articleModel.commentNum];
    
    _praiseLabel.text = [NSString stringWithFormat:@"%@", articleModel.zanNum];
    
    _praiseBtn.selected = ([PASS_NULL_TO_NIL(articleModel.isZan) integerValue] == 1);
    
//    NSString *passTime = articleModel.passTime;
//    NSString *timeStr = [NSString stringFromTimeStamp:passTime formatter:@"MM月dd号"];
    
    _timeLabel.text = articleModel.addtimeStr;
    
    
    [_headerBtn setYSImageWithURL:_articleModel.userInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nameLabel.text = _articleModel.userInfo.nickname;
}



@end
