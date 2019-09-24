//
//  PublishImgCell.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/11.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishImgCell.h"

#import <Masonry.h>

@interface PublishImgCell ()



@end

@implementation PublishImgCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;


        
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgView];
        
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.bottom.mas_equalTo(0);
        }];
        
        UIView *imgBgView = [[UIView alloc] init];
        imgBgView.backgroundColor = [UIColor blackColor];
        imgBgView.alpha = 0.4;
        [self.contentView addSubview:imgBgView];
        
        [imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(0);
            make.width.height.mas_equalTo(40);
        }];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"ic_close_service"] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteBtn];
     
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.height.mas_equalTo(20);
            make.right.mas_equalTo(-21);
            make.top.mas_equalTo(9);
        }];
        
        
        self.contentView.clipsToBounds = YES;
    
        self.clipsToBounds = YES;
        
    }
    return self;
}



- (void)setImage:(UIImage *)image {

    _image = image;
    
    
    
    
    _imgView.image = image;
}










@end
