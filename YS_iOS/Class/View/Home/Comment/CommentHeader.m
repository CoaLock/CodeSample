//
//  CommentHeader.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/28.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "CommentHeader.h"
#import "UIImageView+SetImageWithURL.h"

#import "GArticleModel.h"


@interface CommentHeader ()


@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end



@implementation CommentHeader


- (void)awakeFromNib {
    [super awakeFromNib];

}



- (void)setArticleModel:(GArticleModel *)articleModel {
    
    _articleModel = articleModel;
    
    [_headIcon setYSImageWithURL:articleModel.smallPic placeHolderImage:[UIImage imageNamed:@"pl_square_img"]];
    
    _titleLabel.text = articleModel.title;

}









@end
