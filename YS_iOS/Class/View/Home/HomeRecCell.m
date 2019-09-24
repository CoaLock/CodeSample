//
//  HomeRecCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "HomeRecCell.h"
#import "ArticleModel.h"

#import "GArticleModel.h"
#import "UIImageView+SetImageWithURL.h"
#import "UIButton+SetImageWithURL.h"

@interface HomeRecCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *praiseLabel;




@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation HomeRecCell

- (void)awakeFromNib {
    [super awakeFromNib];


    _headerBtn.lk_attribute
    .corner(15);
    
    [_headerBtn setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];

    
    _praiseBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_unselected_big"])
    .selectImage([[UIImage imageNamed:@"ic_praise_selected_big"] imageWithColor:kAppCustomMainColor]);

    [_praiseBtn setEnlargeEdge:10];
    [_shareBtn setEnlargeEdge:10];
    [_commentBtn setEnlargeEdge:10];
}


- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
    
    _titleLabel.text = articleModel.title;

    
    [_imgView setYSImageWithURL:_articleModel.bigPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    [_shareBtn setTitle:[NSString stringWithFormat:@" %@", articleModel.shareNum] forState:UIControlStateNormal];
    
    [_commentBtn setTitle:[NSString stringWithFormat:@" %@", articleModel.commentNum] forState:UIControlStateNormal];
    
    _praiseLabel.text = [NSString stringWithFormat:@"%@", articleModel.zanNum];
    
    
    _timeLabel.text = articleModel.passTimeStr;
    
    _praiseBtn.selected = [PASS_NULL_TO_NIL(articleModel.isZan) integerValue] == 1;
    
    
    [_headerBtn setYSImageWithURL:_articleModel.userInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nameLabel.text = _articleModel.userInfo.nickname;
    
}


@end
