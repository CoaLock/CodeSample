//
//  DetailBottomView.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "DetailBottomView.h"
#import "GArticleModel.h"


@interface DetailBottomView ()

@property (weak, nonatomic) IBOutlet UIView *textBgView;




@end


@implementation DetailBottomView



- (void)awakeFromNib {

    [super awakeFromNib];
    
    
    _textBgView.lk_attribute
    .corner(kBorderCorner)
    .border(kSeperateLineColor, 1);
    
    _editBtn.rightEdge(kScreenWidth-(375 -166)).leftEdge(30).topEdge(5).bottomEdge(5);
 
    
    _collectBtn.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_wzxqsckblack"])
    .selectImage([[UIImage imageNamed:@"ic_wzxqscs"] imageWithColor:kAppCustomMainColor]);
    
    
    [_commentBtn setEnlargeEdge:5];
    [_shareBtn setEnlargeEdge:5];
    [_collectBtn setEnlargeEdge:5];
    [_standbyBtn setEnlargeEdge:5];

}



- (void)setArticleModel:(GArticleModel *)articleModel {
    
    _articleModel = articleModel;
    
    _collectBtn.selected = [PASS_NULL_TO_NIL(_articleModel.isCollect) integerValue] ==1;

}













@end
