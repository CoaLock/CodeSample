//
//  MyArticleCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/12/1.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "MyArticleCell.h"
#import "GArticleModel.h"

#import "UIImageView+SetImageWithURL.h"

@interface MyArticleCell ()



@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleView;


@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;


@end


@implementation MyArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setArticleModel:(GArticleModel *)articleModel {

    _articleModel = articleModel;
    
    [_imgView setYSImageWithURL:_articleModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_big"]];
    
    _timeLabel.text = _articleModel.addtimeStr;
    
    _titleView.text = _articleModel.title;
    
    _tipLabel.text = _articleModel.statusStr;
    
    _descLabel.text = [NSString stringWithFormat:@"转发%@·评论%@·点赞%@", articleModel.shareNum, articleModel.commentNum, articleModel.zanNum];
    
    
    NSInteger status = [PASS_NULL_TO_NIL(_articleModel.status) integerValue];
    
    // 是否是已经发布文章
    if (status == 2) {
        
        _tipLabel.hidden = YES;
        _descLabel.hidden = NO;
    }
    else {
    
        _tipLabel.hidden = NO;
        _descLabel.hidden = YES;
        
        // 是否草稿
        _tipLabel.textColor = (status == 0) ? [UIColor colorWithHexString:@"#00C99A"] :kAuxiliaryTipColor;
    
    }
    
    
}





@end
