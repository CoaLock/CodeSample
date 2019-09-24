//
//  RecommondCell.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/26.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "RecommondCell.h"

#import "GArticleModel.h"
#import "UIImageView+SetImageWithURL.h"
#import "UIButton+SetImageWithURL.h"

@interface RecommondCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imgVIew1;



@property (weak, nonatomic) IBOutlet UIView *bottomBg1;
@property (weak, nonatomic) IBOutlet UILabel *titleL1;



@property (weak, nonatomic) IBOutlet UIImageView *imgVIew2;


@property (weak, nonatomic) IBOutlet UIView *bottomBg2;
@property (weak, nonatomic) IBOutlet UILabel *titleL2;



@end



@implementation RecommondCell


- (void)awakeFromNib {
    [super awakeFromNib];
    

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    _praiseBtn1.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_unselected_big"])
    .selectImage([[UIImage imageNamed:@"ic_praise_selected_big"] imageWithColor:kAppCustomMainColor]);
   
    
    _praiseBtn2.lk_attribute
    .normalImage([UIImage imageNamed:@"ic_praise_unselected_big"])
    .selectImage([[UIImage imageNamed:@"ic_praise_selected_big"] imageWithColor:kAppCustomMainColor]);

    
    _headerBtn1.lk_attribute
    .corner(10);
    _headerBtn2.lk_attribute
    .corner(10);
    [_headerBtn1 setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];
    [_headerBtn2 setEnlargeEdgeWithTop:10 right:50 bottom:10 left:10];
}



- (void)setLeftModel:(GArticleModel *)leftModel {

    _leftModel = leftModel;

    
    [_imgVIew1 setYSImageWithURL:leftModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];

    
    _titleL1.text = leftModel.title;
    
    _shareLabel1.text = leftModel.shareNum;
    
    _commnetLabel1.text = leftModel.commentNum;
    
    _praiseL1.text = leftModel.zanNum;
    
    
    _praiseBtn1.selected = [PASS_NULL_TO_NIL(leftModel.isZan) integerValue] ==1;
    
    
    [_headerBtn1 setYSImageWithURL:leftModel.userInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nameLabel1.text = leftModel.userInfo.nickname;
}


-(void)setRightModel:(GArticleModel *)rightModel {

    _rightModel = rightModel;
    
    
    _imgVIew2.hidden = (rightModel == nil);
    _bottomBg2.hidden = (rightModel == nil);


    [_imgVIew2 setYSImageWithURL:rightModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    
    _titleL2.text = rightModel.title;
    
    _shareLabel2.text = rightModel.shareNum;
    
    _commnetLabel2.text = rightModel.commentNum;
    
    _praiseL2.text = rightModel.zanNum;
    
    
    _praiseBtn2.selected = [PASS_NULL_TO_NIL(rightModel.isZan) integerValue] ==1;
 
    [_headerBtn2 setYSImageWithURL:rightModel.userInfo.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
    
    _nameLabel2.text = rightModel.userInfo.nickname;

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}








@end
