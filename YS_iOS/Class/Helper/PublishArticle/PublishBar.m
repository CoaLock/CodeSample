//
//  PublishBar.m
//  b2c_user_ios
//
//  Created by 崔露凯 on 16/11/14.
//  Copyright © 2016年 cuilukai. All rights reserved.
//

#import "PublishBar.h"


@interface PublishBar ()


@property (weak, nonatomic) IBOutlet UIButton *selectImg;


@end


@implementation PublishBar



- (void)awakeFromNib {
    [super awakeFromNib];

    self.layer.borderColor = kSeperateLineColor.CGColor;
    self.layer.borderWidth = 1;

    [self.selectImg addTarget:self action:@selector(selectImgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _selectImg.leftEdge(30).rightEdge(100);
}


- (void)selectImgAction:(UIButton*)btn {

    if (_eventBlock) {
        _eventBlock(PublishBarEventSelectImg);
    }
}


@end
