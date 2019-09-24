//
//  NavLeftHeader.m
//  YS_iOS
//
//  Created by 崔露凯 on 16/11/21.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "NavLeftHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "UserModel.h"

#import "UIImageView+SetImageWithURL.h"

@interface NavLeftHeader ()

@property (nonatomic, strong) UIImageView *imgView;



@end

@implementation NavLeftHeader



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 36, 36)];
        _imgView.lk_attribute
        .corner(18)
        .border(kWhiteColor, 1)
        .image([UIImage imageNamed:@"pl_header"])
        .superView(self);
      
        _msgDot = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _msgDot.center = CGPointMake(_imgView.right - 4, _imgView.top +4);
        _msgDot.layer.cornerRadius = 4;
        _msgDot.layer.masksToBounds = YES;
        _msgDot.backgroundColor = [UIColor redColor];
        
        
        [self addSubview:_msgDot];
        
    }
    return self;
}



- (void)loadUserInfo:(UserModel*)userModel {

    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:userModel.headimgurl] placeholderImage:[UIImage imageNamed:@"pl_header"]];
   // [_imgView setYSImageWithURL:userModel.headimgurl placeHolderImage:[UIImage imageNamed:@"pl_header"]];
}













@end
